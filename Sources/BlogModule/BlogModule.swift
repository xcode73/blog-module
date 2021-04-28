//
//  BlogModule.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Fluent
import FeatherCore

final class BlogModule: FeatherModule {

    static let moduleKey: String = "blog"
    
    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigration_v1_0_0())
        /// frontend middleware
        app.databases.middleware.use(MetadataModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogAuthorModel>())
        /// install
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installMainMenuItems, use: installMainMenuItemsHook)
        app.hooks.register(.installPages, use: installPagesHook)
        /// routes
        let router = BlogRouter()
        try router.boot(routes: app.routes)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.apiAdminRoutes, use: router.apiAdminRoutesHook)

        /// admin
        app.hooks.register(.adminMenu, use: adminMenuHook)

        /// frontend
        let webController = BlogWebController()
        app.hooks.register(.response, use: webController.authorResponseHook)
        app.hooks.register(.response, use: webController.categoryResponseHook)
        app.hooks.register(.response, use: webController.postResponseHook)
        app.hooks.register("blog-home-page", use: webController.blogHomePageHook)
        app.hooks.register("blog-categories-page", use: webController.categoriesPageHook)
        app.hooks.register("blog-authors-page", use: webController.authorsPageHook)
        app.hooks.register("blog-posts-page", use: webController.postsPageHook)
    }

    // MARK: - hooks

    func adminMenuHook(args: HookArguments) -> HookObjects.AdminMenu {
        .init(key: "blog",
              item: .init(icon: "blog", link: Self.adminLink, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: BlogPostModel.adminLink, permission: BlogPostModel.permission(for: .list).identifier),
                .init(link: BlogCategoryModel.adminLink, permission: BlogCategoryModel.permission(for: .list).identifier),
                .init(link: BlogAuthorModel.adminLink, permission: BlogAuthorModel.permission(for: .list).identifier),
              ])
    }
}
