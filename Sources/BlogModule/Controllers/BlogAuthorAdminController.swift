//
//  BlogAuthorAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorAdminController: ViperAdminViewController {
    
    typealias Module = BlogModule
    typealias Model = BlogAuthorModel
    typealias CreateForm = BlogAuthorEditForm
    typealias UpdateForm = BlogAuthorEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
    ]
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: model.imageKey).map { model }
    }
}
