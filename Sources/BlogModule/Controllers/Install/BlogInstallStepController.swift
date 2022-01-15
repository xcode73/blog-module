//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

struct BlogInstallStepController: SystemInstallStepController {

    private func render(_ req: Request, form: AbstractForm) -> Response {
        let template = BlogInstallStepTemplate(.init(form: form.context(req)))
        return req.templates.renderHtml(template)
    }

    func installStep(_ req: Request, info: SystemInstallInfo) async throws -> Response {
        let form = BlogInstallForm()
        try await form.load(req: req)
        try await form.read(req: req)
        return render(req, form: form)
    }

    func performInstallStep(_ req: Request, info: SystemInstallInfo) async throws -> Response? {
        let form = BlogInstallForm()
        try await form.load(req: req)
        try await form.process(req: req)
        let isValid = try await form.validate(req: req)
        guard isValid else {
            return render(req, form: form)
        }
        try await form.write(req: req)
        
        if form.sample {
            try await installSampleContent(req)
        }
        try await continueInstall(req, with: info.nextStep)
        return req.redirect(to: installPath(req, for: info.nextStep))
    }

    func installSampleContent(_ req: Request) async throws {
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

        let link1 = BlogAuthorLinkModel(label: "Wikipedia", url: "https://en.wikipedia.org/wiki/Dodo", authorId: author1.uuid)
        let link2 = BlogAuthorLinkModel(label: "Mauritius", url: "https://en.wikipedia.org/wiki/Mauritius", authorId: author1.uuid)

        let author2 = BlogAuthorModel(id: UUID(),
                                      name: "Duck",
                                      imageKey: "blog/authors/duck.jpg",
                                      bio: "Ducks are mostly aquatic birds, mostly smaller than the swans and geese, and may be found in both fresh water and sea water.")

        let link3 = BlogAuthorLinkModel(label: "Quack", url: "https://en.wikipedia.org/wiki/Duck", authorId: author2.uuid)

        let author3 = BlogAuthorModel(id: UUID(),
                                      name: "Peacock",
                                      imageKey: "blog/authors/peacock.jpg",
                                      bio: "Male peafowl are referred to as peacocks, and female peafowl are referred to as peahens")

        let link4 = BlogAuthorLinkModel(label: "Peafowl", url: "https://en.wikipedia.org/wiki/Peafowl", authorId: author3.uuid)

        let authors = [author1, author2, author3]
        let links = [link1, link2, link3, link4]

        /// we will use some sample posts

        let post1 = BlogPostModel(id: UUID(),
                                  title: "Binary Birds",
                                  imageKey: "blog/posts/birds.jpg",
                                  excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                                  content: sampleContent())

        let post2 = BlogPostModel(id: UUID(),
                                  title: "Feather API",
                                  imageKey: "blog/posts/api.jpg",
                                  excerpt: "This post is a showcase about the available content blocks.",
                                  content: sampleContent())

        let post3 = BlogPostModel(id: UUID(),
                                  title: "Bring your own theme",
                                  imageKey: "blog/posts/theme.jpg",
                                  excerpt: "You can build your own themes using HTML & CSS and Tau.",
                                  content: sampleContent())

        let post4 = BlogPostModel(id: UUID(),
                                  title: "Shortcodes and filters",
                                  imageKey: "blog/posts/filters.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post5 = BlogPostModel(id: UUID(),
                                  title: "Content and metadata",
                                  imageKey: "blog/posts/content.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post6 = BlogPostModel(id: UUID(),
                                  title: "Static pages",
                                  imageKey: "blog/posts/pages.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post7 = BlogPostModel(id: UUID(),
                                  title: "Writing blog posts",
                                  imageKey: "blog/posts/editor.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post8 = BlogPostModel(id: UUID(),
                                  title: "Branding your site",
                                  imageKey: "blog/posts/site.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post9 = BlogPostModel(id: UUID(),
                                  title: "A quick tour",
                                  imageKey: "blog/posts/tour.jpg",
                                  excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                                  content: sampleContent())

        let post10 = BlogPostModel(id: UUID(),
                                   title: "Welcome to Feather",
                                   imageKey: "blog/posts/welcome.jpg",
                                   excerpt: "Feather is an open source content management system. It is blazing fast with an easy-to-use admin interface where you can customise almost everything.",
                                   content: sampleContent())

        let posts = [post1, post2, post3, post4, post5, post6, post7, post8, post9, post10]

        let postAuthors = [
            BlogPostAuthorModel(postId: post1.uuid, authorId: author1.uuid),
            BlogPostAuthorModel(postId: post1.uuid, authorId: author2.uuid),
            BlogPostAuthorModel(postId: post2.uuid, authorId: author3.uuid),
        ]

        let postCategories = [
            BlogPostCategoryModel(postId: post1.uuid, categoryId: category1.uuid),
            BlogPostCategoryModel(postId: post1.uuid, categoryId: category2.uuid),
            BlogPostCategoryModel(postId: post2.uuid, categoryId: category2.uuid),
        ]
        
        try await categories.create(on: req.db)
        try await categories.forEachAsync { try await $0.publishMetadata(req) }
        
        try await authors.create(on: req.db)
        try await authors.forEachAsync { try await $0.publishMetadata(req) }
        try await links.create(on: req.db)
        
        try await posts.create(on: req.db)
        try await posts.forEachAsync { try await $0.publishMetadata(req) }

        try await postAuthors.create(on: req.db)
        try await postCategories.create(on: req.db)
    }
    
    private func sampleContent() -> String {
        """
        Lorem ipsum dolor sit amet
        """
    }
}
