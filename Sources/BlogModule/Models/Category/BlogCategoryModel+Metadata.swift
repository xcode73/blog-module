//
//  BlogCategoryModel+Metadata.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogCategoryModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: Self.name + "/" + title.slugify(), title: title, imageKey: imageKey)
    }
}

