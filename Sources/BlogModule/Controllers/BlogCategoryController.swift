//
//  BlogCategoryAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogCategoryController: PublicFeatherController {

    typealias Module = BlogModule
    typealias Model = BlogCategoryModel

    typealias CreateForm = BlogCategoryEditForm
    typealias UpdateForm = BlogCategoryEditForm
    
    typealias GetApi = BlogCategoryApi
    typealias ListApi = BlogCategoryApi
    typealias CreateApi = BlogCategoryApi
    typealias UpdateApi = BlogCategoryApi
    typealias PatchApi = BlogCategoryApi
    typealias DeleteApi = BlogCategoryApi

    func listTable(_ models: [Model]) -> Table {
        Table(columns: ["title"], rows: models.map { model in
            TableRow(id: model.identifier, cells: [TableCell(model.title)])
        })
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
