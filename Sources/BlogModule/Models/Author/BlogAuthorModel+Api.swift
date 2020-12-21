//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogAuthor: ValidatableContent {}

extension BlogAuthorModel: ApiContentRepresentable {
    
    var listContent: BlogAuthor {
        .init(id: id, name: name, imageKey: imageKey, bio: bio, links: [])
    }

    var getContent: BlogAuthor {
        .init(id: id, name: name, imageKey: imageKey, bio: bio, links: [])
    }

    func create(_ input: BlogAuthor) throws {
        
    }

    func update(_ input: BlogAuthor) throws {
        
    }

    func patch(_ input: BlogAuthor) throws {
        
    }
    
}
