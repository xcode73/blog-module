//
//  BlogPostModel+Metadata.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogPostModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: title.slugify(), title: title, excerpt: excerpt, imageKey: imageKey)
    }
}

