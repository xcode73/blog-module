//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

import Vapor
import Feather
import BlogApi
import SwiftHtml

struct BlogHomePageTemplate: TemplateRepresentable {
    
    var context: BlogHomePageContext
    
    init(_ context: BlogHomePageContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        req.templateEngine.system.index(.init(title: req.variable("blogHomePageTitle") ?? "Blog")) {
            Wrapper {
                Div {
                    LeadTemplate(.init(title: req.variable("blogHomePageTitle") ?? "Blog",
                                       excerpt: req.variable("blogHomePageExcerpt") ?? "Latest posts")).render(req)

                    Section {
                        for post in context.posts {
                            A {
                                if let imageKey = post.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: post.title)
                                }
                                Div {
                                    Span(post.metadata.date.formatted())
                                    H2(post.title)
                                    P(post.excerpt ?? "")
                                }
                                .class("content")   
                            }
                            .href(post.metadata.slug.safePath())
                            .class("card")
                        }
                    }
                    .class("grid-6")
                }
            }
            .id("blog-home")
            .class(add: "blog")
        }
        .render(req)
    }
}

