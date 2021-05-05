//
//  BlogAuthorLinkAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorLinkController: FeatherController {

    typealias Module = BlogModule
    typealias Model = BlogAuthorLinkModel
    
    typealias CreateForm = BlogAuthorLinkEditForm
    typealias UpdateForm = BlogAuthorLinkEditForm
    
    typealias GetApi = BlogAuthorLinkApi
    typealias ListApi = BlogAuthorLinkApi
    typealias CreateApi = BlogAuthorLinkApi
    typealias UpdateApi = BlogAuthorLinkApi
    typealias PatchApi = BlogAuthorLinkApi
    typealias DeleteApi = BlogAuthorLinkApi

    func setupRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Module.moduleKeyPathComponent)
                          .grouped(BlogAuthorModel.modelKeyPathComponent)
                          .grouped(BlogAuthorModel.idParamKeyPathComponent)
                          .grouped(Model.modelKeyPathComponent)
        
        setupListRoute(on: base)
        setupGetRoute(on: base)
        setupCreateRoutes(on: base, as: Model.createPathComponent)
        setupUpdateRoutes(on: base, as: Model.updatePathComponent)
        setupDeleteRoutes(on: base, as: Model.deletePathComponent)
    }
    
    func setupApiRoutes(on builder: RoutesBuilder) {
        let base = builder.grouped(Module.moduleKeyPathComponent)
                          .grouped(BlogAuthorModel.modelKeyPathComponent)
                          .grouped(BlogAuthorModel.idParamKeyPathComponent)
                          .grouped(Model.modelKeyPathComponent)
        
        setupListApiRoute(on: base)
        setupGetApiRoute(on: base)
        setupCreateApiRoute(on: base)
        setupUpdateApiRoute(on: base)
        setupPatchApiRoute(on: base)
        setupDeleteApiRoute(on: base)
    }
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["label", "url"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.label), TableCell(model.url)])
        })
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        let authorId = BlogAuthorModel.getIdParameter(req: req)!

        return ListContext(info: Model.info(req), table: table, pages: pages, nav: [
            BlogAuthorModel.adminLink(for: authorId),
        ], breadcrumb: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: authorId),
            .init(label: "Links", url: req.url.path.safePath()),
        ])
    }
    
    func beforeCreate(req: Request, model: Model) -> EventLoopFuture<Model> {
        guard let authorId = BlogAuthorModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        model.$author.id = authorId
        return req.eventLoop.future(model)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        guard let authorId = BlogAuthorModel.getIdParameter(req: req) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$author.$id == authorId)
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(label: "Label", value: model.label),
            .init(label: "Url", value: model.url),
            .init(label: "Priority", value: String(model.priority)),
        ]
    }

    func getContext(req: Request, model: Model) -> DetailContext {
        let authorId = BlogAuthorModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [], bc: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: authorId),
            Model.adminLink(authorId: authorId),
            .init(label: "View", url: req.url.path.safePath()),
        ])
    }
    
    func deleteContext(req: Request, model: Model) -> String {
        model.label
    }
    
    func deleteContext(req: Request, id: String, token: String, model: Model) -> DeleteContext {
        let authorId = BlogAuthorModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), id: id, token: token, context: deleteContext(req: req, model: model), bc: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: authorId),
            Model.adminLink(authorId: authorId),
            .init(label: "Delete", url: req.url.path.safePath()),
        ])
    }
}
