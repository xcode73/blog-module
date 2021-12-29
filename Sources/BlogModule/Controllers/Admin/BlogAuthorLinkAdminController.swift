//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 24..
//

struct BlogAuthorLinkAdminController: AdminController {
    typealias ApiModel = Blog.AuthorLink
    typealias DatabaseModel = BlogAuthorLinkModel
    
    typealias CreateModelEditor = BlogAuthorLinkEditor
    typealias UpdateModelEditor = BlogAuthorLinkEditor
     
    static var modelName: FeatherModelName = .init(singular: "link")

    func listQuery(_ req: Request, _ qb: QueryBuilder<DatabaseModel>) async throws -> QueryBuilder<DatabaseModel> {
        guard let id = Blog.Author.getIdParameter(req) else {
            return qb
        }
        return qb.filter(\.$author.$id == id)
    }
    
    func beforeCreate(_ req: Request, model: DatabaseModel) async throws {
        guard let id = Blog.Author.getIdParameter(req) else {
            throw Abort(.badRequest)
        }
        model.$author.id = id
    }
    
    var listConfig: ListConfiguration {
        .init(allowedOrders: [
            "label"
        ])
    }
    
    func listSearch(_ term: String) -> [ModelValueFilter<DatabaseModel>] {
        [
            \.$label ~~ term,
            \.$url ~~ term,
        ]
    }
    
    func listColumns() -> [ColumnContext] {
        [
            .init("label"),
        ]
    }
    
    func listCells(for model: DatabaseModel) -> [CellContext] {
        [
            .init(model.label, link: LinkContext(label: model.label, permission: ApiModel.permission(for: .detail).key)),
        ]
    }
    
    func detailFields(for model: DatabaseModel) -> [FieldContext] {
        [
            .init("id", model.uuid.string),
            .init("label", model.label),
            .init("label", model.url),
            .init("priority", String(model.priority)),
        ]
    }
    
    func deleteInfo(_ model: DatabaseModel) -> String {
        model.label
    }
    
    func getBaseRoutes(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes
            .grouped(Blog.pathKey.pathComponent)
            .grouped(Blog.Author.pathKey.pathComponent)
            .grouped(Blog.Author.pathIdComponent)
            .grouped(ApiModel.pathKey.pathComponent)
    }
    
    func listBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: BlogModule.featherIdentifier.uppercasedFirst,
                        dropLast: 3,
                        permission: Blog.permission(for: .detail).key),
            LinkContext(label: BlogAuthorAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: Blog.Author.permission(for: .list).key),
            LinkContext(label: BlogAuthorAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 1,
                        permission: Blog.Author.permission(for: .detail).key),
        ]
    }
    
    func detailBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: BlogModule.featherIdentifier.uppercasedFirst,
                        dropLast: 4,
                        permission: Blog.permission(for: .detail).key),
            LinkContext(label: BlogAuthorAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: Blog.Author.permission(for: .list).key),
            LinkContext(label: BlogAuthorAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: Blog.Author.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func updateBreadcrumbs(_ req: Request, _ model: DatabaseModel) -> [LinkContext] {
        [
            LinkContext(label: BlogModule.featherIdentifier.uppercasedFirst,
                        dropLast: 5,
                        permission: Blog.permission(for: .detail).key),
            LinkContext(label: BlogAuthorAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 4,
                        permission: Blog.Author.permission(for: .list).key),
            LinkContext(label: BlogAuthorAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 3,
                        permission: Blog.Author.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 2,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
    
    func createBreadcrumbs(_ req: Request) -> [LinkContext] {
        [
            LinkContext(label: BlogModule.featherIdentifier.uppercasedFirst,
                        dropLast: 4,
                        permission: Blog.permission(for: .detail).key),
            LinkContext(label: BlogAuthorAdminController.modelName.plural.uppercasedFirst,
                        dropLast: 3,
                        permission: Blog.Author.permission(for: .list).key),
            LinkContext(label: BlogAuthorAdminController.modelName.singular.uppercasedFirst,
                        dropLast: 2,
                        permission: Blog.Author.permission(for: .detail).key),
            LinkContext(label: Self.modelName.plural.uppercasedFirst,
                        dropLast: 1,
                        permission: ApiModel.permission(for: .list).key),
        ]
    }
}
