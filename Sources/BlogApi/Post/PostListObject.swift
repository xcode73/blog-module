//
//  BlogPostRouter.swift
//  BlogPost
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct PostListObject: Codable {

    public var id: UUID
    public var title: String?
    public var imageKey: String?
    public var excerpt: String?
    public var updatedAt: Date?
    public var createdAt: Date?
    public var deletedAt: Date?

    public init(id: UUID,
                title: String?,
                imageKey: String?,
                excerpt: String?,
                updatedAt: Date?,
                createdAt: Date?,
                deletedAt: Date?
                ) {
        self.id = id
        self.deletedAt = deletedAt
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        // In case the object is deleted, we only retrun ID and timestamps data
        guard deletedAt == nil else {
            return
        }
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
    }

}
