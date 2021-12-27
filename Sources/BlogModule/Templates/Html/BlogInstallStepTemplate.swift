//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import SwiftHtml

struct BlogInstallStepTemplate: TemplateRepresentable {
    
    var context: BlogInstallStepContext
    
    init(_ context: BlogInstallStepContext) {        
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: "Install blog")) {
            Header {
                H1("Install blog")
                P("Would you like to install sample content for the blog?")
            }
            
            FormTemplate(context.form).render(req)
        }
        .render(req)
    }
}
