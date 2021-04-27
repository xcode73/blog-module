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
    
    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["label", "url"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.label), TableCell(model.url)])
        })
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        let menuId = BlogAuthorModel.getIdParameter(req: req)!

        return ListContext(info: Model.info(req), table: table, pages: pages, nav: [
            BlogAuthorModel.adminLink(for: menuId),
        ], breadcrumb: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: menuId),
            .init(label: "Links", url: req.url.path.safePath()),
        ])
    }
    
    func beforeCreate(req: Request, model: Model) -> EventLoopFuture<Model> {
        guard let menuId = BlogAuthorModel.getIdParameter(req: req) else {
            return req.eventLoop.future(error: Abort(.badRequest))
        }
        model.$author.id = menuId
        return req.eventLoop.future(model)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        guard let menuId = BlogAuthorModel.getIdParameter(req: req) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$author.$id == menuId)
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
        let menuId = BlogAuthorModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [], bc: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: menuId),
            Model.adminLink(authorId: menuId),
            .init(label: "View", url: req.url.path.safePath()),
        ])
    }
    
    func deleteContext(req: Request, model: Model) -> String {
        model.label
    }
    
    func deleteContext(req: Request, id: String, token: String, model: Model) -> DeleteContext {
        let menuId = BlogAuthorModel.getIdParameter(req: req)!
        return .init(model: Model.info(req), id: id, token: token, context: deleteContext(req: req, model: model), bc: [
            Module.adminLink,
            BlogAuthorModel.adminLink,
            BlogAuthorModel.adminLink(for: menuId),
            Model.adminLink(authorId: menuId),
            .init(label: "Delete", url: req.url.path.safePath()),
        ])
    }
}


//struct BlogAuthorLinkAdminController: FeatherController {
//
//    typealias Module = BlogModule
//    typealias Model = BlogAuthorLinkModel
//    typealias CreateForm = BlogAuthorLinkEditForm
//    typealias UpdateForm = BlogAuthorLinkEditForm
//    
//    var idParamKey: String { "linkId" }
//    
//    var listAllowedOrders: [FieldKey] = [
//        Model.FieldKeys.label,
//        Model.FieldKeys.url,
//        Model.FieldKeys.priority,
//    ]
//
//    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<BlogAuthorLinkModel>) -> QueryBuilder<BlogAuthorLinkModel> {
//        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
//            return queryBuilder
//        }
//        return queryBuilder.filter(\.$author.$id == uuid).sort(\Model.$priority, .descending)
//    }
//}
