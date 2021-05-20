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
    
    public init(id: UUID,
                title: String,
                imageKey: String?,
                color: String?,
                priority: Int?) {
        self.id = id
        self.title = title
        self.imageKey = imageKey
        self.color = color
        self.priority = priority
    }

}
