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
    
    static var bundleUrl: URL? { Bundle.module.resourceURL?.appendingPathComponent("Bundle") }

    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigration_v1())
        /// frontend middleware
        app.databases.middleware.use(MetadataModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogAuthorModel>())
        /// install
        app.hooks.register(.installStep, use: installStepHook)
        app.hooks.register(.installResponse, use: installResponseHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        app.hooks.register(.installVariables, use: installVariablesHook)
        app.hooks.register(.installMainMenuItems, use: installMainMenuItemsHook)
        app.hooks.register(.installPages, use: installPagesHook)
        /// routes
        let router = BlogRouter()
        try router.bootAndRegisterHooks(app)
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
              item: .init(icon: "file-text", link: Self.adminLink, priority: 1100, permission: Self.permission(for: .custom("admin")).identifier),
              children: [
                .init(link: BlogPostModel.adminLink, permission: BlogPostModel.permission(for: .list).identifier),
                .init(link: BlogCategoryModel.adminLink, permission: BlogCategoryModel.permission(for: .list).identifier),
                .init(link: BlogAuthorModel.adminLink, permission: BlogAuthorModel.permission(for: .list).identifier),
              ])
    }
    
    func installStepHook(args: HookArguments) -> [InstallStep] {
        [
            .init(key: Self.moduleKey)
        ]
    }

    func installResponseHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args.req
        let currentStep = args.currentInstallStep
        guard currentStep == Self.moduleKey else {
            return req.eventLoop.future(nil)
        }

        let nextStep = args.nextInstallStep
        let performStep: Bool = req.query["next"] ?? false
        let controller = UserInstallController()
        
        if performStep {
            return controller.performUserStep(req: req, nextStep: nextStep).map {
                if let response = $0 {
                    return response
                }
                return req.redirect(to: "/install/" + nextStep + "/")
            }
        }
        return controller.userStep(req: req).encodeOptionalResponse(for: req)
    }
}
