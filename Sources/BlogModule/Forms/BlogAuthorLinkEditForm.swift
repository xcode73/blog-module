//
//  BlogAuthorLinkEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorLinkEditForm: FeatherForm {
    
    var context: FeatherFormContext<BlogAuthorLinkModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "label")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Label is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.label }
                .write { context.model?.label = $1.input },
                
            TextField(key: "url")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "URL is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.url }
                .write { context.model?.url = $1.input },

            TextField(key: "priority")
                .config { $0.output.value = String(100) }
                .read { $1.output.value = String(context.model?.priority ?? 100) }
                .write { context.model?.priority = Int($1.input) ?? 100 },
        ]
    }
    
    func load(req: Request) -> EventLoopFuture<Void> {
        guard let authorId = BlogAuthorModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        let linkId = BlogAuthorLinkModel.getIdParameter(req: req)
        context.breadcrumb = [
            BlogModule.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: authorId),
            BlogAuthorLinkModel.adminLink(authorId: authorId),
            .init(label: linkId != nil ? "Edit" : "Create", url: req.url.path.safePath()),
        ]
        return context.load(req: req)
    }
}
