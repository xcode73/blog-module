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
        var future = req.eventLoop.future(model)
        if let key = model.imageKey {
            future = req.fs.delete(key: key).map { model }
        }
        return future
    }
}
