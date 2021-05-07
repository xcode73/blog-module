//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 07..
//

import FeatherCore

final class BlogInstallForm: Form {

    var sample: Bool = true

    init() {
        super.init()

        submit = "Setup blog"
        action.url = "/install/blog/?next=true"
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            ToggleField(key: "sample")
                .config { [unowned self] in
                    $0.output.label = "Install sample content"
                    $0.output.value = sample
                }
                .read { [unowned self] in $1.output.value = sample }
                .write { [unowned self] in sample = $1.input },
        ]
    }

    override func save(req: Request) -> EventLoopFuture<Void> {
        super.save(req: req).flatMap { [unowned self] in
            if sample {
                return installSample(req)
            }
            return req.eventLoop.future()
        }
    }
    
    private func installSample(_ req: Request) -> EventLoopFuture<Void> {
        let category1 = BlogCategoryModel(id: UUID(),
                          title: "Getting started",
                          imageKey: "blog/categories/getting-started.jpg",
                          excerpt: "Learn how to use Feather, get started with your site",
                          color: "orange")

        let category2 = BlogCategoryModel(id: UUID(),
                          title: "Feather",
                          imageKey: "blog/categories/feather.jpg",
                          excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                          color: "#21a9ff")

        let categories = [category1, category2]

        /// we also need a fixed author id & a sample author
        let author1 = BlogAuthorModel(id: UUID(),
                                      name: "Dodo",
                                      imageKey: "blog/authors/dodo.jpg",
                                      bio: "The dodo is an extinct flightless bird that was endemic to the island of Mauritius")

        let link1 = BlogAuthorLinkModel(label: "Wikipedia", url: "https://en.wikipedia.org/wiki/Dodo", authorId: author1.id!)
        let link2 = BlogAuthorLinkModel(label: "Mauritius", url: "https://en.wikipedia.org/wiki/Mauritius", authorId: author1.id!)

        let author2 = BlogAuthorModel(id: UUID(),
                                      name: "Duck",
                                      imageKey: "blog/authors/duck.jpg",
                                      bio: "Ducks are mostly aquatic birds, mostly smaller than the swans and geese, and may be found in both fresh water and sea water.")

        let link3 = BlogAuthorLinkModel(label: "Quack", url: "https://en.wikipedia.org/wiki/Duck", authorId: author2.id!)

        let author3 = BlogAuthorModel(id: UUID(),
                                      name: "Peacock",
                                      imageKey: "blog/authors/peacock.jpg",
                                      bio: "Male peafowl are referred to as peacocks, and female peafowl are referred to as peahens")

        let link4 = BlogAuthorLinkModel(label: "Peafowl", url: "https://en.wikipedia.org/wiki/Peafowl", authorId: author3.id!)

        let authors = [author1, author2, author3]
        let links = [link1, link2, link3, link4]

        /// we will use some sample posts

        let post1 = BlogPostModel(id: UUID(),
                                  title: "Binary Birds",
                                  imageKey: "blog/posts/0ff020a2-3977-484d-b636-11348a67b4f7.jpg",
                                  excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post2 = BlogPostModel(id: UUID(),
                                  title: "Feather API",
                                  imageKey: "blog/posts/010d620f-424c-4a3a-ac6b-f635486052de.jpg",
                                  excerpt: "This post is a showcase about the available content blocks.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post3 = BlogPostModel(id: UUID(),
                                  title: "Bring your own theme",
                                  imageKey: "blog/posts/30ca164c-a9e5-40f8-9daa-ffcb4c7ffea8.jpg",
                                  excerpt: "You can build your own themes using HTML & CSS and Tau.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post4 = BlogPostModel(id: UUID(),
                                  title: "Shortcodes and filters",
                                  imageKey: "blog/posts/87da5c18-5013-4672-bd52-487734550723.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post5 = BlogPostModel(id: UUID(),
                                  title: "Content and metadata",
                                  imageKey: "blog/posts/636c4b1a-b280-4da3-9e7a-24538858df4a.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post6 = BlogPostModel(id: UUID(),
                                  title: "Static pages",
                                  imageKey: "blog/posts/1878d3af-d41a-4177-88d5-6689117cf917.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post7 = BlogPostModel(id: UUID(),
                                  title: "Writing blog posts",
                                  imageKey: "blog/posts/2045c4eb-cf11-4242-beda-7902b325a564.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post8 = BlogPostModel(id: UUID(),
                                  title: "Branding your site",
                                  imageKey: "blog/posts/60676325-ce03-495d-a098-0780c59a4e3a.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post9 = BlogPostModel(id: UUID(),
                                  title: "A quick tour",
                                  imageKey: "blog/posts/e44dd240-b702-47d8-8be3-fac2265d128a.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: BlogModule.sample(named: "Lorem.html"))

        let post10 = BlogPostModel(id: UUID(),
                                   title: "Welcome to Feather",
                                   imageKey: "blog/posts/eb03ed0a-c5e1-48ae-8f9f-f3ac482e5fa4.jpg",
                                   excerpt: "Feather is an open source content management system. It is blazing fast with an easy-to-use admin interface where you can customise almost everything.",
                                   content: BlogModule.sample(named: "Lorem.html"))

        let posts = [post1, post2, post3, post4, post5, post6, post7, post8, post9, post10]

        let postAuthors = [
            BlogPostAuthorModel(postId: post1.id!, authorId: author1.id!),
            BlogPostAuthorModel(postId: post1.id!, authorId: author2.id!),
            BlogPostAuthorModel(postId: post2.id!, authorId: author3.id!),
        ]

        let postCategories = [
            BlogPostCategoryModel(postId: post1.id!, categoryId: category1.id!),
            BlogPostCategoryModel(postId: post1.id!, categoryId: category2.id!),
            BlogPostCategoryModel(postId: post2.id!, categoryId: category2.id!),
        ]

        let postItems: [[[String: Any]]] = req.invokeAll("blog-post-install")
        let blogPostModels = postItems.flatMap { $0 }.compactMap { dict -> BlogPostModel? in
            guard
                let title = dict["title"] as? String, !title.isEmpty
            else {
                return nil
            }
            let imageKey = dict["imageKey"] as? String
            let excerpt = dict["excerpt"] as? String
            let content = dict["content"] as? String
            return BlogPostModel(id: UUID(), title: title, imageKey: imageKey, excerpt: excerpt, content: content)
        }

        return req.eventLoop.flatten([
            /// first create and publish categories, authors and posts and publish associated metadata objects...
            categories.create(on: req.db).flatMap {
                req.eventLoop.flatten(categories.map { $0.publishMetadata(on: req.db) })
            },
            authors.create(on: req.db).flatMap {
                req.eventLoop.flatten(authors.map { $0.publishMetadata(on: req.db) })
            }
            .flatMap { links.create(on: req.db) },

            (posts + blogPostModels).create(on: req.db).flatMap { _ in
                req.eventLoop.flatten(posts.map { $0.publishMetadata(on: req.db) })
            },
            postAuthors.create(on: req.db),
            postCategories.create(on: req.db),
        ])
    }
}
