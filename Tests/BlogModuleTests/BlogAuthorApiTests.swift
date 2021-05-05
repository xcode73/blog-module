//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
import BlogApi
@testable import BlogModule

extension AuthorGetObject: UUIDContent {}

final class BlogAuthorApiTests: FeatherApiTestCase {
    
    override class func testModules() -> [FeatherModule] {
        [BlogModule()]
    }

    override func modelName() -> String {
        "Author"
    }
    
    override func endpoint() -> String {
        "blog/authors"
    }
    
    func testListAuthors() throws {
        try list(AuthorListObject.self)
    }
    
    func testCreateAuthor() throws {
        let uuid = UUID().uuidString
        let input = AuthorCreateObject(name: "name" + uuid)
        try create(input, AuthorGetObject.self) { item in
            XCTAssertEqual(item.name, "name" + uuid)
        }
    }
    
    func testCreateInvalidAuthor() throws {
        let input = AuthorCreateObject(name: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "name")
            XCTAssertEqual(error.details[0].message, "Name is required")
        }
    }
    
    func testUpdateAuthor() throws {
        let uuid = UUID().uuidString
        let input = AuthorCreateObject(name: "name" + uuid)
        let uuid2 = UUID().uuidString
        let up = AuthorCreateObject(name: "name2" + uuid2)
        try update(input, up, AuthorGetObject.self) { item in
            XCTAssertEqual(item.name, "name2" + uuid2)
        }
    }
    
    func testPatchAuthor() throws {
        let uuid = UUID().uuidString
        let input = AuthorCreateObject(name: "name" + uuid)
        let uuid2 = UUID().uuidString
        let up = AuthorCreateObject(name: "name2" + uuid2)

        try patch(input, up, AuthorGetObject.self) { item in
            XCTAssertEqual(item.name, "name2" + uuid2)
        }
    }
    
    func testUniqueKeyFailure() throws {
        
//        let uuid = UUID().uuidString
//        let input = AuthorCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
//        try create(input, AuthorGetObject.self) { item in
//            /// ok
//        }
//
//        try createInvalid(input) { error in
//            XCTAssertEqual(error.details.count, 1)
//            XCTAssertEqual(error.details[0].key, "key")
//            XCTAssertEqual(error.details[0].message, "Key must be unique")
//        }
    }

    func testDeleteAuthor() throws {
        let uuid = UUID().uuidString
        let input = AuthorCreateObject(name: "name" + uuid)
        try delete(input, AuthorGetObject.self)
    }
    
    func testMissingDeleteAuthor() throws {
        try deleteMissing()
    }
}

