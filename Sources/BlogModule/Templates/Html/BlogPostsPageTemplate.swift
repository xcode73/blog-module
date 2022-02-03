//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

struct BlogPostsPageTemplate: TemplateRepresentable {
    
    var context: BlogPostsPageContext
    
    init(_ context: BlogPostsPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: req.variable("blogPostsPageTitle") ?? "Posts")) {
            Div {
                Div {
                    LeadTemplate(.init(title: req.variable("blogPostsPageTitle") ?? "Posts",
                                       excerpt: req.variable("blogPostsPageExcerpt") ?? "")).render(req)
                    
                    Section {
                        
                        for post in context.posts {
                            A {
                                
                                if let imageKey = post.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: post.title)
                                }
                                Div {
                                    Div {
                                        H2(post.title)
                                        P(post.excerpt ?? "")
                                    }
                                    .class("text")
                                }
                                .class("content")
                                Div {
                                    let dateString = Feather.dateFormatter().string(from: post.metadata.date)
                                    Time(dateString)
                                        .datetime(dateString)
                                        .class("date")
                                    
                                    Div {
                                        for category in post.categories {
                                            //                                        A {
                                            if let color = category.color {
                                                Span(category.title)
                                                    .style("color: #\(color);")
                                            }
                                            else {
                                                Span(category.title)
                                            }
                                            //                                        }
                                            //                                        .href(category.metadata.slug.safePath())
                                        }
                                    }
                                    .class("tags")
                                }
                                .class("meta")
                            }
                            .href(post.metadata.slug.safePath())
                            .class("card")
                        }
                    }
                }
                .class("container")
            }
            .id("blog-posts")
            .class("wrapper")
        }
        .render(req)
    }
}





