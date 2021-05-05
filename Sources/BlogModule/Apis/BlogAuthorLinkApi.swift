//
//  BlogAuthorLinkLinkModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension AuthorLinkListObject: Content {}
extension AuthorLinkGetObject: Content {}
extension AuthorLinkCreateObject: Content {}
extension AuthorLinkUpdateObject: Content {}
extension AuthorLinkPatchObject: Content {}

struct BlogAuthorLinkApi: FeatherApiRepresentable {
    typealias Model = BlogAuthorLinkModel
    
    typealias ListObject = AuthorLinkListObject
    typealias GetObject = AuthorLinkGetObject
    typealias CreateObject = AuthorLinkCreateObject
    typealias UpdateObject = AuthorLinkUpdateObject
    typealias PatchObject = AuthorLinkPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!, label: model.label, url: model.url, priority: model.priority)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!, label: model.label, url: model.url, priority: model.priority)
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
