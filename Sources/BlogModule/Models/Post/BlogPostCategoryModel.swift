//
//  BlogPostCategoryModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 10..
//

import FeatherCore

final class BlogPostCategoryModel: ViperModel {
    typealias Module = BlogModule
    
    static let name = "post_categories"
    
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
