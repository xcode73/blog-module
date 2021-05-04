//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogAuthorGetObject: Codable {

    public var id: UUID
    public var name: String
    public var imageKey: String?
    public var bio: String?
    public var updated_at: Date?
    public var created_at: Date?
    
    public var links: [BlogAuthorLinkListObject]?
    
    public init(id: UUID,
                name: String,
                imageKey: String?,
                bio: String?,
                updated_at: Date?,
                created_at: Date?,
                links: [BlogAuthorLinkListObject])
    {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
        self.updated_at = updated_at
        self.created_at = created_at
        self.links = links.count > 0 ? links : nil
    }

}
