//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import SwiftHtml

struct BlogPostPageTemplate: TemplateRepresentable {
    
    var context: BlogPostPageContext
    
    init(_ context: BlogPostPageContext) {
        self.context = context
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        WebIndexTemplate(.init(title: context.post.title, metadata: context.post.metadata)) {
            Article {
                Container {
                    Header {
                        P {
                            Span(context.post.metadata.date.formatted())
                            
                            for category in context.post.categories {
                                A {
                                    //                                    if let color = category.color {
                                    Span(category.title)
                                    //                                            .style("border-bottom: 2px solid \(color);")
                                    //                                    }
                                    //                                    else {
                                    //                                        Span(category.title)
                                    //                                    }
                                }
                                .href(category.metadata.slug.safePath())
                            }
                            
                            //                            let dateString = Feather.dateFormatter().string(from: context.post.metadata.date)
                            //                            Time(dateString)
                            //                                .datetime(dateString)
                            //                                .class("date")
                        }
                        .class("meta")
                        H1(context.post.title)
                        P(context.post.excerpt ?? "")
                    }
                    .class("lead")
                }
                
                Wrapper {
                    if let imageKey = context.post.imageKey {
                        Img(src: req.fs.resolve(key: imageKey), alt: context.post.title)
                    }
                }
                Container {
                    Text(context.post.content ?? "")
                }
                .id("content")
            }
            .id("blog-post")
            .class("wrapper")
            
            
            if req.checkVariable("blogPostShareIsEnabled") {
                Container {
                    Section {
                        Hr()
                        P {
                            Text(req.variable("blogPostShareLinkPrefix") ?? "")
                            A(req.variable("blogPostShareLink") ?? "Share on Twitter")
                                .href("https://twitter.com/intent/tweet?via=\(req.variable("blogPostShareAuthor") ?? "")&hashtags=\(req.variable("blogPostShareHashtags") ?? "")&url=\(req.absoluteUrl)")
                            Text(req.variable("blogPostShareLinkSuffix") ?? "")
                        }
                    }
                    .id("share")
                    .class("margin")
                }
            }
            
            if req.checkVariable("blogPostAuthorBoxIsEnabled"), !context.post.authors.isEmpty {
                Container {
                    H2("Author" + (context.post.authors.count > 1 ? "s" : ""))
                    for author in context.post.authors {
                        Div {
                            Div {
                                if let imageKey = author.imageKey {
                                    Img(src: req.fs.resolve(key: imageKey), alt: author.name)
                                        .class("profile")
                                }
                                H3(author.name)
                                P(author.bio ?? "")
                                
                                for link in author.links {
                                    A(link.label)
                                        .href(link.url)
                                        .target(.blank)
                                }
                            }
                            .class("content")
                        }
                        .class("card")
                    }
                }
                .class(add: "blog post-authors")
            }
            
        }
        .render(req)
    }
}

