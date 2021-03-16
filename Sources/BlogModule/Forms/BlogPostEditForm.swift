//
//  BlogPostEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 02. 15..
//

import FeatherCore

final class BlogPostEditForm: ModelForm {
    typealias Model = BlogPostModel

    var modelId: UUID?
    var image = FileFormField(key: "image")
    var title = FormField<String>(key: "title").required().length(max: 250)
    var excerpt = FormField<String>(key: "excerpt").length(max: 250)
    var content = FormField<String>(key: "content")
    var categories = ArraySelectionFormField<UUID>(key: "categories")
    var authors = ArraySelectionFormField<UUID>(key: "authors")
    var notification: String?

    var metadata: Metadata?

    var fields: [FormFieldRepresentable] {
        [image, title, excerpt, content, categories, authors]
    }

    var templateData: TemplateData {
        .dictionary([
            "modelId": modelId?.encodeToTemplateData() ?? .string(nil),
            "fields": fieldsTemplateData,
            "notification": .string(notification),
            "metadata": metadata?.templateData,
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if let id = modelId {
            future = Model.findMetadata(reference: id, on: req.db).map { [unowned self] in metadata = $0 }
        }
        return req.eventLoop.flatten([
            future,
            BlogCategoryModel.query(on: req.db)
                .all()
                .mapEach(\.formFieldOption)
                .map { [unowned self] in categories.options = $0 },
            BlogAuthorModel.query(on: req.db)
                .all()
                .mapEach(\.formFieldOption)
                .map { [unowned self] in authors.options = $0 },
        ])
    }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }

    func read(from input: Model)  {
        title.value = input.title
        image.value.originalKey = input.imageKey
        excerpt.value = input.excerpt
        content.value = input.content
        categories.values = input.categories.compactMap { $0.id }
        authors.values = input.authors.compactMap { $0.id }
    }
    
    func write(to output: Model) {
        output.title = title.value!
        output.excerpt = excerpt.value ?? ""
        output.content = content.value ?? ""
    }

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        image.save(to: Model.path, req: req).map { [unowned self] key in
            if image.value.delete || key != nil {
                model.imageKey = key
            }
            image.value.delete = false
        }
    }
    
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if modelId != nil {
            future = req.eventLoop.flatten([
                BlogPostCategoryModel.query(on: req.db).filter(\.$post.$id == modelId!).delete(),
                BlogPostAuthorModel.query(on: req.db).filter(\.$post.$id == modelId!).delete(),
            ])
        }
        
        return future.flatMap { [unowned self] in
            req.eventLoop.flatten([
                categories.values.map { BlogPostCategoryModel(postId: model.id!, categoryId: $0) }.create(on: req.db),
                authors.values.map { BlogPostAuthorModel(postId: model.id!, authorId: $0) }.create(on: req.db),
            ])
        }
    }
}
