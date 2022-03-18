//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Fluent
import Feather
import BlogObjects


extension Blog.Post.List: Content {}
extension Blog.Post.Detail: Content {}

struct BlogPostApiController: ApiController {
    typealias ApiModel = Blog.Post
    typealias DatabaseModel = BlogPostModel
    
    static func list(_ req: Request) async throws -> [Blog.Post.List] {
        let posts = try await BlogPostModel.queryJoinPublicMetadata(on: req.db).all()
        let api = BlogPostApiController()
        return try await api.listOutput(req, posts)
    }
    
    static func detailBy(path: String, _ req: Request) async throws -> Blog.Post.Detail? {
        let post = try await BlogPostModel.queryJoinVisibleMetadataFilterBy(path: path, on: req.db)
            .with(\.$categories)
            .with(\.$authors) { $0.with(\.$links) }
            .first()
        guard let post = post else {
            return nil
        }
        return try await BlogPostApiController().detailOutput(req, post)
    }

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Blog.Post.List] {
        try await models.mapAsync { model in
            let categoryApi = BlogCategoryApiController()
            let cats = try await model.$categories.query(on: req.db).joinMetadata().all()
            let categories = try await categoryApi.listOutput(req, cats)

            let authorApi = BlogAuthorApiController()
            let auths = try await model.$authors.query(on: req.db).joinMetadata().all()
            let authors = try await authorApi.listOutput(req, auths)

            return .init(id: model.uuid,
                  title: model.title,
                  imageKey: model.imageKey,
                  excerpt: model.excerpt,
                  metadata: model.featherMetadata,
                  categories: categories,
                  authors: authors)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Blog.Post.Detail {
        let categoryApi = BlogCategoryApiController()
        let cats = try await model.$categories.query(on: req.db).joinMetadata().all()
        let categories = try await categoryApi.listOutput(req, cats)
        let authorApi = BlogAuthorApiController()
        let auths = try await model.$authors.query(on: req.db).joinMetadata().all()
        let authors = try await authorApi.listOutput(req, auths)
        let content = try await model.filter(model.content ?? "", req)
        return .init(id: model.id!,
                     title: model.title,
                     imageKey: model.imageKey,
                     excerpt: model.excerpt,
                     content: content,
                     metadata: model.featherMetadata,
                     categories: categories,
                     authors: authors)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Post.Create) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Post.Update) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.content = input.content
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Post.Patch) async throws {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.content = input.content ?? model.content
    }
    #warning("fixme")
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
//            KeyedContentValidator<String>("title", "Title must be unique", optional: optional) { req, value in
//                try await DatabaseModel.isUnique(req, \.$title == value, Blog.Post.getIdParameter(req))
//            }
        ]
    }
    
    
}
