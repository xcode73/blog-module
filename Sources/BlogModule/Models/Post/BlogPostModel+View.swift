//
//  BlogPostModel+View.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import FeatherCore

extension BlogPostModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "content": content,
            "categories": $categories.value != nil ? categories.map(\.templateData) : [],
            "authors": $authors.value != nil ? authors.map(\.templateData) : [],
        ])
    }
}
