//
//  BlogAuthorModel+Metadata.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogAuthorModel: FrontendMetadataChangeDelegate {

    var slug: String { Self.name + "/" + name.slugify() }

    func willUpdate(_ metadata: FrontendMetadata) {
        metadata.slug = slug
        metadata.title = name
        metadata.excerpt = bio
        metadata.imageKey = imageKey
    }
}
