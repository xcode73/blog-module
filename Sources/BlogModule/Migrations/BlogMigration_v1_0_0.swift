//
//  BlogMigration_v1_0_0.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Fluent

struct BlogMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(BlogCategoryModel.schema)
                .id()
                .field(BlogCategoryModel.FieldKeys.title, .string, .required)
                .field(BlogCategoryModel.FieldKeys.imageKey, .string)
                .field(BlogCategoryModel.FieldKeys.excerpt, .string)
                .field(BlogCategoryModel.FieldKeys.color, .string)
                .field(BlogCategoryModel.FieldKeys.priority, .int, .required)
                .field(BlogPostModel.FieldKeys.updated_at, .datetime)
                .field(BlogPostModel.FieldKeys.created_at, .datetime)
                .field(BlogPostModel.FieldKeys.deleted_at, .datetime)
                .unique(on: BlogCategoryModel.FieldKeys.title)
                .create(),
            
            db.schema(BlogAuthorModel.schema)
                .id()
                .field(BlogAuthorModel.FieldKeys.name, .string, .required)
                .field(BlogAuthorModel.FieldKeys.imageKey, .string)
                .field(BlogAuthorModel.FieldKeys.bio, .string)
                .field(BlogPostModel.FieldKeys.updated_at, .datetime)
                .field(BlogPostModel.FieldKeys.created_at, .datetime)
                .field(BlogPostModel.FieldKeys.deleted_at, .datetime)
                .create(),

            db.schema(BlogAuthorLinkModel.schema)
                .id()
                .field(BlogAuthorLinkModel.FieldKeys.label, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.url, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.priority, .int, .required)
                .field(BlogAuthorLinkModel.FieldKeys.authorId, .uuid, .required)
                .foreignKey(BlogAuthorLinkModel.FieldKeys.authorId, references: BlogAuthorModel.schema, .id)
                .create(),
            
            db.schema(BlogPostModel.schema)
                .id()
                .field(BlogPostModel.FieldKeys.title, .string, .required)
                .field(BlogPostModel.FieldKeys.imageKey, .string)
                .field(BlogPostModel.FieldKeys.excerpt, .string)
                .field(BlogPostModel.FieldKeys.content, .string)
                .field(BlogPostModel.FieldKeys.updated_at, .datetime)
                .field(BlogPostModel.FieldKeys.created_at, .datetime)
                .field(BlogPostModel.FieldKeys.deleted_at, .datetime)
                .create(),
            
            db.schema(BlogPostCategoryModel.schema)
                .id()
                .field(BlogPostCategoryModel.FieldKeys.postId, .uuid, .required)
                .field(BlogPostCategoryModel.FieldKeys.categoryId, .uuid, .required)
                .create(),

            db.schema(BlogPostAuthorModel.schema)
                .id()
                .field(BlogPostAuthorModel.FieldKeys.postId, .uuid, .required)
                .field(BlogPostAuthorModel.FieldKeys.authorId, .uuid, .required)
                .create(),
        ])
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(BlogPostModel.schema).delete(),
            db.schema(BlogCategoryModel.schema).delete(),
            db.schema(BlogAuthorModel.schema).delete(),
            db.schema(BlogAuthorLinkModel.schema).delete(),
        ])
    }
}

