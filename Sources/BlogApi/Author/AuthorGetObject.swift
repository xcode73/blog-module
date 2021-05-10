//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct AuthorGetObject: Codable {

    public var id: UUID
    public var name: String
    public var imageKey: String?
    public var bio: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var deletedAt: Date?
    
    public var links: [AuthorLinkListObject]?
    
    public init(id: UUID,
                name: String,
                imageKey: String? = nil,
                bio: String? = nil,
                links: [AuthorLinkListObject] = [],
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                deletedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.links = links
    }

}
