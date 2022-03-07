//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import Vapor
import Feather
import BlogApi
import SwiftHtml

struct BlogPostsPageTemplate: TemplateRepresentable {
    
    var context: BlogPostsPageContext
    
    init(_ context: BlogPostsPageContext) {
        self.context = context
    }

    func render(_ req: Request) -> Tag {
        req.templateEngine.system.index(.init(title: req.variable("blogPostsPageTitle") ?? "Posts")) {
            Wrapper {
                Container {
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
//                                        let dateString = Feather.dateFormatter().string(from: post.metadata.date)
//                                        Time(dateString)
//                                            .datetime(dateString)
//                                            .class("date")

                                        Span(post.metadata.date.formatted())
                                        H2(post.title)
                                        P(post.excerpt ?? "")
                                    }
                                    .class("text")
                                }
                                .class("content")
//                                Div {
                                    
                                    
//                                    Div {
//                                        for category in post.categories {
//                                            //                                        A {
//                                            if let color = category.color {
//                                                Span(category.title)
//                                                    .style("color: #\(color);")
//                                            }
//                                            else {
//                                                Span(category.title)
//                                            }
//                                            //                                        }
//                                            //                                        .href(category.metadata.slug.safePath())
//                                        }
//                                    }
//                                    .class("tags")
//                                }
//                                .class("meta")
                            }
                            .href(post.metadata.slug.safePath())
                            .class("card")
                        }
                    }
                }
            }
            .id("blog-posts")
            .class(add: "blog")
        }
        .render(req)
    }
}





