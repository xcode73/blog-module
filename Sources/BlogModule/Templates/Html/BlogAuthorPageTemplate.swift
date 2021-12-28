//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

struct BlogAuthorPageTemplate: TemplateRepresentable {
    
    var context: BlogAuthorPageContext
    
    init(_ context: BlogAuthorPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: context.author.name, metadata: context.author.metadata)) {
            Div {
                Header {
                    if let imageKey = context.author.imageKey {
                        Img(src: req.fs.resolve(key: imageKey), alt: context.author.name)
                            .class("profile")
                    }
                    H1(context.author.name)
                    P(context.author.bio ?? "")
                    
                    for link in context.author.links {
                        A(link.label)
                            .href(link.url)
                            .target(.blank)
                    }
                }
                .class("lead")

                Section {
                    for post in context.author.posts {
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
                        .href(post.metadata.slug)
                        .class("card")
                    }
                }
            }
            .id("blog-author")
            .class("container")
        }
        .render(req)
    }
}

