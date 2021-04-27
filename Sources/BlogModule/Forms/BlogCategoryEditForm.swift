//
//  BlogCategoryEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 22..
//

import FeatherCore

struct BlogCategoryEditForm: FeatherForm {
    
    var context: FeatherFormContext<BlogCategoryModel>
    
    init() {
        context = .init()
        context.form.fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            ImageField(key: "image", path: Model.assetPath)
                .read { ($1 as! ImageField).imageKey = context.model?.imageKey }
                .write { context.model?.imageKey = ($1 as! ImageField).imageKey },
            
            TextField(key: "title")
                .config { $0.output.required = true }
                .validators { [
                    FormFieldValidator($1, "Title is required") { !$0.input.isEmpty },
                ] }
                .read { $1.output.value = context.model?.title }
                .write { context.model?.title = $1.input },

            TextareaField(key: "excerpt")
                .read { $1.output.value = context.model?.excerpt }
                .write { context.model?.excerpt = $1.input },
            
            TextField(key: "color")
                .read { $1.output.value = context.model?.color }
                .write { context.model?.color = $1.input },

            TextField(key: "priority")
                .config { $0.output.value = String(100) }
                .read { $1.output.value = String(context.model?.priority ?? 100) }
                .write { context.model?.priority = Int($1.input) ?? 100 },
        ]
    }
}
