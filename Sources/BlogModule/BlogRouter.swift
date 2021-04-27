//
//  BlogRouter.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

struct BlogRouter: RouteCollection {

    let postController = BlogPostController()
    let categoryController = BlogCategoryController()
    let authorController = BlogAuthorController()
    let authorLinkController = BlogAuthorLinkController()

    func boot(routes: RoutesBuilder) throws {
        
    }

    func adminRoutesHook(args: HookArguments) {
        let adminRoutes = args.routes
        
        adminRoutes.get("blog", use: SystemAdminMenuController(key: "blog").moduleView)

        adminRoutes.register(postController)
        adminRoutes.register(categoryController)
        adminRoutes.register(authorController)
        adminRoutes.register(authorLinkController)
    }
    
    func apiRoutesHook(args: HookArguments) {
//        let publicApiRoutes = args.routes
    }
    
    func apiAdminRoutesHook(args: HookArguments) {
        let apiRoutes = args.routes

        apiRoutes.registerApi(postController)
        apiRoutes.registerApi(categoryController)
        apiRoutes.registerApi(authorController)
        apiRoutes.registerApi(authorLinkController)
    }
    
}

