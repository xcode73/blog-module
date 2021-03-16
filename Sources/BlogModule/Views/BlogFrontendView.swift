//
//  BlogFrontendView.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

struct BlogFrontendView {

    let name = "frontend"
    
    let req: Request

    init(_ req: Request) {
        self.req = req
    }
    
    private func render(_ name: String, _ context: Renderer.Context) -> EventLoopFuture<View> {
        let template = "\(BlogModule.name.capitalized)/\(self.name.capitalized)/\(name.capitalized)"
        return req.tau.render(template: template, context: context)
    }

    func home(posts: [BlogPostModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("home", [
                "metadata": metadata.templateData,
                "posts": .array(posts.map { $0.templateDataWithJoinedMetadata }),
        ])
    }

    func posts(page: ListPage<TemplateData>, metadata: Metadata) -> EventLoopFuture<View> {
        render("posts", [
                "metadata": metadata.templateData,
                "page": page.templateData,
        ])
    }
    
    func categories(_ categories: [BlogCategoryModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("categories", [
                "metadata": metadata.templateData,
                "categories": .array(categories.map { $0.templateDataWithJoinedMetadata }),
        ])
    }
    
    func category(_ category: BlogCategoryModel, posts: [BlogPostModel]) -> EventLoopFuture<View> {
        render("category", [
                "category": category.templateDataWithJoinedMetadata,
                "posts": .array(posts.map { $0.templateDataWithJoinedMetadata }),
        ])
    }
    
    func authors(_ authors: [BlogAuthorModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("authors", [
                "metadata": metadata.templateData,
                "authors": .array(authors.map { $0.templateDataWithJoinedMetadata }.map(\.templateData)),
        ])
    }

    func author(_ author: BlogAuthorModel, posts: [BlogPostModel]) -> EventLoopFuture<View> {
        render("author", [
                "author": author.templateData,
                "posts": .array(posts.map { $0.templateDataWithJoinedMetadata }),
        ])
    }
    
    func post(_ post: TemplateData) -> EventLoopFuture<View> {
        render("post", ["post": post])
    }
}
