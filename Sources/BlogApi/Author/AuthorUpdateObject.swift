//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct AuthorUpdateObject: Codable {

    public var name: String
    public var imageKey: String?
    public var bio: String?

    public init(name: String,
                imageKey: String?,
                bio: String? = nil)
    {
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
    }
}
