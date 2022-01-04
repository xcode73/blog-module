//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

extension Blog.Author.List: Content {}
extension Blog.Author.Detail: Content {}

struct BlogAuthorApiController: ApiController {
    typealias ApiModel = Blog.Author
    typealias DatabaseModel = BlogAuthorModel
        
    static func list(_ req: Request) async throws -> [Blog.Author.List] {
        let authors = try await BlogAuthorModel.queryJoinPublicMetadata(on: req.db).all()
        let api = BlogAuthorApiController()
        return try await api.listOutput(req, authors)
    }
    
    static func detailBy(path: String, _ req: Request) async throws -> Blog.Author.Detail? {
        let author = try await BlogAuthorModel
            .queryJoinVisibleMetadataFilterBy(path: path, on: req.db)
            .with(\.$links)
            .first()
        guard let author = author else {
            return nil
        }
        return try await BlogAuthorApiController().detailOutput(req, author)
    }


    func listOutput(_ req: Request, _ models: [DatabaseModel]) async throws -> [Blog.Author.List] {
        try await models.mapAsync { model -> Blog.Author.List in
            let linkApi = BlogAuthorLinkApiController()
            let lnks = try await model.$links.get(on: req.db)
            let links = try await linkApi.listOutput(req, lnks)

            return .init(id: model.uuid,
                  name: model.name,
                  imageKey: model.imageKey,
                  bio: model.bio,
                  links: links,
                  metadata: model.featherMetadata)
        }
    }
    
    func detailOutput(_ req: Request, _ model: DatabaseModel) async throws -> Blog.Author.Detail {
        let posts = try await model.$posts.query(on: req.db).joinPublicMetadata().all()
        let postList = try await BlogPostApiController().listOutput(req, posts)
        let linkApi = BlogAuthorLinkApiController()
        let links = try await linkApi.listOutput(req, model.links)
        return .init(id: model.uuid,
                     name: model.name,
                     imageKey: model.imageKey,
                     bio: model.bio,
                     links: links,
                     metadata: model.featherMetadata,
                     posts: postList)
    }
    
    func createInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Author.Create) async throws {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
    }
    
    func updateInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Author.Update) async throws {
        model.name = input.name
        model.imageKey = input.imageKey
        model.bio = input.bio
    }
    
    func patchInput(_ req: Request, _ model: DatabaseModel, _ input: Blog.Author.Patch) async throws {
        model.name = input.name ?? model.name
        model.imageKey = input.imageKey ?? model.imageKey
        model.bio = input.bio ?? model.bio
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        [
            KeyedContentValidator<String>.required("name", optional: optional),
            KeyedContentValidator<String>("name", "Name must be unique", optional: optional) { value, req in
                try await DatabaseModel.isUnique(req, \.$name == value, Blog.Author.getIdParameter(req))
            }
        ]
    }
    
}
