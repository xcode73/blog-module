//
//  BlogCategoryModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import FeatherCore

final class BlogCategoryModel: ViperModel {
    typealias Module = BlogModule

    static let name = "categories"
    
    struct FieldKeys {
        static var title: FieldKey { "title" }
        static var imageKey: FieldKey { "image_key" }
        static var excerpt: FieldKey { "excerpt" }
        static var color: FieldKey { "color" }
        static var priority: FieldKey { "priority" }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.imageKey) var imageKey: String
    @Field(key: FieldKeys.excerpt) var excerpt: String
    @Field(key: FieldKeys.color) var color: String?
    @Field(key: FieldKeys.priority) var priority: Int
    
    /// posts relation
    @Siblings(through: BlogPostCategoryModel.self, from: \.$category, to: \.$post) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String,
         excerpt: String,
         color: String? = nil,
         priority: Int = 100)
    {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.color = color
        self.priority = priority
    }
}
