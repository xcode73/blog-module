//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

struct BlogRouter: FeatherRouter {
 
    let authorAdminController = BlogAuthorAdminController()
    let authorApiController = BlogAuthorApiController()
    let authorLinkAdminController = BlogAuthorLinkAdminController()
    let authorLinkApiController = BlogAuthorLinkApiController()
    let categoryAdminController = BlogCategoryAdminController()
    let categoryApiController = BlogCategoryApiController()
    let postAdminController = BlogPostAdminController()
    let postApiController = BlogPostApiController()

    func adminRoutesHook(args: HookArguments) {
        authorAdminController.setupRoutes(args.routes)
        authorLinkAdminController.setupRoutes(args.routes)
        categoryAdminController.setupRoutes(args.routes)
        postAdminController.setupRoutes(args.routes)
        
        args.routes.get("blog") { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Blog", message: "module information", links: [
                .init(label: "Posts", path: "/admin/blog/posts/"),
                .init(label: "Categories", path: "/admin/blog/categories/"),
                .init(label: "Authors", path: "/admin/blog/authors/"),
            ]))
            return req.templates.renderHtml(template)
        }
    }
    
    func apiRoutesHook(args: HookArguments) {
        authorApiController.setupRoutes(args.routes)
        authorLinkApiController.setupRoutes(args.routes)
        categoryApiController.setupRoutes(args.routes)
        postApiController.setupRoutes(args.routes)
    }
}
