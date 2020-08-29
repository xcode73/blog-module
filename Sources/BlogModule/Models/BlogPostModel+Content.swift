//
//  BlogPostModel+Content.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

extension BlogPostModel: MetadataChangeDelegate {
    
    var slug: String { self.title.slugify() }
    
    func willUpdate(_ content: Metadata) {
        content.slug = self.slug
        content.title = self.title
        content.excerpt = self.excerpt
        content.imageKey = self.imageKey
    }
}

