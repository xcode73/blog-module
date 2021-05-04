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
extension BlogCategoryCreateObject: Content {}
extension BlogCategoryUpdateObject: Content {}
extension BlogCategoryPatchObject: Content {}

struct BlogCategoryApi: FeatherApiRepresentable {
    typealias Model = BlogCategoryModel
    
    typealias ListObject = BlogCategoryListObject
    typealias GetObject = BlogCategoryGetObject
    typealias CreateObject = BlogCategoryCreateObject
    typealias UpdateObject = BlogCategoryUpdateObject
    typealias PatchObject = BlogCategoryPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, title: model.title, imageKey: model.imageKey, color: model.color, priority: model.priority, updated_at: model.updatedAt, created_at: model.createdAt, deleted_at: model.deletedAt)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, title: model.title, imageKey: model.imageKey, excerpt: model.excerpt, color: model.color, priority: model.priority, updated_at: model.updatedAt, created_at: model.createdAt)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
    }
    
    func validateCreate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validateUpdate(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
    
    func validatePatch(_ req: Request) -> EventLoopFuture<Bool> {
        req.eventLoop.future(true)
    }
}
