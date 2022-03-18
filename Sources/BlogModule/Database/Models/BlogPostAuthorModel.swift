//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Foundation
import Fluent
import Feather
import FeatherObjects

final class BlogPostAuthorModel: FeatherDatabaseModel {
    typealias Module = BlogModule
    
    static var featherIdentifier: String = "post_authors"
    
    struct FieldKeys {
        struct v1 {
            static var postId: FieldKey { "post_id" }
            static var authorId: FieldKey { "author_id" }
        }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.v1.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.v1.authorId) var author: BlogAuthorModel
    
    init() {}

    init(postId: UUID, authorId: UUID) {
        self.$post.id = postId
        self.$author.id = authorId
    }
}
