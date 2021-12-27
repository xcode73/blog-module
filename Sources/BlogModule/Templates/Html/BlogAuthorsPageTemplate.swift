//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

struct BlogAuthorsPageTemplate: TemplateRepresentable {
    
    var context: BlogAuthorsPageContext
    
    init(_ context: BlogAuthorsPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: req.variable("blogAuthorsPageTitle") ?? "Authors")) {
            Div {
                Header {
                    H1(req.variable("blogAuthorsPageTitle") ?? "Authors")
                    P(req.variable("blogAuthorsPageExcerpt") ?? "")
                }
                .class("lead")
                
                Section {
                    for author in context.authors {
                        A {
                            Div {
                                if let imageKey = author.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: author.name)
                                        .class("profile")
                                }
                                H2(author.name)
                                P(author.bio ?? "")
                            }
                            .class("content")
                        }
                        .href(author.metadata.slug.safePath())
                        .class("card")
                    }
                }
            }
            .id("blog-authors")
            .class("container")
        }
        .render(req)
    }
}

