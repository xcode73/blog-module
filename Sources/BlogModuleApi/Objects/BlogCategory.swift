//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import Foundation

public struct BlogCategory: Codable {

    public var id: UUID?
    public var title: String
    public var imageKey: String?
    public var excerpt: String?
    public var color: String?
    public var priority: Int
    
    public init(id: UUID? = nil,
                title: String,
                imageKey: String?,
                excerpt: String?,
                color: String? = nil,
                priority: Int = 100) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.color = color
        self.priority = priority
    }
}
