//
//  BlogCategoryRouter.swift
//  BlogCategory
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct CategoryListObject: Codable {

    public var id: UUID
    public var title: String
    public var imageKey: String?
    public var color: String?
    public var priority: Int?
    public var updatedAt: Date?
    public var createdAt: Date?
    public var deletedAt: Date?
    
    public init(id: UUID,
                title: String,
                imageKey: String?,
                color: String?,
                priority: Int?,
                createdAt: Date? = nil,
                updatedAt: Date? = nil,
                deletedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.color = color
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

}
