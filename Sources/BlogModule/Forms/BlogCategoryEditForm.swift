//
//  BlogCategoryEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 22..
//

import FeatherCore

final class BlogCategoryEditForm: ModelForm {

    typealias Model = BlogCategoryModel

    var modelId: UUID?
    var title = FormField<String>(key: "title").required().length(max: 250)
    var excerpt = FormField<String>(key: "excerpt")
    var color = FormField<String>(key: "color")
    var priority = FormField<Int>(key: "priority").required().min(0).max(9999)
    var image = FileFormField(key: "image")
    var notification: String?
    
    var metadata: Metadata?
    
    var fields: [FormFieldRepresentable] {
        [title, excerpt, color, priority, image]
    }

    var templateData: TemplateData {
        .dictionary([
            "modelId": modelId?.encodeToTemplateData() ?? .string(nil),
            "fields": fieldsTemplateData,
            "notification": .string(notification),
            "metadata": metadata?.templateData ?? .dictionary(nil),
        ])
    }

    init() {}

    func initialize(req: Request) -> EventLoopFuture<Void> {
        priority.value = 100

        var future = req.eventLoop.future()
        if let id = modelId {
            future = Model.findMetadata(reference: id, on: req.db).map { [unowned self] in metadata = $0 }
        }
        return future
    }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }

    func read(from input: Model)  {
        title.value = input.title
        priority.value = input.priority
        excerpt.value = input.excerpt
        color.value = input.color
        image.value.originalKey = input.imageKey
    }

    func write(to output: Model) {
        output.title = title.value!
        output.priority = priority.value!
        output.excerpt = excerpt.value ?? ""
        output.color = color.value
    }

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        image.save(to: Model.path, req: req).map { [unowned self] key in
            if image.value.delete || key != nil {
                model.imageKey = key
            }
            image.value.delete = false
        }
    }
}
