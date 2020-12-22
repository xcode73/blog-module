//
//  BlogCategoryAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Fluent
import FeatherCore

struct BlogCategoryAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias Model = BlogCategoryModel
    typealias CreateForm = BlogCategoryEditForm
    typealias UpdateForm = BlogCategoryEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
        Model.FieldKeys.priority,
    ]

    func listQuery(search: String, queryBuilder: QueryBuilder<BlogCategoryModel>, req: Request) {
        queryBuilder.filter(\.$title ~~ search)
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        if let key = model.imageKey {
            return req.fs.delete(key: key).map { model }
        }
        return req.eventLoop.future(model)
    }
}
