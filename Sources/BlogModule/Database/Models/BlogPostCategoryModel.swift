//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

final class BlogPostCategoryModel: FeatherDatabaseModel {
    typealias Module = BlogModule
    
    static var featherIdentifier: String = "post_categories"
    
    struct FieldKeys {
        struct v1 {
            static var postId: FieldKey { "post_id" }
            static var categoryId: FieldKey { "category_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.v1.categoryId) var category: BlogCategoryModel

    init() {}

    init(postId: UUID, categoryId: UUID) {
        self.$post.id = postId
        self.$category.id = categoryId
    }
}
