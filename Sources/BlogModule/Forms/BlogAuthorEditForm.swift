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
        //findMetadata(on: req.db, uuid: uuid).map { form.metadata = $0 }
        return req.eventLoop.future()
    }

    func validateAfterFields(req: Request) -> EventLoopFuture<Bool> {
        //image required
        return req.eventLoop.future(true)
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
        image.save(to: Model.path, req: req).map { model.imageKey = $0! }
    }
}
