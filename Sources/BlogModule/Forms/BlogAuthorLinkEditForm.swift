//
//  BlogAuthorLinkEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

final class BlogAuthorLinkEditForm: ModelForm {

    typealias Model = BlogAuthorLinkModel

    var modelId: UUID?
    var name = FormField<String>(key: "name").required().length(max: 250)
    var url = FormField<String>(key: "url").required().length(max: 250)
    var priority = FormField<Int>(key: "priority")
    var notification: String?
    
    var authorId: UUID!
    
    var leafData: LeafData {
        .dictionary([
            "modelId": modelId?.encodeToLeafData() ?? .string(nil),
            "fields": fieldsLeafData,
            "notification": .string(notification),
            "authorId": authorId.encodeToLeafData(),
        ])
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        priority.value = 100
        return req.eventLoop.future()
    }
    
    func read(from input: Model)  {
        name.value = input.name
        url.value = input.url
        priority.value = input.priority
        authorId = input.$author.id
    }

    func write(to output: Model) {
        output.name = name.value!
        output.url = url.value!
        output.priority = priority.value!
        output.$author.id = authorId
    }
}
