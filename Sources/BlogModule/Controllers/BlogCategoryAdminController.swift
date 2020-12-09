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

    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$title ~~ searchTerm)
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
