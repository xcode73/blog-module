//
//  BlogPostModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

final class BlogPostModel: ViperModel {
    typealias Module = BlogModule
    
    static let name = "posts"

    struct FieldKeys {
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
    
    @Siblings(through: BlogPostCategoryModel.self, from: \.$post, to: \.$category) var categories: [BlogCategoryModel]
    @Siblings(through: BlogPostAuthorModel.self, from: \.$post, to: \.$author) var authors: [BlogAuthorModel]

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String?,
         excerpt: String?,
         content: String?)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.content = content
    }
}
