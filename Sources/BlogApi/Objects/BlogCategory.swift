//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public extension Blog {
    
    enum Category: FeatherApiModel {
        public typealias Module = Blog
        
        public static let defaultPriority = 100
        
        public static var pathKey: String { "categories" }
    }
}

public extension Blog.Category {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var color: String?
        public var priority: Int
        public var excerpt: String?
        public var metadata: FeatherMetadata
        
        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    color: String?,
                    priority: Int,
                    excerpt: String? = nil,
                    metadata: FeatherMetadata) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.color = color
            self.priority = priority
            self.excerpt = excerpt
            self.metadata = metadata
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int
        public var metadata: FeatherMetadata
        public var posts: [Blog.Post.List]
        
        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    color: String?,
                    priority: Int,
                    metadata: FeatherMetadata,
                    posts: [Blog.Post.List]) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
            self.metadata = metadata
            self.posts = posts
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int
        
        public init(title: String,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    color: String? = nil,
                    priority: Int = Blog.Category.defaultPriority) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int

        public init(title: String,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    color: String? = nil,
                    priority: Int = Blog.Category.defaultPriority) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var title: String?
        public var imageKey: String?
        public var excerpt: String?
        public var color: String?
        public var priority: Int?
        
        public init(title: String? = nil,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    color: String? = nil,
                    priority: Int? = nil) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.color = color
            self.priority = priority
        }
    }
}
