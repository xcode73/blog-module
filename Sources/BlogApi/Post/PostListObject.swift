//
//  BlogPostRouter.swift
//  BlogPost
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct PostListObject: Codable {

    public var id: UUID
    public var title: String
    public var imageKey: String?
    public var excerpt: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var deletedAt: Date?

    public init(id: UUID,
                title: String,
                imageKey: String?,
                excerpt: String?,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                deletedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

}
