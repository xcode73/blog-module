//
//  BlogAuthorModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi


extension BlogAuthorListObject: Content {}
extension BlogAuthorGetObject: Content {}
extension BlogAuthorCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250))
    }
}

extension BlogAuthorUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250))
    }
}

extension BlogAuthorPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
    }
}


extension BlogAuthorModel: ApiContentRepresentable {

    var listContent: BlogAuthorListObject {
        .init(id: id!, name: name, imageKey: imageKey)
    }

    var getContent: BlogAuthorGetObject {
        let linkObjects = $links.value != nil ? links : []
        return .init(id: id!, name: name, imageKey: imageKey, bio: bio, links: linkObjects.map(\.listContent))
    }

    func create(_ input: BlogAuthorCreateObject) throws {
        name = input.name
        imageKey = input.imageKey
        bio = input.bio
    }

    func update(_ input: BlogAuthorUpdateObject) throws {
        name = input.name
        imageKey = input.imageKey
        bio = input.bio
    }

    func patch(_ input: BlogAuthorPatchObject) throws {
        name = input.name ?? name
        imageKey = input.imageKey ?? imageKey
        bio = input.bio ?? bio
    }
}


