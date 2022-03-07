//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Feather
import BlogApi

struct BlogPostEditor: FeatherModelEditor {
    let model: BlogPostModel
    let form: AbstractForm

    init(model: BlogPostModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        
        // @TODO: user proper variable name
        ImageField("image", path: "blog/post")
            .read {
                if let key = model.imageKey {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = model.imageKey
            }
            .write { model.imageKey = ($1 as! ImageField).imageKey }
        
        InputField("title")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.title }
            .write { model.title = $1.input }
        
        TextareaField("excerpt")
            .read { $1.output.context.value = model.excerpt }
            .write { model.excerpt = $1.input }

        ContentField("content")
            .read { $1.output.context.value = model.content }
            .write { model.content = $1.input }
        
        #warning("fixme")
        CheckboxField("categories")
            .load { req, field in
                let categories = try await BlogCategoryModel.query(on: req.db).all()
                field.output.context.options = categories.map { OptionContext(key: $0.uuid.string, label: $0.title) }
            }
            .read { req, field in
                field.output.context.values = model.categories.compactMap { $0.uuid.string }
            }
//            .save { req, field in
//                let values = field.input.compactMap(\.uuid)
//                return try await model.$categories.reAttach(ids: values, on: req.db)
//            }

        CheckboxField("authors")
            .load { req, field in
                let authors = try await BlogAuthorModel.query(on: req.db).all()
                field.output.context.options = authors.map { OptionContext(key: $0.uuid.string, label: $0.name) }
            }
            .read { req, field in
                field.output.context.values = model.authors.compactMap { $0.uuid.string }
            }
//            .save { req, field in
//                let values = field.input.compactMap(\.uuid)
//                return try await model.$authors.reAttach(ids: values, on: req.db)
//            }
    }
}

