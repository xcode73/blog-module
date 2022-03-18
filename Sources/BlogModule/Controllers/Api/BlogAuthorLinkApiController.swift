//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 21..
//

import Vapor
import Fluent
import Feather
import BlogObjects

extension Blog.AuthorLink.List: Content {}
extension Blog.AuthorLink.Detail: Content {}

struct BlogAuthorLinkApiController: ApiController {
    typealias ApiModel = Blog.AuthorLink
        
    typealias DatabaseModel = BlogAuthorLinkModel
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes
            .grouped(Blog.pathKey.pathComponent)
            .grouped(Blog.Author.pathKey.pathComponent)
            .grouped(Blog.Author.pathIdComponent)
            .grouped(ApiModel.pathKey.pathComponent)
    }

    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Blog.AuthorLink.List] {
        models.map { model in
            .init(id: model.uuid,
                  label: model.label,
                  url: model.url,
                  priority: model.priority,
                  authorId: model.$author.id)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Blog.AuthorLink.Detail {
        .init(id: model.uuid,
              label: model.label,
              url: model.url,
              priority: model.priority,
              authorId: model.$author.id)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.AuthorLink.Create) async throws {
        model.label = input.label
        model.url = input.url
        model.priority = input.priority
        model.$author.id = input.authorId
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.AuthorLink.Update) async throws {
        model.label = input.label
        model.url = input.url
        model.priority = input.priority
        model.$author.id = input.authorId
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.AuthorLink.Patch) async throws {
        model.label = input.label ?? model.label
        model.url = input.url ?? model.url
        model.priority = input.priority ?? model.priority
        model.$author.id = input.authorId ?? model.$author.id
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("label", optional: optional),
            KeyedContentValidator<String>.required("url", optional: optional),
            KeyedContentValidator<UUID>.required("authorId", optional: optional),
        ]
    }
}
