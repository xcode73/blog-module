//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import SwiftHtml

struct BlogCategoryPageTemplate: TemplateRepresentable {
    
    var context: BlogCategoryPageContext
    
    init(_ context: BlogCategoryPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: context.category.title)) {
            Div {
                Header {
                    if let imageKey = context.category.imageKey {
                        Img(src: req.fs.resolve(key: imageKey), alt: context.category.title)
                            .class("profile")
                            .style("border: none; border-radius: 0;")
                    }
                    H1(context.category.title)
                    P(context.category.excerpt ?? "")
                }
                .class("lead")

                Section {
                    for post in context.category.posts {
                        A {
                            Div {
                                if let imageKey = post.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: post.title)
                                }
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
            .id("blog-category")
            .class("container")
        }
        .render(req)
    }
}

