//
//  BlogPostModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogPostListObject: Content {}
extension BlogPostGetObject: Content {}
extension BlogPostCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

extension BlogPostUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
    }
}

extension BlogPostPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
    }
}


extension BlogPostModel: ApiContentRepresentable {

    var listContent: BlogPostListObject {
        .init(id: id!, title: title, imageKey: imageKey, excerpt: excerpt)
    }

    var getContent: BlogPostGetObject {
        .init(id: id!, title: title, imageKey: imageKey, excerpt: excerpt, content: content, categories: [], authors: [])
    }

    func create(_ input: BlogPostCreateObject) throws {
        title = input.title
        imageKey = input.imageKey
        excerpt = input.excerpt
        content = input.content
    }

    func update(_ input: BlogPostUpdateObject) throws {
        title = input.title
        imageKey = input.imageKey
        excerpt = input.excerpt
        content = input.content
    }

    func patch(_ input: BlogPostPatchObject) throws {
        title = input.title ?? title
        imageKey = input.imageKey ?? imageKey
        excerpt = input.excerpt ?? excerpt
        content = input.content ?? content
    }
}


