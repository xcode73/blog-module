//
//  BlogAuthorEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

final class BlogAuthorEditForm: ModelForm {
    typealias Model = BlogAuthorModel

    var modelId: UUID?
    var name = FormField<String>(key: "name").required().length(max: 250)
    var bio = FormField<String>(key: "bio")
    var image = FileFormField(key: "image")
    var notification: String?

    var metadata: Metadata?
    
    var fields: [FormFieldRepresentable] {
        [name, bio, image]
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
        return future
    }

    func processAfterFields(req: Request) -> EventLoopFuture<Void> {
        image.uploadTemporaryFile(req: req)
    }
    
    func read(from input: Model)  {
        name.value = input.name
        bio.value = input.bio
        image.value.originalKey = input.imageKey
    }

    func write(to output: Model) {
        output.name = name.value!
        output.bio = bio.value ?? ""
    }
    
    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        image.save(to: Model.path, req: req).map { key in
            if let key = key {
                model.imageKey = key
            }
        }
    }
}
