//
//  BlogCategoryModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogCategoryListObject: Content {}
extension BlogCategoryGetObject: Content {}
extension BlogCategoryCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("color", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("priority", as: Int.self, is: .range(0...9999))
    }
}

extension BlogCategoryUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250))
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("color", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("priority", as: Int.self, is: .range(0...9999))
    }
}

extension BlogCategoryPatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("imageKey", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("color", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("priority", as: Int.self, is: .range(0...9999), required: false)
    }
}


extension BlogCategoryModel: ApiContentRepresentable {

    var listContent: BlogCategoryListObject {
        .init(id: id!, title: title, imageKey: imageKey, color: color, priority: priority)
    }

    var getContent: BlogCategoryGetObject {
        .init(id: id!, title: title, imageKey: imageKey, excerpt: excerpt, color: color, priority: priority)
    }

    func create(_ input: BlogCategoryCreateObject) throws {
        title = input.title
        imageKey = input.imageKey
        color = input.color
        priority = input.priority
    }

    func update(_ input: BlogCategoryUpdateObject) throws {
        title = input.title
        imageKey = input.imageKey
        color = input.color
        priority = input.priority
    }

    func patch(_ input: BlogCategoryPatchObject) throws {
        title = input.title ?? title
        imageKey = input.imageKey ?? imageKey
        color = input.color ?? color
        priority = input.priority ?? priority
    }
}


