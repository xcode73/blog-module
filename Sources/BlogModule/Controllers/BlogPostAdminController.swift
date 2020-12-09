//
//  BlogPostAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Fluent
import FeatherCore

struct BlogPostAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias Model = BlogPostModel
    typealias CreateForm = BlogPostEditForm
    typealias UpdateForm = BlogPostEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
        "date"
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<BlogPostModel>, req: Request) {
        queryBuilder.filter(\.$title ~~ search)
    }

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<BlogPostModel>) -> QueryBuilder<BlogPostModel> {
        queryBuilder.join(FrontendMetadata.self, on: \FrontendMetadata.$reference == \Model.$id, method: .inner)
    }

    func listQuery(order: FieldKey, sort: ListSort, queryBuilder: QueryBuilder<BlogPostModel>, req: Request) -> QueryBuilder<BlogPostModel> {
        if order == "date" {
            return queryBuilder.sort(FrontendMetadata.self, \.$date, sort.direction)
        }
        return queryBuilder.sort(order, sort.direction)
    }

    func beforeListPageRender(page: ListPage<BlogPostModel>) -> LeafData {
        .dictionary([
            "items": .array(page.items.map(\.leafDataWithMetadata)),
            "info": page.info.leafData
        ])
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
