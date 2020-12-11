//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 10..
//

import FeatherCore

final class BlogPostAuthorModel: ViperModel {
    typealias Module = BlogModule
    
    static let name = "post_authors"
    
    struct FieldKeys {
        static var postId: FieldKey { "post_id" }
        static var authorId: FieldKey { "author_id" }
    }

    @ID() var id: UUID?
    @Parent(key: FieldKeys.postId) var post: BlogPostModel
    @Parent(key: FieldKeys.authorId) var author: BlogAuthorModel
    
    init() {}

    init(postId: UUID, authorId: UUID) {
        self.$post.id = postId
        self.$author.id = authorId
    }
}
