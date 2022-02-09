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
        authorAdminController.setUpRoutes(args.routes)
        authorLinkAdminController.setUpRoutes(args.routes)
        categoryAdminController.setUpRoutes(args.routes)
        postAdminController.setUpRoutes(args.routes)
        
        args.routes.get(Blog.pathKey.pathComponent) { req -> Response in
            let template = AdminModulePageTemplate(.init(title: "Blog",
                                                         tag: BlogAdminWidgetTemplate().render(req)))
            return req.templates.renderHtml(template)
        }
    }
    
    func apiRoutesHook(args: HookArguments) {
        authorApiController.setUpRoutes(args.routes)
        authorLinkApiController.setUpRoutes(args.routes)
        categoryApiController.setUpRoutes(args.routes)
        postApiController.setUpRoutes(args.routes)
    }
}
