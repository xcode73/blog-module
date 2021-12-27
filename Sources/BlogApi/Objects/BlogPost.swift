//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public extension Blog {
    
    enum Post: FeatherApiModel {
        public typealias Module = Blog
    }
}

public extension Blog.Post {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var metadata: FeatherMetadata
        public var categories: [Blog.Category.List]
        public var authors: [Blog.Author.List]

        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    metadata: FeatherMetadata,
                    categories: [Blog.Category.List],
                    authors: [Blog.Author.List]) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.metadata = metadata
            self.categories = categories
            self.authors = authors
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        public var metadata: FeatherMetadata
        public var categories: [Blog.Category.List]
        public var authors: [Blog.Author.List]
        
        public init(id: UUID,
                    title: String,
                    imageKey: String?,
                    excerpt: String?,
                    content: String?,
                    metadata: FeatherMetadata,
                    categories: [Blog.Category.List],
                    authors: [Blog.Author.List]) {
            self.id = id
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
            self.metadata = metadata
            self.categories = categories
            self.authors = authors
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        
        public init(title: String,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    content: String? = nil) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var title: String
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        
        public init(title: String,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    content: String? = nil) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var title: String?
        public var imageKey: String?
        public var excerpt: String?
        public var content: String?
        
        public init(title: String? = nil,
                    imageKey: String? = nil,
                    excerpt: String? = nil,
                    content: String? = nil) {
            self.title = title
            self.imageKey = imageKey
            self.excerpt = excerpt
            self.content = content
        }
    }
}
