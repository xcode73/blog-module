//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 26..
//

public extension Blog {
    
    enum AuthorLink: FeatherApiModel {
        public typealias Module = Blog
        
        public static var pathKey: String { "links" }
        
        public static let defaultPriority = 100
    }
}

public extension Blog.AuthorLink {
    
    // MARK: -
    
    struct List: Codable {
        public var id: UUID
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID

        public init(id: UUID,
                    label: String,
                    url: String,
                    priority: Int,
                    authorId: UUID) {
            self.id = id
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }
    }
    
    // MARK: -
    
    struct Detail: Codable {
        public var id: UUID
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID
        
        public init(id: UUID,
                    label: String,
                    url: String,
                    priority: Int,
                    authorId: UUID) {
            self.id = id
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }
    }
    
    // MARK: -
    
    struct Create: Codable {
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID
        
        public init(label: String,
                    url: String,
                    priority: Int = Blog.AuthorLink.defaultPriority,
                    authorId: UUID) {
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }
    }
    
    // MARK: -
    
    struct Update: Codable {
        public var label: String
        public var url: String
        public var priority: Int
        public let authorId: UUID
        
        public init(label: String,
                    url: String,
                    priority: Int = Blog.AuthorLink.defaultPriority,
                    authorId: UUID) {
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }
    }
    
    // MARK: -
    
    struct Patch: Codable {
        public var label: String?
        public var url: String?
        public var priority: Int?
        public let authorId: UUID?
        
        public init(label: String? = nil,
                    url: String? = nil,
                    priority: Int? = nil,
                    authorId: UUID? = nil) {
            self.label = label
            self.url = url
            self.priority = priority
            self.authorId = authorId
        }
    }
}
