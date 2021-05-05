//
//  BlogCategoryRouter.swift
//  BlogCategory
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct CategoryGetObject: Codable {

    public var id: UUID
    public var title: String
    public var imageKey: String?
    public var excerpt: String?
    public var color: String?
    public var priority: Int
    public var updatedAt: Date?
    public var createdAt: Date?
    
    public init(id: UUID,
                title: String,
                imageKey: String?,
                excerpt: String?,
                color: String?,
                priority: Int,
                updatedAt: Date?,
                createdAt: Date?
                ) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.color = color
        self.priority = priority
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
