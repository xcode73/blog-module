//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Feather
import BlogObjects
import SwiftHtml

struct BlogCategoryPageTemplate: TemplateRepresentable {
    
    var context: BlogCategoryPageContext
    
    init(_ context: BlogCategoryPageContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        req.templateEngine.system.index(.init(title: context.category.title, metadata: context.category.metadata)) {
            Wrapper {
                Container {
                    Header {
                        if let imageKey = context.category.imageKey {
                            Img(src: req.fs.resolve(key: imageKey), alt: context.category.title)
                                .class("profile")
                                .style("border: 0.25rem solid \(context.category.color ?? "var(--link-color)")")
                        }
                        H1(context.category.title)
                        P(context.category.excerpt ?? "")
                    }
                    .class("lead")
                    
                    Section {
                        for post in context.category.posts {
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
                }
            }
            .id("blog-category")
            .class(add: "blog")
        }
        .render(req)
    }
}

