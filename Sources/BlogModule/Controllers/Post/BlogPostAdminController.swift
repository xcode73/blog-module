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
    
    // MARK: - list

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

    // MARK: - edit
    
    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
        Model.findWithCategoriesAndAuthorsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "Post not found"))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
