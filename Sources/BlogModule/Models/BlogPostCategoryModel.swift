//
//  BlogPostCategoryModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 10..
//

import FeatherCore

final class BlogPostCategoryModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey: String = "post_categories"
    static let name: FeatherModelName = .init(singular: "Post category", plural: "Post categories")
    
    struct FieldKeys {
        static var postId: FieldKey { "post_id" }
        static var categoryId: FieldKey { "category_id" }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.categoryId) var category: BlogCategoryModel

    init() {}

    init(postId: UUID, categoryId: UUID) {
        self.$post.id = postId
        self.$category.id = categoryId
    }
}
