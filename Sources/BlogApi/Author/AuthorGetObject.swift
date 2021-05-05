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
    public var updatedAt: Date?
    public var createdAt: Date?
    
    public var links: [AuthorLinkListObject]?
    
    public init(id: UUID,
                name: String,
                imageKey: String?,
                bio: String?,
                updatedAt: Date?,
                createdAt: Date?,
                links: [AuthorLinkListObject])
    {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.links = links.count > 0 ? links : nil
    }

}
