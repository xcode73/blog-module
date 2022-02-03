//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

struct BlogCategoriesPageTemplate: TemplateRepresentable {
    
    var context: BlogCategoriesPageContext
    
    init(_ context: BlogCategoriesPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: req.variable("blogCategoriesPageTitle") ?? "Categories")) {
            Div {
                Div {
                    LeadTemplate(.init(title: req.variable("blogCategoriesPageTitle") ?? "Categories",
                                       excerpt: req.variable("blogCategoriesPageExcerpt") ?? "")).render(req)
                    
                    Section {
                        for category in context.categories {
                            A {
                                Div {
                                    if let imageKey = category.imageKey {
                                        Img(src: req.fs.resolve(key: imageKey), alt: category.title)
                                            .class("profile")
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
                .class("container")
            }
            .id("blog-categories")
            .class("wrapper")
        }
        .render(req)
    }
}

