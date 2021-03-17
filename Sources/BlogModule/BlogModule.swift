//
//  BlogModule.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Fluent
import FeatherCore

final class BlogModule: ViperModule {

    static let name = "blog"
    var priority: Int { 1100 }

    var router: ViperRouter? = BlogRouter()
    

    var migrations: [Migration] {
        [
            BlogMigration_v1_0_0(),
        ]
    }
  
    static var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// frontend middleware
        app.databases.middleware.use(MetadataModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogAuthorModel>())
        /// install
        app.hooks.register("model-install", use: modelInstallHook)
        app.hooks.register("system-variables-install", use: systemVariablesInstallHook)
        app.hooks.register("user-permission-install", use: userPermissionInstallHook)
        app.hooks.register("frontend-main-menu-install", use: frontendMainMenuInstallHook)
        app.hooks.register("frontend-page-install", use: frontendPageInstallHook)
        /// routes
        app.hooks.register("admin-routes", use: (router as! BlogRouter).adminRoutesHook)
        app.hooks.register("api-routes", use: (router as! BlogRouter).privateApiRoutesHook)
        app.hooks.register("public-api-routes", use: (router as! BlogRouter).publicApiRoutesHook)
        app.hooks.register("frontend-route", use: authorFrontendPageHook)
        app.hooks.register("frontend-route", use: categoryFrontendPageHook)
        app.hooks.register("frontend-route", use: postFrontendPageHook)
        /// template
        app.hooks.register("template-admin-menu", use: templateAdminMenuHook)
        /// css
        app.hooks.register("css", use: cssHook)
        ///page hooks
        app.hooks.register("blog-page", use: homePageHook)
        app.hooks.register("blog-categories-page", use: categoriesPageHook)
        app.hooks.register("blog-authors-page", use: authorsPageHook)
        app.hooks.register("blog-posts-page", use: postsPageHook)
    }

    // MARK: - hooks

    func cssHook(args: HookArguments) -> [[String: Any]] {
        [
            [
                "name": "blog",
            ],
        ]
    }

    func templateAdminMenuHook(args: HookArguments) -> TemplateDataRepresentable {
        [
            "name": "Blog",
            "icon": "book",
            "permission": "blog.module.access",
            "items": TemplateData.array([
                [
                    "url": "/admin/blog/posts/",
                    "label": "Posts",
                    "permission": "blog.posts.list",
                ],
                [
                    "url": "/admin/blog/categories/",
                    "label": "Categories",
                    "permission": "blog.categories.list",
                ],
                [
                    "url": "/admin/blog/authors/",
                    "label": "Authors",
                    "permission": "blog.authors.list",
                ],
            ])
        ]
    }

    // MARK: - frontend page hooks
    
    func authorFrontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return BlogAuthorModel.queryJoinPublicMetadata(path: req.url.path, on: req.db)
            .with(\.$links)
            .first()
            .flatMap { author  in
                guard let author = author else {
                    return req.eventLoop.future(nil)
                }
                return author.$posts.query(on: req.db)
                    .joinPublicMetadata()
                    .with(\.$categories)
                    .all()
                    .flatMap { posts in
                        BlogFrontendView(req).author(author, posts: posts).encodeOptionalResponse(for: req)
                    }
            }
    }
    
    func categoryFrontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return BlogCategoryModel.queryJoinPublicMetadata(path: req.url.path, on: req.db)
            .first()
            .flatMap { category  in
                guard let category = category else {
                    return req.eventLoop.future(nil)
                }
                return category.$posts.query(on: req.db)
                    .joinPublicMetadata()
                    .with(\.$categories)
                    .all()
                    .flatMap { posts in
                        BlogFrontendView(req).category(category, posts: posts).encodeOptionalResponse(for: req)
                    }
            }
    }
    
    func postFrontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return BlogPostModel.queryJoinPublicMetadata(path: req.url.path, on: req.db)
            .with(\.$categories)
            .with(\.$authors) { $0.with(\.$links) }
            .first()
            .flatMap { post  in
                guard let post = post else {
                    return req.eventLoop.future(nil)
                }
                /// render the post with the filtered content
                var ctx = post.templateDataWithJoinedMetadata.dictionary!
                ctx["content"] = .string(post.filter(post.content ?? "", req: req))
                return BlogFrontendView(req).post(ctx.templateData).encodeOptionalResponse(for: req)
            }
    }
    
    // MARK: - page hooks
    
    /// renders the [home-page] content
    func homePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogPostModel
            .home(on: req)
            .flatMap { BlogFrontendView(req).home(posts: $0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }

    /// renders the [categories-page] content
    func categoriesPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogCategoryModel.queryJoinPublicMetadata(on: req.db)
            .all()
            .flatMap { BlogFrontendView(req).categories($0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }

    /// renders the [authors-page] content
    func authorsPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogAuthorModel.findPublished(on: req)
            .flatMap { BlogFrontendView(req).authors($0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }
    
    /// renders the [posts-page] content
    func postsPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        var qb = BlogPostModel.find(on: req)

        let search: String? = req.query["search"]
        let limit: Int = req.query["limit"] ?? 10
        let page: Int = max((req.query["page"] ?? 1), 1)

        if let searchTerm = search, !searchTerm.isEmpty {
            qb = qb.filter(\.$title ~~ searchTerm)
        }

        let start: Int = (page - 1) * limit
        let end: Int = page * limit

        let count = qb.count()
        let items = qb.copy().range(start..<end).all()

        return items.and(count).map { (posts, count) -> ListPage<TemplateData> in
            let total = Int(ceil(Float(count) / Float(limit)))
            return .init(posts.map { $0.templateDataWithJoinedMetadata }, info: .init(current: page, limit: limit, total: total))
        }
        .flatMap { BlogFrontendView(req).posts(page: $0, metadata: metadata) }
        .encodeOptionalResponse(for: req)
    }
}
