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
        .init(id: model.id!,
              label: model.label,
              url: model.url,
              priority: model.priority,
              authorId: model.$author.id)
    }
    
    func mapGet(model: Model) -> GetObject {
        .init(id: model.id!,
              label: model.label,
              url: model.url,
              priority: model.priority,
              authorId: model.$author.id)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.label = input.label
        model.url = input.url
        model.priority = input.priority
        model.$author.id = input.authorId
        return req.eventLoop.future()
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.label = input.label
        model.url = input.url
        model.priority = input.priority
        model.$author.id = input.authorId
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.label = input.label ?? model.label
        model.url = input.url ?? model.url
        model.priority = input.priority ?? model.priority
        model.$author.id = input.authorId ?? model.$author.id
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("label", optional: optional),
            KeyedContentValidator<String>.required("url", optional: optional),
            KeyedContentValidator<UUID>.required("authorId", optional: optional),
        ]
    }
}
