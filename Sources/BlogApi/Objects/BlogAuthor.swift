//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//


import Foundation

public struct BlogAuthor: Codable {

    public var id: UUID?
    public var name: String
    public var imageKey: String
    public var bio: String

    public var links: [BlogAuthorLink]
    
    public init(id: UUID? = nil,
                name: String,
                imageKey: String,
                bio: String,
                links: [BlogAuthorLink] = []) {
        self.id = id
        self.name = name
        self.imageKey = imageKey
        self.bio = bio
        self.links = links
    }
}
