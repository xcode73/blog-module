//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct BlogAuthorListObject: Codable {

    public var id: UUID
    public var name: String
    public var imageKey: String?

    public init(id: UUID,
                name: String,
                imageKey: String?)
    {
        self.id = id
        self.name = name
        self.imageKey = imageKey
    }
}
