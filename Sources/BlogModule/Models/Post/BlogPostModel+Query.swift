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
        query(on: req.db)
            .join(FrontendMetadata.self, on: \BlogPostModel.$id == \FrontendMetadata.$reference, method: .inner)
            .filter(FrontendMetadata.self, \.$status == .published)
            .filter(FrontendMetadata.self, \.$date <= Date())
            .sort(FrontendMetadata.self, \.$date, .descending)
            .range(..<17)
            .with(\.$categories)
            .all()
    }
    
    /// public post list
    static func find(on req: Request) -> QueryBuilder<BlogPostModel> {
        findMetadata(on: req.db)
            .filter(FrontendMetadata.self, \.$status == .published)
            .filter(FrontendMetadata.self, \.$date <= Date())
            .sort(FrontendMetadata.self, \.$date, .descending)
            .with(\.$categories)
    }

    /// find a single post by metadata
    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogPostModel> {
        findMetadata(on: req.db)
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// query posts for the author page
    static func findByAuthor(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        /// this is not so efficient, but since we can't filter throught siblings... it'll do the job.
        findMetadata(on: req.db)
            .filter(FrontendMetadata.self, \.$status == .published)
            .filter(FrontendMetadata.self, \.$date <= Date())
//            .filter(\.$authors.$id ~~ ids)
            .with(\.$categories)
            .with(\.$authors)
            .sort(FrontendMetadata.self, \.$date, .descending)
            .all()
            .map { items in
                items.filter { $0.authors.map(\.id).contains(id) }
            }
    }

    /// query posts for the category page
    static func findByCategory(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        /// this is not so efficient, but since we can't filter throught siblings... it'll do the job.
        findMetadata(on: req.db)
            .filter(FrontendMetadata.self, \.$status == .published)
            .filter(FrontendMetadata.self, \.$date <= Date())
            .with(\.$categories)
//            .filter(\.$category.$id == id)
            .sort(FrontendMetadata.self, \.$date, .descending)
            .all()
            .map { items in
                items.filter { $0.categories.map(\.id).contains(id) }
            }
    }
}


