//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import Foundation

public struct BlogAuthorLink: Codable {

    public var id: UUID?
    public var label: String
    public var url: String
    public var priority: Int
    
    public init(id: UUID? = nil,
                label: String,
                url: String,
                priority: Int = 100) {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
    }
}
