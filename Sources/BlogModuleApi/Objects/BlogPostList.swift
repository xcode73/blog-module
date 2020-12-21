//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import Foundation

public struct BlogPostListItem: Codable {

    public var id: UUID?
    public var title: String
    public var imageKey: String
    public var excerpt: String

    public init(id: UUID? = nil,
                title: String,
                imageKey: String,
                excerpt: String) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
    }
}

