//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Vapor
import Feather
import BlogObjects
import SwiftHtml

struct BlogCategoriesPageTemplate: TemplateRepresentable {
    
    var context: BlogCategoriesPageContext
    
    init(_ context: BlogCategoriesPageContext) {
        self.context = context
    }
    
    func render(_ req: Request) -> Tag {
        req.templateEngine.system.index(.init(title: req.variable("blogCategoriesPageTitle") ?? "Categories")) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: req.variable("blogCategoriesPageTitle") ?? "Categories",
                                       excerpt: req.variable("blogCategoriesPageExcerpt") ?? "")).render(req)
                    
                    Section {
                        for category in context.categories {
                            A {
                                Div {
                                    if let imageKey = category.imageKey {
                                        Img(src: req.fs.resolve(key: imageKey), alt: category.title)
                                            .class("profile")
                                            .style("border: 0.25rem solid \(category.color ?? "var(--link-color)")")
                                    }
                                    H2(category.title)
                                    P(category.excerpt ?? "")
                                }
                                .class("content")
                            }
                            .href(category.metadata.slug.safePath())
                            .class("card")
                        }
                    }
                }
            }
            .id("blog-categories")
            .class(add: "blog")
        }
        .render(req)
    }
}

