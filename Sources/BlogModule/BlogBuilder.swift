//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import Foundation
import ViperKit

@_cdecl("createBlogModule")
public func createBlogModule() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(BlogBuilder()).toOpaque()
}

final class BlogBuilder: ViperBuilder {

    override func build() -> ViperModule {
        BlogModule()
    }
}
