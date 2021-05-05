//
//  BlogAuthorLinkModule.swift
//  BlogAuthorLink
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct AuthorLinkCreateObject: Codable {

    public var label: String
    public var url: String
    public var priority: Int
    public let authorId: UUID
    
    public init(label: String,
                url: String,
                priority: Int = 0,
                authorId: UUID)
    {
        self.label = label
        self.url = url
        self.priority = priority
        self.authorId = authorId
    }

}
