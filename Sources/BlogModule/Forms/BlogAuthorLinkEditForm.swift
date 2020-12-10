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
    var label = FormField<String>(key: "label").required().length(max: 250)
    var url = FormField<String>(key: "url").required().length(max: 250)
    var priority = FormField<Int>(key: "priority")
    var authorId = FormField<UUID>(key: "authorId")
    var notification: String?

    var fields: [FormFieldRepresentable] {
        [label, url, priority, authorId]
    }

    init() {}
    
    func initialize(req: Request) -> EventLoopFuture<Void> {
        priority.value = 100
        return req.eventLoop.future()
    }
    
    func read(from input: Model)  {
        label.value = input.label
        url.value = input.url
        priority.value = input.priority
        authorId.value = input.$author.id
    }

    func write(to output: Model) {
        output.label = label.value!
        output.url = url.value!
        output.priority = priority.value!
        output.$author.id = authorId.value!
    }
}
