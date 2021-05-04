//
//  BlogCategoryModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Fluent
import FeatherCore

final class BlogCategoryModel: FeatherModel {
    typealias Module = BlogModule

    static let modelKey: String = "categories"
    static let name: FeatherModelName = .init(singular: "Category", plural: "Categories")
    
    struct FieldKeys: TimestampFieldKeys {
        static var title: FieldKey { "title" }
        static var imageKey: FieldKey { "image_key" }
        static var excerpt: FieldKey { "excerpt" }
        static var color: FieldKey { "color" }
        static var priority: FieldKey { "priority" }
    }

    @ID() var id: UUID?
    @Field(key: FieldKeys.title) var title: String
    @Field(key: FieldKeys.imageKey) var imageKey: String?
    @Field(key: FieldKeys.excerpt) var excerpt: String?
    @Field(key: FieldKeys.color) var color: String?
    @Field(key: FieldKeys.priority) var priority: Int
    
    @TimestampProperty<BlogCategoryModel, DefaultTimestampFormat>(
        key: FieldKeys.updated_at, on: .update, format: .`default`) var updatedAt: Date?
    @TimestampProperty<BlogCategoryModel, DefaultTimestampFormat>(
        key: FieldKeys.created_at, on: .create, format: .`default`) var createdAt: Date?
    @TimestampProperty<BlogCategoryModel, DefaultTimestampFormat>(
        key: FieldKeys.deleted_at, on: .delete, format: .`default`) var deletedAt: Date?
    
    /// posts relation
    @Siblings(through: BlogPostCategoryModel.self, from: \.$category, to: \.$post) var posts: [BlogPostModel]
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         imageKey: String? = nil,
         excerpt: String? = nil,
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
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.title,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<BlogCategoryModel>] {
        [
            \.$title ~~ term,
        ]
    }
}

extension BlogCategoryModel {
    
    var formFieldOption: FormFieldOption {
        .init(key: identifier, label: title)
    }
    
}
extension BlogCategoryModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: Self.modelKey + "/" + title.slugify(), title: title, imageKey: imageKey)
    }
}


