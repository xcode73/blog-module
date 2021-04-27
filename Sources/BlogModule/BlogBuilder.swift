//
//  BlogBuilder.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import FeatherCore

@_cdecl("createBlogModule")
public func createBlogModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(BlogBuilder()).toOpaque()
}

public final class BlogBuilder: FeatherModuleBuilder {

    public override func build() -> FeatherModule {
        BlogModule()
    }
}
