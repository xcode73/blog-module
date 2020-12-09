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
    var title = FormField<String>(key: "title").required().length(max: 250)
    var excerpt = FormField<String>(key: "excerpt").length(max: 250)
    var content = FormField<String>(key: "content")
    var categoryId = SelectionFormField<UUID>(key: "categoryId")
    var authorId = SelectionFormField<UUID>(key: "authorId")
    var image = FileFormField(key: "image")
    var notification: String?
    var metadata: FrontendMetadata?

    var leafData: LeafData {
        .dictionary([
            "modelId": modelId?.encodeToLeafData() ?? .string(nil),
            "fields": fieldsLeafData,
            "notification": .string(notification),
            "metadata": metadata?.leafData,
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        var future = req.eventLoop.future()
        if let id = modelId {
            future = Model.findMetadata(id: id, on: req.db).map { [unowned self] in metadata = $0 }
        }
        return req.eventLoop.flatten([
            future,
            BlogCategoryModel.query(on: req.db)
                .all()
                .mapEach(\.formFieldOption)
                .map { [unowned self] in categoryId.options = $0 },
            BlogAuthorModel.query(on: req.db)
                .all()
                .mapEach(\.formFieldOption)
                .map { [unowned self] in authorId.options = $0 },
        ])
    }

    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        //image required
        return req.eventLoop.future(true)
    }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }

    func read(from input: Model)  {
        title.value = input.title
        image.value.originalKey = input.imageKey
        excerpt.value = input.excerpt
        content.value = input.content
        categoryId.value = input.$category.id
        authorId.value = input.$author.id
    }
    
    func write(to output: Model) {
        output.title = title.value!
        output.excerpt = excerpt.value ?? ""
        output.content = content.value ?? ""
        output.$category.id = categoryId.value!
        output.$author.id = authorId.value!
    }

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        image.save(to: Model.path, req: req).map { model.imageKey = $0! }
    }
}
