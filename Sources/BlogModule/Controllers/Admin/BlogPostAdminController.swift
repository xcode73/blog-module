//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Fluent
import Feather
import BlogApi


struct BlogPostAdminController: AdminController {
    typealias ApiModel = Blog.Post
    typealias DatabaseModel = BlogPostModel
    
    typealias CreateModelEditor = BlogPostEditor
    typealias UpdateModelEditor = BlogPostEditor
    
    func findBy(_ id: UUID, on db: Database) async throws -> DatabaseModel {
        try await DatabaseModel.findWithCategoriesAndAuthorsBy(id: id, on: db)
    }

    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "date",
            "title"
        ], defaultSort: .desc)
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$title ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("image", width: "4rem"),
            .init("title"),
            .init("date"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.imageKey, link: LinkContext(label: model.title, permission: Blog.Post.permission(for: .detail).key), type: .image),
            .init(model.title, link: LinkContext(label: model.title, permission: Blog.Post.permission(for: .detail).key)),
            .init(Feather.dateFormatter().string(from: model.featherMetadata.date)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("image", model.imageKey, type: .image),
            .init("id", model.uuid.string),
            .init("title", model.title),
            .init("categories", model.categories.map(\.title).joined(separator: "\n")),
            .init("authors", model.authors.map(\.name).joined(separator: "\n")),
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
