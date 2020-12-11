//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension BlogCategory: ValidatableContent {}

extension BlogCategoryModel: ApiContentRepresentable {
    
    var listContent: BlogCategory {
        .init(id: id,
              title: title,
              imageKey: imageKey,
              excerpt: excerpt,
              color: color,
              priority: priority)
    }

    var getContent: BlogCategory {
        .init(id: id,
              title: title,
              imageKey: imageKey,
              excerpt: excerpt,
              color: color,
              priority: priority)
    }

    func create(_ input: BlogCategory) throws {
        
    }

    func update(_ input: BlogCategory) throws {
        
    }

    func patch(_ input: BlogCategory) throws {
        
    }
    
}
