//
//  BlogAuthorLinkModel.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Fluent
import FeatherCore

final class BlogAuthorLinkModel: FeatherModel {
    typealias Module = BlogModule
    
    static let modelKey = "links"
    static let name: FeatherModelName = "Author link"
    static let schema = "\(Module.moduleKey)_author_\(modelKey)"
    
    
    struct FieldKeys {
        static var label: FieldKey { "label" }
        static var url: FieldKey { "url" }
        static var priority: FieldKey { "priority" }
        static var authorId: FieldKey { "author_id" }
    }
    
    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.label) var label: String
    @Field(key: FieldKeys.url) var url: String
    @Field(key: FieldKeys.priority) var priority: Int
    @Parent(key: FieldKeys.authorId) var author: BlogAuthorModel
    
    init() { }
    
    init(id: UUID? = nil,
         label: String,
         url: String,
         priority: Int = 10,
         authorId: UUID)
    {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.$author.id = authorId
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.label,
            FieldKeys.url,
            FieldKeys.priority,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<BlogAuthorLinkModel>] {
        [
            \.$label ~~ term,
            \.$url ~~ term,
        ]
    }
}


extension BlogAuthorLinkModel {
    
    static func adminLink(authorId: UUID) -> Link {
        let url = (BlogAuthorModel.adminLink.url + "/" + authorId.uuidString + "/" + modelKey).safePath()
        return .init(label: name.plural, url: url)
    }
}
