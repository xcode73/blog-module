//
//  BlogRouter.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

struct BlogRouter: ViperRouter {

    let authorAdmin = BlogAuthorAdminController()
    let authorApi = BlogAuthorApiController()
    
    let authorLinkAdmin = BlogAuthorLinkAdminController()
    
    let categoryAdmin = BlogCategoryAdminController()
    let categoryApi = BlogCategoryApiController()
    
    let postAdmin = BlogPostAdminController()
    let postApi = BlogPostApiController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(BlogModule.pathComponent)

        postAdmin.setupRoutes(on: modulePath, as: BlogPostModel.pathComponent)
        categoryAdmin.setupRoutes(on: modulePath, as: BlogCategoryModel.pathComponent)

        authorAdmin.setupRoutes(on: modulePath, as: BlogAuthorModel.pathComponent)

        let adminAuthor = modulePath.grouped(BlogAuthorModel.pathComponent, authorAdmin.idPathComponent)
        authorLinkAdmin.setupRoutes(on: adminAuthor, as: "links")
    }

    func publicApiRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder
        
        let modulePath = routes.grouped(BlogModule.pathComponent)

        let postPath = modulePath.grouped(BlogPostModel.pathComponent)
        postApi.setupListRoute(on: postPath)
        postApi.setupGetRoute(on: postPath)

        let categoryPath = modulePath.grouped(BlogCategoryModel.pathComponent)
        categoryApi.setupListRoute(on: categoryPath)
        categoryApi.setupGetRoute(on: categoryPath)
        
        let authorPath = modulePath.grouped(BlogAuthorModel.pathComponent)
        authorApi.setupListRoute(on: authorPath)
        authorApi.setupGetRoute(on: authorPath)
    }
    
    func privateApiRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(BlogModule.pathComponent)
        
        authorApi.setupListRoute(on: routes.grouped("test"))

        let postPath = modulePath.grouped(BlogPostModel.pathComponent)
        postApi.setupCreateRoute(on: postPath)
        postApi.setupUpdateRoute(on: postPath)
        postApi.setupPatchRoute(on: postPath)
        postApi.setupDeleteRoute(on: postPath)
        
        let categoryPath = modulePath.grouped(BlogCategoryModel.pathComponent)
        categoryApi.setupCreateRoute(on: categoryPath)
        categoryApi.setupUpdateRoute(on: categoryPath)
        categoryApi.setupPatchRoute(on: categoryPath)
        categoryApi.setupDeleteRoute(on: categoryPath)
        
        let authorPath = modulePath.grouped(BlogAuthorModel.pathComponent)
        authorApi.setupCreateRoute(on: authorPath)
        authorApi.setupUpdateRoute(on: authorPath)
        authorApi.setupPatchRoute(on: authorPath)
        authorApi.setupDeleteRoute(on: authorPath)
    }
    
}

