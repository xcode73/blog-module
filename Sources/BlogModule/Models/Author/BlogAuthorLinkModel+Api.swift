//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogAuthorLink: ValidatableContent {}

extension BlogAuthorLinkModel: ApiContentRepresentable {
    
    var listContent: BlogAuthorLink {
        .init(id: id, label: label, url: url, priority: priority)
    }

    var getContent: BlogAuthorLink {
        .init(id: id, label: label, url: url, priority: priority)
    }

    func create(_ input: BlogAuthorLink) throws {
        
    }

    func update(_ input: BlogAuthorLink) throws {
        
    }

    func patch(_ input: BlogAuthorLink) throws {
        
    }
    
}
