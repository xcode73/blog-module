//
//  BlogAuthorModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension AuthorListObject: Content {}
extension AuthorGetObject: Content {}
extension AuthorCreateObject: Content {}
extension AuthorUpdateObject: Content {}
extension AuthorPatchObject: Content {}

struct BlogAuthorApi: FeatherApiRepresentable {
    
    typealias Model = BlogAuthorModel
    
    typealias ListObject = AuthorListObject
    typealias GetObject = AuthorGetObject
    typealias CreateObject = AuthorCreateObject
    typealias UpdateObject = AuthorUpdateObject
    typealias PatchObject = AuthorPatchObject
    
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
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
