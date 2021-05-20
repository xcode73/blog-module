//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore

extension BlogModule {
    
    func installPermissionsHook(args: HookArguments) -> [PermissionCreateObject] {
        var permissions: [PermissionCreateObject] = [
            Self.hookInstallPermission(for: .custom("admin"))
        ]
        permissions += BlogAuthorModel.hookInstallPermissions()
        permissions += BlogAuthorLinkModel.hookInstallPermissions()
        permissions += BlogCategoryModel.hookInstallPermissions()
        permissions += BlogPostModel.hookInstallPermissions()
        return permissions
    }
    
    func installVariablesHook(args: HookArguments) -> [VariableCreateObject] {
        [   
            .init(key: "blogHomePageTitle",
                  name: "Blog home page title",
                  value: "Blog",
                  notes: "Title of the blog home page"),
            
            .init(key: "blogHomePageExcerpt",
                  name: "Blog home page excerpt",
                  value: "Latest posts",
                  notes: "Short description of the blog home page"),
            
            .init(key: "blogCategoriesPageTitle",
                  name: "Blog categories page title",
                  value: "Categories",
                  notes: "Title of the blog categories page"),
            
            .init(key: "blogCategoriesPageExcerpt",
                  name: "Blog home page excerpt",
                  value: "Blog posts by categories",
                  notes: "Short description of the categories page"),
            
            .init(key: "blogAuthorsPageTitle",
                  name: "Blog authors page title",
                  value: "Authors",
                  notes: "Title of the blog categories page"),
            
            .init(key: "blogAuthorsPageExcerpt",
                  name: "Blog authors page excerpt",
                  value: "Blog posts by authors",
                  notes: "Short description of the authors page"),
            
            .init(key: "blogPostsPageTitle",
                  name: "Blog posts page title",
                  value: "Posts",
                  notes: "Title of the blog posts page"),
            
            .init(key: "blogPostsPageExcerpt",
                  name: "Blog posts page excerpt",
                  value: "Every single post",
                  notes: "Short description of the posts page"),
            
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

    func installMainMenuItemsHook(args: HookArguments) -> [MenuItemCreateObject] {
        let menuId = args["menuId"] as! UUID
        return [
            .init(label: "Blog", url: "/blog/", priority: 900, menuId: menuId),
            .init(label: "Posts", url: "/posts/", priority: 800, menuId: menuId),
            .init(label: "Categories", url: "/categories/", priority: 700, menuId: menuId),
            .init(label: "Authors", url: "/authors/", priority: 600, menuId: menuId),
        ]
    }
    
    func installPagesHook(args: HookArguments) -> [PageCreateObject] {
        [
            .init(title: "Blog", content: "[blog-home-page]"),
            .init(title: "Posts", content: "[blog-posts-page]"),
            .init(title: "Categories", content: "[blog-categories-page]"),
            .init(title: "Authors", content: "[blog-authors-page]"),
        ]
    }
}
