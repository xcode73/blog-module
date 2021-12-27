//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 14..
//

@_exported import FeatherCore
@_exported import BlogApi

public extension HookName {
    
    //    static let permission: HookName = "permission"
}

struct BlogModule: FeatherModule {
    
    let router = BlogRouter()
    
    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        app.migrations.add(BlogMigrations.v1())
        
        app.databases.middleware.use(MetadataModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataModelMiddleware<BlogAuthorModel>())
        
        app.hooks.register(.installStep, use: installStepHook)
        app.hooks.register(.installUserPermissions, use: installUserPermissionsHook)
        app.hooks.register(.installCommonVariables, use: installCommonVariablesHook)
        app.hooks.register(.installWebMenuItems, use: installWebMenuItemsHook)
        app.hooks.register(.installWebPages, use: installWebPagesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.adminWidgets, use: adminWidgetsHook)

        app.hooks.registerAsync(.installResponse, use: installResponseHook)
        app.hooks.registerAsync(.response, use: categoryResponseHook)
        app.hooks.registerAsync(.response, use: authorResponseHook)
        app.hooks.registerAsync(.response, use: postResponseHook)
        
        app.hooks.registerAsync("blog-home-page", use: homePageHook)
        app.hooks.registerAsync("blog-posts-page", use: postsPageHook)
        app.hooks.registerAsync("blog-categories-page", use: categoriesPageHook)
        app.hooks.registerAsync("blog-authors-page", use: authorsPageHook)
    }
    
    func adminWidgetsHook(args: HookArguments) -> [TemplateRepresentable] {
        if args.req.checkPermission(Blog.permission(for: .detail)) {
            return [
                BlogAdminWidgetTemplate(),
            ]
        }
        return []
    }
    
    // MARK: - pages
    
    func homePageHook(args: HookArguments) async throws -> Response? {
        let items = try await BlogPostApiController.list(args.req)
        let template = BlogHomePageTemplate(.init(posts: items))
        return args.req.templates.renderHtml(template)
    }
    
    func postsPageHook(args: HookArguments) async throws -> Response? {
        let items = try await BlogPostApiController.list(args.req)
        let template = BlogPostsPageTemplate(.init(posts: items))
        return args.req.templates.renderHtml(template)
    }
    
    func categoriesPageHook(args: HookArguments) async throws -> Response? {
        let items = try await BlogCategoryApiController.list(args.req)
        let template = BlogCategoriesPageTemplate(.init(categories: items))
        return args.req.templates.renderHtml(template)
    }
    
    func authorsPageHook(args: HookArguments) async throws -> Response? {
        let items = try await BlogAuthorApiController.list(args.req)
        let template = BlogAuthorsPageTemplate(.init(authors: items))
        return args.req.templates.renderHtml(template)
    }
    
    // MARK: - responses
    
    func categoryResponseHook(args: HookArguments) async throws -> Response? {
        guard let category = try await BlogCategoryApiController.detailBy(path: args.req.url.path, args.req) else {
            return nil
        }
        let template = BlogCategoryPageTemplate(.init(category: category))
        return args.req.templates.renderHtml(template)
    }
    
    func authorResponseHook(args: HookArguments) async throws -> Response? {
        guard let author = try await BlogAuthorApiController.detailBy(path: args.req.url.path, args.req) else {
            return nil
        }
        let template = BlogAuthorPageTemplate(.init(author: author))
        return args.req.templates.renderHtml(template)
    }
    
    func postResponseHook(args: HookArguments) async throws -> Response? {
        guard let post = try await BlogPostApiController.detailBy(path: args.req.url.path, args.req) else {
            return nil
        }
        let template = BlogPostPageTemplate(.init(post: post))
        return args.req.templates.renderHtml(template)
    }
    
    // MARK: - install
    
    func installStepHook(args: HookArguments) -> [SystemInstallStep] {
        [
            .init(key: Self.featherIdentifier, priority: 100),
        ]
    }
    
    func installResponseHook(args: HookArguments) async throws -> Response? {
        guard args.installInfo.currentStep == Self.featherIdentifier else {
            return nil
        }
        return try await BlogInstallStepController().handleInstallStep(args.req, info: args.installInfo)
    }
    
    func installUserPermissionsHook(args: HookArguments) -> [User.Permission.Create] {
        var permissions = Blog.availablePermissions()
        permissions += Blog.Post.availablePermissions()
        permissions += Blog.Category.availablePermissions()
        permissions += Blog.Author.availablePermissions()
        permissions += Blog.AuthorLink.availablePermissions()
        return permissions.map { .init($0) }
    }
    
    func installCommonVariablesHook(args: HookArguments) -> [Common.Variable.Create] {
        [
            .init(key: "blogHomePageTitle",
                  name: "Blog home page title",
                  value: "Blog",
                  notes: "Title of the blog home page"),
            
            .init(key: "blogHomePageExcerpt",
                  name: "Blog home page excerpt",
                  value: "Latest posts",
                  notes: "Short description of the blog home page"),
            
            .init(key: "blogPostsPageTitle",
                  name: "Blog posts page title",
                  value: "Posts",
                  notes: "Title for the blog posts page"),
            
            .init(key: "blogPostsPageExcerpt",
                  name: "Blog posts page excerpt",
                  value: "Every single post",
                  notes: "Excerpt for the blog posts page"),
        
            .init(key: "blogCategoriesPageTitle",
                  name: "Blog categories page title",
                  value: "Categories",
                  notes: "Title for the blog categories page"),
        
            .init(key: "blogCategoriesPageExcerpt",
                  name: "Blog categories page excerpt",
                  value: "Blog posts by categories",
                  notes: "Excerpt for the blog categories page"),
        
            .init(key: "blogAuthorsPageTitle",
                  name: "Blog authors page title",
                  value: "Authors",
                  notes: "Title for the blog authors page"),
        
            .init(key: "blogAuthorsPageExcerpt",
                  name: "Blog authors page excerpt",
                  value: "Blog posts by authors",
                  notes: "Excerpt for the blog authors page"),
            
            .init(key: "blogPostShareIsEnabled",
                  name: "Is post sharing enabled?",
                  value: "true",
                  notes: "The share box is only displayed if this variable is true"),
            
            .init(key: "blogPostShareLinkPrefix",
                  name: "Share box link prefix",
                  value: "Thanks for reading, if you liked this article please ",
                  notes: "Appears before the share link (prefix[link]suffix)"),
            
            .init(key: "blogPostShareLink",
                  name: "Share box link label",
                  value: "share it on Twitter",
                  notes: "Share link will be placed between the prefix & suffix (prefix[link]suffix)"),
            
            .init(key: "blogPostShareLinkSuffix",
                  name: "Share box link suffix",
                  value: ".",
                  notes: "Appears after the share link (prefix[link]suffix)"),
            
            .init(key: "blogPostShareAuthor",
                  name:  "Share box author Twitter profile",
                  value: "tiborbodecs",
                  notes: "Share author"),
            
            .init(key: "blogPostShareHashtags",
                  name: "Share box hashtags (coma separated)",
                  value: "SwiftLang",
                  notes: "Share hashtasgs"),
            
            .init(key: "blogPostAuthorBoxIsEnabled",
                  name: "Post author is enabled",
                  value: "true",
                  notes: "Display post author box if this variable is true"),

            .init(key: "blogPostFooter",
                  name: "Post footer text",
                  notes: "Display the contents of this value under every post entry"),
        ]
    }
    
    func installWebMenuItemsHook(args: HookArguments) -> [Web.MenuItem.Create] {
        let menuId = args["menuId"] as! UUID
        return [
            .init(label: "Blog", url: "/blog/", priority: 900, menuId: menuId),
            .init(label: "Posts", url: "/posts/", priority: 800, menuId: menuId),
            .init(label: "Categories", url: "/categories/", priority: 700, menuId: menuId),
            .init(label: "Authors", url: "/authors/", priority: 600, menuId: menuId),
        ]
    }
    
    func installWebPagesHook(args: HookArguments) -> [Web.Page.Create] {
        [
            .init(title: "Blog", content: "[blog-home-page]"),
            .init(title: "Posts", content: "[blog-posts-page]"),
            .init(title: "Categories", content: "[blog-categories-page]"),
            .init(title: "Authors", content: "[blog-authors-page]"),
        ]
    }
}
