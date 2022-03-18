//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

import Vapor
import Feather
import BlogObjects


struct BlogAuthorLinkEditor: FeatherModelEditor {
    let model: BlogAuthorLinkModel
    let form: AbstractForm

    init(model: BlogAuthorLinkModel, form: AbstractForm) {
        self.model = model
        self.form = form
    }

    @FormFieldBuilder
    func createFields(_ req: Request) -> [FormField] {
        InputField("label")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.label }
            .write { model.label = $1.input }
        
        InputField("url")
            .config {
                $0.output.context.label.required = true
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = model.url }
            .write { model.url = $1.input }
        
        InputField("priority")
            .config {
                $0.output.context.label.required = true
                $0.output.context.value = String(100)
            }
            .validators {
                FormFieldValidator.required($1)
            }
            .read { $1.output.context.value = String(model.priority) }
            .write { model.priority = Int($1.input) ?? 100 }
    }
}

