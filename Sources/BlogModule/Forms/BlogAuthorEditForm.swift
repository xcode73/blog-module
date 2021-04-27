//
//  BlogAuthorEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorEditForm: FeatherForm {
    
    var context: FeatherFormContext<BlogAuthorModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            ImageField(key: "image", path: Model.assetPath)
                .read { ($1 as! ImageField).imageKey = context.model?.imageKey }
                .write { context.model?.imageKey = ($1 as! ImageField).imageKey },
            
            TextField(key: "name")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Name is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.name }
                .write { context.model?.name = $1.input },

            TextareaField(key: "bio")
                .read { $1.output.value = context.model?.bio }
                .write { context.model?.bio = $1.input },

        ]
    }
}
