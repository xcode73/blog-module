//
//  BlogPostModel+View.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import FeatherCore

extension BlogPostModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "content": content,
            "categories": $categories.value != nil ? categories.map(\.leafData) : [],
            "authors": $authors.value != nil ? authors.map(\.leafData) : [],
        ])
    }
}
