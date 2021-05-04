//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogAuthorListObject: Codable {

    public var id: UUID
    public var name: String?
    public var imageKey: String?
    public var updated_at: Date?
    public var created_at: Date?
    public var deleted_at: Date?
    
    public init(id: UUID,
                name: String?,
                imageKey: String?,
                updated_at: Date?,
                created_at: Date?,
                deleted_at: Date?
                ) {
        self.id = id
        self.deleted_at = deleted_at
        self.updated_at = updated_at
        self.created_at = created_at
        // In case the object is deleted, we only retrun ID and timestamps data
        guard deleted_at == nil else {
            return
        }
        self.name = name
        self.imageKey = imageKey
    }
}
