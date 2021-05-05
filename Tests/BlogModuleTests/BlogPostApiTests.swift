//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 05..
//

import FeatherTest
import BlogApi
@testable import BlogModule

extension PostGetObject: UUIDContent {}

final class BlogPostApiTests: FeatherApiTestCase {
    
    override class func testModules() -> [FeatherModule] {
        [BlogModule()]
    }

    override func modelName() -> String {
        "Post"
    }
    
    override func endpoint() -> String {
        "blog/posts"
    }
    
    func testListPosts() throws {
        try list(PostListObject.self)
    }
    
    func testCreatePost() throws {
        let uuid = UUID().uuidString
        let input = PostCreateObject(title: "title" + uuid)
        try create(input, PostGetObject.self) { item in
            XCTAssertEqual(item.title, "title" + uuid)
        }
    }
    
    func testCreateInvalidPost() throws {
        let input = PostCreateObject(title: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "title")
            XCTAssertEqual(error.details[0].message, "Title is required")
        }
    }
    
    func testUpdatePost() throws {
        let uuid = UUID().uuidString
        let input = PostCreateObject(title: "title" + uuid)
        let uuid2 = UUID().uuidString
        let up = PostCreateObject(title: "title2" + uuid2)
        try update(input, up, PostGetObject.self) { item in
            XCTAssertEqual(item.title, "title2" + uuid2)
        }
    }
    
    func testPatchPost() throws {
        let uuid = UUID().uuidString
        let input = PostCreateObject(title: "title" + uuid)
        let uuid2 = UUID().uuidString
        let up = PostCreateObject(title: "title2" + uuid2)

        try patch(input, up, PostGetObject.self) { item in
            XCTAssertEqual(item.title, "title2" + uuid2)
        }
    }
    
    func testUniqueKeyFailure() throws {
        
//        let uuid = UUID().uuidString
//        let input = PostCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
//        try create(input, PostGetObject.self) { item in
//            /// ok
//        }
//
//        try createInvalid(input) { error in
//            XCTAssertEqual(error.details.count, 1)
//            XCTAssertEqual(error.details[0].key, "key")
//            XCTAssertEqual(error.details[0].message, "Key must be unique")
//        }
    }

    func testDeletePost() throws {
        let uuid = UUID().uuidString
        let input = PostCreateObject(title: "title" + uuid)
        try delete(input, PostGetObject.self)
    }
    
    func testMissingDeletePost() throws {
        try deleteMissing()
    }
}

