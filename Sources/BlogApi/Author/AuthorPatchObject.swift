//
//  BlogAuthorRouter.swift
//  BlogAuthor
//
//  Created by Tibor Bödecs on 2020. 12. 22..
//

import Foundation

public struct AuthorPatchObject: Codable {

    public var name: String?
    public var imageKey: String?
    public var bio: String?
    
    public init(name: String? = nil,
                imageKey: String? = nil,
                bio: String? = nil)
    {
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
    }


}
