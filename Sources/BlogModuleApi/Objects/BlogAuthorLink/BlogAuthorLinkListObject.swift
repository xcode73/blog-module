//
//  BlogAuthorLinkRouter.swift
//  BlogAuthorLink
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogAuthorLinkListObject: Codable {

    public var id: UUID
    public var label: String
    public var url: String
    public var priority: Int

    public init(id: UUID,
                label: String,
                url: String,
                priority: Int)
    {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
    }

}
