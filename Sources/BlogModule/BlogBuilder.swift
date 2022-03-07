//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 27..
//

import Feather

@_cdecl("createBlogModule")
public func createBlogModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(BlogBuilder()).toOpaque()
}

public final class BlogBuilder: FeatherModuleBuilder {

    public override func build() -> FeatherModule {
        BlogModule()
    }
}
