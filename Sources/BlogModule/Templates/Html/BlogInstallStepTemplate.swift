//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor
import Feather
import BlogObjects
import SwiftHtml

struct BlogInstallStepTemplate: TemplateRepresentable {
    
    var context: BlogInstallStepContext
    
    init(_ context: BlogInstallStepContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        req.templateEngine.system.index(.init(title: "Install blog")) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Install blog",
                                       excerpt: "Would you like to install sample content for the blog?")).render(req)
                    
                    FormTemplate(context.form).render(req)
                }
            }
        }
        .render(req)
    }
}
