//
//  BlogAuthorLinkAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorLinkAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias Model = BlogAuthorLinkModel
    typealias CreateForm = BlogAuthorLinkEditForm
    typealias UpdateForm = BlogAuthorLinkEditForm
    
    var idParamKey: String { "linkId" }
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.label,
        Model.FieldKeys.url,
        Model.FieldKeys.priority,
    ]

    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<BlogAuthorLinkModel>) -> QueryBuilder<BlogAuthorLinkModel> {
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            return queryBuilder
        }
        return queryBuilder.filter(\.$author.$id == uuid).sort(\Model.$priority, .descending)
    }
}
