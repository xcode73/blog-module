//
//  BlogAuthorModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Fluent
import FeatherCore

final class BlogAuthorModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey: String = "authors"
    static let name: FeatherModelName = "Author"
    
    struct FieldKeys: TimestampFieldKeys {
        static var name: FieldKey { "name" }
        static var imageKey: FieldKey { "imageKey" }
        static var bio: FieldKey { "bio" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.imageKey) var imageKey: String?
    @Field(key: FieldKeys.bio) var bio: String?
    
    @TimestampProperty<BlogAuthorModel, DefaultTimestampFormat>(
        key: FieldKeys.updated_at, on: .update, format: .`default`) var updatedAt: Date?
    @TimestampProperty<BlogAuthorModel, DefaultTimestampFormat>(
        key: FieldKeys.created_at, on: .create, format: .`default`) var createdAt: Date?
    @TimestampProperty<BlogAuthorModel, DefaultTimestampFormat>(
        key: FieldKeys.deleted_at, on: .delete, format: .`default`) var deletedAt: Date?
    
    /// relations
    @Children(for: \.$author) var links: [BlogAuthorLinkModel]
    @Siblings(through: BlogPostAuthorModel.self, from: \.$author, to: \.$post) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         imageKey: String?,
         bio: String?)
    {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.name,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<BlogAuthorModel>] {
        [
            \.$name ~~ term,
        ]
    }

}

extension BlogAuthorModel {

    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: name)
    }
}

extension BlogAuthorModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: Self.modelKey + "/" + name.slugify(), title: name, excerpt: bio, imageKey: imageKey)
    }
}


extension BlogAuthorModel {

    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogAuthorModel> {
        query(on: req.db)
            .filter(\.$id == id)
            .with(\.$links)
            .first()
            .unwrap(or: Abort(.notFound))
    }
}
