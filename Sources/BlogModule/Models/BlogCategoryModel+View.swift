//
//  BlogCategoryModel+View.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogCategoryModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "color": color,
            "priority": priority,
            "posts": $posts.value != nil ? posts : [],
        ])
    }
}

extension BlogCategoryModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: id!.uuidString, label: title)
    }
}
