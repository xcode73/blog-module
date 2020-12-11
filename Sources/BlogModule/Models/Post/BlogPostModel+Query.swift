//
//  BlogPostModel+Query.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import Fluent
import FeatherCore

extension BlogPostModel {

    static func findWithCategoriesAndAuthorsBy(id: UUID, on db: Database) -> EventLoopFuture<BlogPostModel?> {
        BlogPostModel.query(on: db)
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors)
            .first()
    }
    
    /// query posts for the home page
    static func home(on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        queryPublicMetadata(on: req.db)
            .range(..<17)
            .with(\.$categories)
            .all()
    }
    
    /// public post list
    static func find(on req: Request) -> QueryBuilder<BlogPostModel> {
        queryPublicMetadata(on: req.db)
            .with(\.$categories)
    }

    /// find a single post by metadata
    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogPostModel> {
        queryPublicMetadata(on: req.db)
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// query posts for the author page
    static func findByAuthor(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        /// this is not so efficient, but since we can't filter throught siblings... it'll do the job.
        queryPublicMetadata(on: req.db)
//            .filter(\.$authors.$id ~~ ids)
            .with(\.$categories)
            .with(\.$authors)
            .all()
            .map { items in
                items.filter { $0.authors.map(\.id).contains(id) }
            }
    }

    /// query posts for the category page
    static func findByCategory(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        /// this is not so efficient, but since we can't filter throught siblings... it'll do the job.
        queryPublicMetadata(on: req.db)
            .with(\.$categories)
//            .filter(\.$category.$id == id)
            .all()
            .map { items in
                items.filter { $0.categories.map(\.id).contains(id) }
            }
    }
}


