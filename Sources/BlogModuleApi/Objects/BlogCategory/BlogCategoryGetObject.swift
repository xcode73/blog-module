//
//  BlogCategoryRouter.swift
//  BlogCategory
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogCategoryGetObject: Codable {

    public var id: UUID
    public var title: String
    public var imageKey: String?
    public var excerpt: String?
    public var color: String?
    public var priority: Int
    public var updated_at: Date?
    public var created_at: Date?
    
    public init(id: UUID,
                title: String,
                imageKey: String?,
                excerpt: String?,
                color: String?,
                priority: Int,
                updated_at: Date?,
                created_at: Date?
                ) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.excerpt = excerpt
        self.color = color
        self.priority = priority
        self.updated_at = updated_at
        self.created_at = created_at
    }
}
