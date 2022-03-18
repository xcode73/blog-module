//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import Feather
import FeatherObjects
import BlogObjects

final class BlogAuthorModel: FeatherDatabaseModel {
    typealias Module = BlogModule
    
    struct FieldKeys {
        struct v1 {
            static var name: FieldKey { "name" }
            static var imageKey: FieldKey { "imageKey" }
            static var bio: FieldKey { "bio" }
        }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.v1.name) var name: String
    @Field(key: FieldKeys.v1.imageKey) var imageKey: String?
    @Field(key: FieldKeys.v1.bio) var bio: String?
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
}

extension BlogAuthorModel: MetadataRepresentable {

    var systemMetadata: FeatherMetadata {
        .init(module: Module.uniqueKey,
              model: Self.uniqueKey,
              reference: uuid,
              slug: Blog.Author.pathKey + "/" + name.slugify(),
              title: name)
    }
}
