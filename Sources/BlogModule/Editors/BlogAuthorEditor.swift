//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Feather
import BlogApi

struct BlogAuthorEditor: FeatherModelEditor {
    let model: BlogAuthorModel
    let form: AbstractForm

    init(model: BlogAuthorModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        
        // @TODO: user proper variable name
        ImageField("image", path: "blog/author")
            .read {
                if let key = model.imageKey {
                    $1.output.context.previewUrl = $0.fs.resolve(key: key)
                }
                ($1 as! ImageField).imageKey = model.imageKey
            }
            .write { model.imageKey = ($1 as! ImageField).imageKey }
        
        InputField("name")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.name }
            .write { model.name = $1.input }
        
        TextareaField("bio")
            .read { $1.output.context.value = model.bio }
            .write { model.bio = $1.input }
        
//        HiddenField("userId")
//            .write { req, _ in model.bio = try req.getUserAccount().id.string }
    }
}

