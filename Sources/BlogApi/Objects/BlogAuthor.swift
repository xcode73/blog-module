//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public extension Blog {
    
    enum Author: FeatherApiModel {
        public typealias Module = Blog
    }
}

public extension Blog.Author {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var name: String
        public var imageKey: String?
        public var bio: String?
        public var links: [Blog.AuthorLink.List]
        public var metadata: FeatherMetadata
        
        public init(id: UUID,
                    name: String,
                    imageKey: String? = nil,
                    bio: String? = nil,
                    links: [Blog.AuthorLink.List],
                    metadata: FeatherMetadata) {
            self.id = id
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
            self.links = links
            self.metadata = metadata
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var name: String
        public var imageKey: String?
        public var bio: String?
        public var links: [Blog.AuthorLink.List]
        public var metadata: FeatherMetadata
        public var posts: [Blog.Post.List]

        public init(id: UUID,
                    name: String,
                    imageKey: String? = nil,
                    bio: String? = nil,
                    links: [Blog.AuthorLink.List] = [],
                    metadata: FeatherMetadata,
                    posts: [Blog.Post.List] = []) {
            self.id = id
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
            self.links = links
            self.metadata = metadata
            self.posts = posts
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var name: String
        public var imageKey: String?
        public var bio: String?
        
        public init(name: String,
                    imageKey: String? = nil,
                    bio: String? = nil) {
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var name: String
        public var imageKey: String?
        public var bio: String?

        public init(name: String,
                    imageKey: String?,
                    bio: String? = nil) {
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var name: String?
        public var imageKey: String?
        public var bio: String?
        
        public init(name: String? = nil,
                    imageKey: String? = nil,
                    bio: String? = nil) {
            self.name = name
            self.imageKey = imageKey
            self.bio = bio
        }
    }
}
