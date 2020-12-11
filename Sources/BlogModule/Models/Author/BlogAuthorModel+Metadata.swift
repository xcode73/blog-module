//
//  BlogAuthorModel+Metadata.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogAuthorModel: MetadataRepresentable {

    var metadata: Metadata {
        .init(slug: Self.name + "/" + name.slugify(), title: name, excerpt: bio, imageKey: imageKey)
    }
}
