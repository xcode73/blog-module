//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension BlogPostListItem: Content { }
extension BlogPost: ValidatableContent {}

extension BlogPostModel: ApiContentRepresentable {
    
    var listContent: BlogPostListItem {
        .init(id: id,
              title: title,
              imageKey: imageKey,
              excerpt: excerpt)
    }

    var getContent: BlogPost {
        .init(id: id,
              title: title,
              imageKey: imageKey,
              excerpt: excerpt,
              content: content,
              categories: [],
              authors: [])
    }

    func create(_ input: BlogPost) throws {
        id = input.id
        title = input.title
        excerpt = input.excerpt
        imageKey = input.imageKey
        content = input.content
    }

    func update(_ input: BlogPost) throws {
        id = input.id
        title = input.title
        excerpt = input.excerpt
        imageKey = input.imageKey
        content = input.content
    }

    func patch(_ input: BlogPost) throws {
        
    }
    
}
