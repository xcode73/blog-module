//
//  BlogAuthorLinkRouter.swift
//  BlogAuthorLink
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogAuthorLinkUpdateObject: Codable {

    public var label: String
    public var url: String
    public var priority: Int
    
    public init(label: String,
                url: String,
                priority: Int)
    {
        self.label = label
        self.url = url
        self.priority = priority
    }

}
