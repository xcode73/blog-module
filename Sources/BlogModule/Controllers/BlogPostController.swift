//
//  BlogPostAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogPostController: PublicFeatherController {

    typealias Module = BlogModule
    typealias Model = BlogPostModel

    typealias CreateForm = BlogPostEditForm
    typealias UpdateForm = BlogPostEditForm
    
    typealias GetApi = BlogPostApi
    typealias ListApi = BlogPostApi
    typealias CreateApi = BlogPostApi
    typealias UpdateApi = BlogPostApi
    typealias PatchApi = BlogPostApi
    typealias DeleteApi = BlogPostApi

    let dateFormatter = Application.dateFormatter()

    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithCategoriesAndAuthorsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "Post not found"))
    }

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title", "date"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [
                        TableCell(model.title),
                        TableCell(dateFormatter.string(from: model.joinedMetadata!.date!))
            ])
        })
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        Model.query(on: req.db).joinMetadata()
    }

    func listContext(req: Request, table: Table, pages: Pagination) -> ListContext {
        .init(info: Model.info(req), table: table, pages: pages)
    }
    
    func detailFields(req: Request, model: Model) -> [DetailContext.Field] {
        [
            .init(label: "Id", value: model.identifier),
            .init(type: .image, label: "Image", value: model.imageKey ?? ""),
            .init(label: "Title", value: model.title),
        ]
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }

    func deleteContext(req: Request, model: Model) -> String {
        model.title
    }
}

/// Overide default Route Builder
extension BlogPostController {

    func listPublicApi(_ req: Request) throws -> EventLoopFuture<PaginationContainer<ListApi.ListObject> > {
        let qb = listLoader
            .qbFromMeta(req, withDeleted: true)
            .filter(
                \.$updatedAt >= req.query["start"]
                    ?? Date(timeIntervalSince1970: 0))
            .filter(
                \.$updatedAt <= req.query["end"]
                    ?? Date())

        return listLoader.paginate(req, qb).map { pc -> PaginationContainer<ListApi.ListObject> in
                let api = ListApi()
                let items = pc.map { api.mapList(model: $0) }
                return items
            }
    }

}
