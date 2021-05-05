//
//  BlogAuthorLinkRouter.swift
//  BlogAuthorLink
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct AuthorLinkListObject: Codable {

    public var id: UUID
    public var label: String
    public var url: String
    public var priority: Int
    public let authorId: UUID

    public init(id: UUID,
                label: String,
                url: String,
                priority: Int,
                authorId: UUID)
    {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.authorId = authorId
    }

}
