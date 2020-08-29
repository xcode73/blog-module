//
//  BlogCategoryModel+Content.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

extension BlogCategoryModel: MetadataChangeDelegate {
    
    var slug: String { Self.name + "/" + self.title.slugify() }
    
    func willUpdate(_ content: Metadata) {
        content.slug = self.slug
        content.title = self.title
    }
}

