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
        .init(id: model.id!,
              name: model.name,
              imageKey: model.imageKey,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              deletedAt: model.deletedAt)
    }
    
    func mapGet(model: Model) -> GetObject {
        let linkApi = BlogAuthorLinkApi()
        return .init(id: model.id!,
              name: model.name,
              imageKey: model.imageKey,
              bio: model.bio,
              links: (model.$links.value ?? []).map { linkApi.mapList(model: $0) },
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
              deletedAt: model.deletedAt)
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
        return req.eventLoop.future()
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.name = input.name ?? model.name
        model.imageKey = input.imageKey ?? model.imageKey
        model.bio = input.bio ?? model.bio
        return req.eventLoop.future()
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedContentValidator<String>("name", "Name must be unique", optional: optional, nil) { value, req in
                Model.isUniqueBy(\.$name == value, req: req)
            }
        ]
    }
}
