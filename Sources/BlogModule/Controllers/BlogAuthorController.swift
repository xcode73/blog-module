//
//  BlogAuthorAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorController: PublicFeatherController {

    typealias Module = BlogModule
    typealias Model = BlogAuthorModel

    typealias CreateForm = BlogAuthorEditForm
    typealias UpdateForm = BlogAuthorEditForm
    
    typealias GetApi = BlogAuthorApi
    typealias ListApi = BlogAuthorApi
    typealias CreateApi = BlogAuthorApi
    typealias UpdateApi = BlogAuthorApi
    typealias PatchApi = BlogAuthorApi
    typealias DeleteApi = BlogAuthorApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["name"],
              rows: models.map { model in
                TableRow(id: model.identifier, cells: [TableCell(model.name)])
              },
              action: TableRowAction(label: "Links",
                                     icon: "list",
                                     url: "/links/",
                                     permission: BlogAuthorLinkModel.permission(for: .list).identifier))
    }
    
    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(type: .image, label: "Image", value: model.imageKey ?? ""),
            .init(label: "Name", value: model.name),
            .init(label: "Bio", value: model.bio ?? ""),
        ]
    }
    
    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.query(on: db)
            .filter(\.$id == id)
            .with(\.$links)
            .first()
            .unwrap(or: Abort(.notFound))
    }
   
    func getContext(req: Request, model: Model) -> DetailContext {
        .init(model: Model.info(req), fields: detailFields(req: req, model: model), nav: [
            BlogAuthorLinkModel.adminLink(authorId: model.id!),
        ])
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }

    func deleteContext(req: Request, model: Model) -> String {
        model.name
    }

}
