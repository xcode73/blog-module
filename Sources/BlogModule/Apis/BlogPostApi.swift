//
//  BlogPostModel+Api.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogApi

extension PostListObject: Content {}
extension PostGetObject: Content {}
extension PostCreateObject: Content {}
extension PostUpdateObject: Content {}
extension PostPatchObject: Content {}

struct BlogPostApi: FeatherApiRepresentable {
    typealias Model = BlogPostModel
    
    typealias ListObject = PostListObject
    typealias GetObject = PostGetObject
    typealias CreateObject = PostCreateObject
    typealias UpdateObject = PostUpdateObject
    typealias PatchObject = PostPatchObject
    
    func mapList(model: Model) -> ListObject {
        .init(id: model.id!,
              title: model.title,
              imageKey: model.imageKey,
              excerpt: model.excerpt,
              updatedAt: model.updatedAt,
              createdAt: model.createdAt,
              deletedAt: model.deletedAt)
    }
    
    func mapGet(model: Model) -> GetObject {
        let categoryApi = BlogCategoryApi()
        let authorApi = BlogAuthorApi()
        return .init(id: model.id!,
                     title: model.title,
                     imageKey: model.imageKey,
                     excerpt: model.excerpt,
                     content: model.content,
                     updatedAt: model.updatedAt,
                     createdAt: model.createdAt,
                     categories: (model.$categories.value ?? []).map { categoryApi.mapList(model: $0) },
                     authors: (model.$authors.value ?? []).map { authorApi.mapList(model: $0) })
    }
    
    func mapCreate(_ req: Request, model: Model, input: CreateObject) -> EventLoopFuture<Void> {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
        return req.eventLoop.future()
    }
        
    func mapUpdate(_ req: Request, model: Model, input: UpdateObject) -> EventLoopFuture<Void> {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
        return req.eventLoop.future()
    }

    func mapPatch(_ req: Request, model: Model, input: PatchObject) -> EventLoopFuture<Void> {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.content = input.content ?? model.content
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
