//
//  BlogPostContext.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 21..
//

import Foundation
import FeatherCore

struct BlogPostContext: Encodable {
    let post: BlogPostModel.ViewContext
    let category: BlogCategoryModel.ViewContext
    let content: Metadata.ViewContext
}
