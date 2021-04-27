//
//  BlogAuthorLinkLinkModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

extension BlogAuthorLinkListObject: Content {}
extension BlogAuthorLinkGetObject: Content {}
extension BlogAuthorLinkCreateObject: Content {}
extension BlogAuthorLinkUpdateObject: Content {}
extension BlogAuthorLinkPatchObject: Content {}

struct BlogAuthorLinkApi: FeatherApiRepresentable {
    typealias Model = BlogAuthorLinkModel
    
    typealias ListObject = BlogAuthorLinkListObject
    typealias GetObject = BlogAuthorLinkGetObject
    typealias CreateObject = BlogAuthorLinkCreateObject
    typealias UpdateObject = BlogAuthorLinkUpdateObject
    typealias PatchObject = BlogAuthorLinkPatchObject
    
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
