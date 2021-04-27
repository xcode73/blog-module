//
//  BlogPostEditForm.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 02. 15..
//

import FeatherCore

struct BlogPostEditForm: FeatherForm {
    
    var context: FeatherFormContext<BlogPostModel>
    
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
            
            TextareaField(key: "content")
                .read { $1.output.value = context.model?.content }
                .write { context.model?.content = $1.input },
            
            CheckboxField(key: "categories")
                .load { req, field in
                    BlogCategoryModel.query(on: req.db).all()
                        .mapEach(\.formFieldOption)
                        .map { field.output.options = $0 }
                }
                .read { req, field in
                    field.output.values = context.model?.categories.compactMap { $0.identifier } ?? []
                }
                .save { req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    return context.model!.$categories.reAttach(ids: values, on: req.db)
                },

            CheckboxField(key: "authors")
                .load { req, field in
                    BlogAuthorModel.query(on: req.db).all()
                        .mapEach(\.formFieldOption)
                        .map { field.output.options = $0 }
                }
                .read { req, field in
                    field.output.values = context.model?.authors.compactMap { $0.identifier } ?? []
                }
                .save { req, field in
                    let values = field.input.compactMap { UUID(uuidString: $0) }
                    return context.model!.$authors.reAttach(ids: values, on: req.db)
                },
        ]
    }
}
