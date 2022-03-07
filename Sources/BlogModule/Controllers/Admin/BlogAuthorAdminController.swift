//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 17..
//

import Vapor
import Fluent
import Feather
import FeatherApi
import BlogApi

struct BlogAuthorAdminController: AdminController {
    typealias ApiModel = Blog.Author
    typealias DatabaseModel = BlogAuthorModel
    
    typealias CreateModelEditor = BlogAuthorEditor
    typealias UpdateModelEditor = BlogAuthorEditor
    
    
    //    func listQuery(_ req: Request, _ qb: QueryBuilder<BlogAuthorModel>) async throws -> QueryBuilder<BlogAuthorModel> {
    //        let id = try req.getUserAccount().id.string
    //        return qb.filter(\.$bio == id )
    //    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "name"
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$name ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("name"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.name, link: LinkContext(label: model.name, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [DetailContext] {
        [
            .init("id", model.uuid.string),
            .init("name", model.name),
            .init("bio", model.bio),
        ]
    }
    
    func beforeDelete(_ req: Request, _ model: DatabaseModel) async throws {
        try await model.$links.query(on: req.db).delete()
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
        model.name
    }
    
    
    func detailNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Update",
                        path: "update",
                        permission: Blog.Author.permission(for: .update).key),

            LinkContext(label: BlogAuthorLinkAdminController.modelName.plural,
                        path: Blog.AuthorLink.pathKey,
                        permission: Blog.AuthorLink.permission(for: .list).key),
            
            LinkContext(label: "Preview",
                        path: model.featherMetadata.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            
            LinkContext(label: "Metadata",
                        path: "/admin/system/metadatas/" + model.featherMetadata.id.string + "/update/",
                        absolute: true,
                        permission: FeatherMetadata.permission(for: .update).key),
        ]
    }
    
    func updateNavigation(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: "Details",
                        dropLast: 1,
                        permission: Blog.Author.permission(for: .detail).key),
            
            LinkContext(label: BlogAuthorLinkAdminController.modelName.plural,
                        path: Blog.AuthorLink.pathKey,
                        dropLast: 1,
                        permission: Blog.AuthorLink.permission(for: .list).key),
            
            LinkContext(label: "Preview",
                        path: model.featherMetadata.slug.safePath(),
                        absolute: true,
                        isBlank: true),
            
            LinkContext(label: "Metadata",
                        path: "/admin/system/metadatas/" + model.featherMetadata.id.string + "/update/",
                        absolute: true,
                        permission: FeatherMetadata.permission(for: .update).key),
        ]
    }
}
