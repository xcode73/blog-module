//
//  BlogCategoryModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension CategoryListObject: Content {}
extension CategoryGetObject: Content {}
extension CategoryCreateObject: Content {}
extension CategoryUpdateObject: Content {}
extension CategoryPatchObject: Content {}

struct BlogCategoryApi: FeatherApiRepresentable {
    typealias Model = BlogCategoryModel
    
    typealias ListObject = CategoryListObject
    typealias GetObject = CategoryGetObject
    typealias CreateObject = CategoryCreateObject
    typealias UpdateObject = CategoryUpdateObject
    typealias PatchObject = CategoryPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!,
              title: model.title,
              imageKey: model.imageKey,
              color: model.color,
              priority: model.priority,
              updated_at: model.updatedAt,
              created_at: model.createdAt,
              deleted_at: model.deletedAt)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              title: model.title,
              imageKey: model.imageKey,
              excerpt: model.excerpt,
              color: model.color,
              priority: model.priority,
              updated_at: model.updatedAt,
              created_at: model.createdAt)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
        return req.eventLoop.future()
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.color = input.color ?? model.color
        model.priority = input.priority ?? model.priority
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
            KeyedContentValidator<String>("title", "Title must be unique", optional: optional, nil) { value, req in
                Model.isUniqueBy(\.$title == value, req: req)
            }
        ]
    }
}
