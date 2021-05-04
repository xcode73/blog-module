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
extension BlogAuthorCreateObject: Content {}
extension BlogAuthorUpdateObject: Content {}
extension BlogAuthorPatchObject: Content {}

struct BlogAuthorApi: FeatherApiRepresentable {
    typealias Model = BlogAuthorModel
    
    typealias ListObject = BlogAuthorListObject
    typealias GetObject = BlogAuthorGetObject
    typealias CreateObject = BlogAuthorCreateObject
    typealias UpdateObject = BlogAuthorUpdateObject
    typealias PatchObject = BlogAuthorPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, name: model.name, imageKey: model.imageKey, updated_at: model.updatedAt, created_at: model.createdAt, deleted_at: model.deletedAt)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, name: model.name, imageKey: model.imageKey, bio: model.bio, updated_at: model.updatedAt, created_at: model.createdAt, links: [])
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
