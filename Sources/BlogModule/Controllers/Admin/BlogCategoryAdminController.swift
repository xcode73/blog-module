//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

import Vapor
import Fluent
import Feather
import BlogObjects

struct BlogCategoryAdminController: AdminController {
    typealias ApiModel = Blog.Category
    typealias DatabaseModel = BlogCategoryModel
    
    typealias CreateModelEditor = BlogCategoryEditor
    typealias UpdateModelEditor = BlogCategoryEditor
    
    static var modelName: FeatherModelName = .init(singular: "category", plural: "categories")
 
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "title"
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("title"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.title, link: LinkContext(label: model.title, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("title", model.title),
            .init("excerpt", model.excerpt),
            .init("color", model.color),
            .init("priority", String(model.priority)),
        ]
    }
    
    func afterDelete(_ req: Request, _ model: DatabaseModel) async throws {
        if let key = model.imageKey {
            try await req.fs.delete(key: key)
        }
        if let key = model.featherMetadata.imageKey {
            try await req.fs.delete(key: key)
        }
    }

    func deleteInfo(_ model: DatabaseModel) -> String {
        model.title
    }
}
