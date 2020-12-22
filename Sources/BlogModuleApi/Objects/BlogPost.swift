//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import Foundation

public struct BlogPost: Codable {

    public var id: UUID?
    public var title: String
    public var imageKey: String?
    public var excerpt: String?
    public var content: String?

    public var categories: [BlogCategory]
    public var authors: [BlogAuthor]
    
    public init(id: UUID? = nil,
                title: String,
                imageKey: String?,
                excerpt: String?,
                content: String?,
                categories: [BlogCategory] = [],
                authors: [BlogAuthor] = []) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.content = content
        self.categories = categories
        self.authors = authors
    }
}
