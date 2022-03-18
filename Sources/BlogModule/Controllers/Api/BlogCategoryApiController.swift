//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import Feather
import BlogObjects


extension Blog.Category.List: Content {}
extension Blog.Category.Detail: Content {}


struct BlogCategoryApiController: ApiController {
    typealias ApiModel = Blog.Category
    typealias DatabaseModel = BlogCategoryModel
    
    static func list(_ req: Request) async throws -> [Blog.Category.List] {
        let categories = try await BlogCategoryModel.queryJoinPublicMetadata(on: req.db).all()
        let api = BlogCategoryApiController()
        return try await api.listOutput(req, categories)
    }
    
    static func detailBy(path: String, _ req: Request) async throws -> Blog.Category.Detail? {
        let category = try await BlogCategoryModel.queryJoinVisibleMetadataFilterBy(path: path, on: req.db).first()
        guard let category = category else {
            return nil
        }
        let api = BlogCategoryApiController()
        return try await api.detailOutput(req, category)
    }

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Blog.Category.List] {
        models.map { model in
                .init(id: model.uuid,
                      title: model.title,
                      imageKey: model.imageKey,
                      color: model.color,
                      priority: model.priority,
                      excerpt: model.excerpt,
                      metadata: model.featherMetadata)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Blog.Category.Detail {
        let posts = try await model.$posts.query(on: req.db).joinPublicMetadata().all()
        let postList = try await BlogPostApiController().listOutput(req, posts)
        return .init(id: model.uuid,
                     title: model.title,
                     imageKey: model.imageKey,
                     excerpt: model.excerpt,
                     color: model.color,
                     priority: model.priority,
                     metadata: model.featherMetadata,
                     posts: postList)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Category.Create) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Category.Update) async throws {
        model.title = input.title
        model.imageKey = input.imageKey
        model.excerpt = input.excerpt
        model.color = input.color
        model.priority = input.priority
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Category.Patch) async throws {
        model.title = input.title ?? model.title
        model.imageKey = input.imageKey ?? model.imageKey
        model.excerpt = input.excerpt ?? model.excerpt
        model.color = input.color ?? model.color
        model.priority = input.priority ?? model.priority
    }
    
    #warning("fixme")
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("title", optional: optional),
//            KeyedContentValidator<String>("title", "Title must be unique", optional: optional) { req, value in
//                try await DatabaseModel.isUnique(req, \.$title == value, Blog.Category.getIdParameter(req))
//            }
        ]
    }
    
}
