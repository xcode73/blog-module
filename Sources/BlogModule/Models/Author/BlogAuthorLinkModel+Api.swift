//
//  BlogAuthorLinkModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogAuthorLinkListObject: Content {}
extension BlogAuthorLinkGetObject: Content {}
extension BlogAuthorLinkCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("label", as: String.self, is: !.empty && .count(...250))
        validations.add("url", as: String.self, is: !.empty && .count(...250))
        validations.add("priority", as: Int.self, is: .range(0...9999))
    }
}

extension BlogAuthorLinkUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("label", as: String.self, is: !.empty && .count(...250))
        validations.add("url", as: String.self, is: !.empty && .count(...250))
        validations.add("priority", as: Int.self, is: .range(0...9999))
    }
}

extension BlogAuthorLinkPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("label", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("url", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("priority", as: Int.self, is: .range(0...9999), required: false)
    }
}

extension BlogAuthorLinkModel: ApiContentRepresentable {

    var listContent: BlogAuthorLinkListObject {
        .init(id: id!, label: label, url: url, priority: priority)
    }

    var getContent: BlogAuthorLinkGetObject {
        .init(id: id!, label: label, url: url, priority: priority)
    }

    func create(_ input: BlogAuthorLinkCreateObject) throws {
        label = input.label
        url = input.url
        priority = input.priority
    }

    func update(_ input: BlogAuthorLinkUpdateObject) throws {
        label = input.label
        url = input.url
        priority = input.priority
    }

    func patch(_ input: BlogAuthorLinkPatchObject) throws {
        label = input.label ?? label
        url = input.url ?? url
        priority = input.priority ?? priority
    }
}


