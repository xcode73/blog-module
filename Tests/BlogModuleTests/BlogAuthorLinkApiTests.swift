//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
import BlogApi
@testable import BlogModule

extension AuthorLinkGetObject: UUIDContent {}

final class FrontendAuthorLinkApiTests: FeatherApiTestCase {

    override class func testModules() -> [FeatherModule] {
        [BlogModule()]
    }
    
    override func modelName() -> String {
        "Author link"
    }
    
    override func endpoint() -> String {
        "blog/authors"
    }
    
    func testCreateAuthorLink() throws {
        let uuid = UUID().uuidString
        let input = AuthorCreateObject(name: "testKey" + uuid)
        try authenticate()

        var author: AuthorGetObject!

        try app.describe("Author creation should succeed")
            .post("/api/admin/" + "blog/authors" + "/")
            .body(input)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(AuthorGetObject.self) { item in
                XCTAssertEqual(item.name, "testKey" + uuid)
                author = item
            }
            .test(.inMemory)
        
        let input2 = AuthorLinkCreateObject(label: "test label", url: "test url", authorId: author.id)
        try app.describe(modelName() + " creation should succeed")
            .post("/api/admin/" + "blog/authors" + "/" + author.id.uuidString + "/links/")
            .body(input2)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(AuthorLinkGetObject.self) { item in
                XCTAssertEqual(item.label, "test label")
                XCTAssertEqual(item.url, "test url")
                XCTAssertEqual(item.authorId, author.id)
            }
            .test(.inMemory)
        
        try app.describe("Author get should succeed")
            .get("/api/admin/" + "blog/authors" + "/" + author.id.uuidString + "/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(AuthorGetObject.self) { item in
                XCTAssertNotNil(item.links)
                XCTAssertEqual(item.links!.count, 1)
            }
            .test(.inMemory)
        
        try app.describe("Author link list should succeed")
            .get("/api/admin/" + "blog/authors" + "/" + author.id.uuidString + "/links/")
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(PaginationContainer<AuthorLinkListObject>.self) { items in
                XCTAssertEqual(items.info.total, 1)
            }
            .test(.inMemory)
    }
    
}

