//
//  BlogPostModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Fluent
import FeatherCore

final class BlogPostModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey: String = "posts"
    static let name: FeatherModelName = "Post"

    struct FieldKeys: TimestampFieldKeys {
        static var title: FieldKey { "title" }
        static var imageKey: FieldKey { "image_key" }
        static var excerpt: FieldKey { "excerpt" }
        static var content: FieldKey { "content" }
    }
    
    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.imageKey) var imageKey: String?
    @Field(key: FieldKeys.excerpt) var excerpt: String?
    @Field(key: FieldKeys.content) var content: String?
    
    @TimestampProperty<BlogPostModel, DefaultTimestampFormat>(
        key: FieldKeys.updated_at, on: .update, format: .`default`) var updatedAt: Date?
    @TimestampProperty<BlogPostModel, DefaultTimestampFormat>(
        key: FieldKeys.created_at, on: .create, format: .`default`) var createdAt: Date?
    @TimestampProperty<BlogPostModel, DefaultTimestampFormat>(
        key: FieldKeys.deleted_at, on: .delete, format: .`default`) var deletedAt: Date?
    
    @Siblings(through: BlogPostCategoryModel.self, from: \.$post, to: \.$category) var categories: [BlogCategoryModel]
    @Siblings(through: BlogPostAuthorModel.self, from: \.$post, to: \.$author) var authors: [BlogAuthorModel]

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String? = nil,
         excerpt: String? = nil,
         content: String? = nil)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.content = content
    }
    
    // MARK: - query

    static func defaultSort() -> FieldSort {
        .desc
    }

    static func allowedOrders() -> [FieldKey] {
        [
            "date", // Metadata
            FieldKeys.title,
        ]
    }

    static func sort(queryBuilder: QueryBuilder<BlogPostModel>, order: FieldKey, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<BlogPostModel> {
        if order == "date" {
            return queryBuilder.sortMetadataByDate(direction)
        }
        return queryBuilder.sort(order, direction)
    }

    
    static func search(_ term: String) -> [ModelValueFilter<BlogCategoryModel>] {
        [
            \.$title ~~ term,
        ]
    }
}

extension BlogPostModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: title.slugify(), title: title, excerpt: excerpt, imageKey: imageKey)
    }
}

extension BlogPostModel {

    static func findWithCategoriesAndAuthorsBy(id: UUID, on db: Database) -> EventLoopFuture<BlogPostModel?> {
        BlogPostModel.query(on: db)
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors)
            .first()
    }

    /// public post list
    static func find(on req: Request) -> QueryBuilder<BlogPostModel> {
        queryJoinPublicMetadata(on: req.db)
            .with(\.$categories)
    }

    /// find a single post by metadata
    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogPostModel> {
        queryJoinPublicMetadata(on: req.db)
            .filter(\.$id == id)
            .with(\.$categories)
            .with(\.$authors) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// query posts for the author page
    static func findByAuthor(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        /// this is not so efficient, but since we can't filter throught siblings... it'll do the job.
        queryJoinPublicMetadata(on: req.db)
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
        queryJoinPublicMetadata(on: req.db)
            .with(\.$categories)
//            .filter(\.$category.$id == id)
            .all()
            .map { items in
                items.filter { $0.categories.map(\.id).contains(id) }
            }
    }
}



