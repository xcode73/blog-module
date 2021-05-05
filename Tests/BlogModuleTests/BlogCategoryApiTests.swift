//
//  BlogModuleTests.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import FeatherTest
import BlogApi
@testable import BlogModule

extension CategoryGetObject: UUIDContent {}

final class BlogCategoryApiTests: FeatherApiTestCase {
    
    override class func testModules() -> [FeatherModule] {
        [BlogModule()]
    }

    override func modelName() -> String {
        "Category"
    }
    
    override func endpoint() -> String {
        "blog/categories"
    }
    
    func testListCategorys() throws {
        try list(CategoryListObject.self)
    }
    
    func testCreateCategory() throws {
        let uuid = UUID().uuidString
        let input = CategoryCreateObject(title: "title" + uuid)
        try create(input, CategoryGetObject.self) { item in
            XCTAssertEqual(item.title, "title" + uuid)
        }
    }
    
    func testCreateInvalidCategory() throws {
        let input = CategoryCreateObject(title: "")
        try createInvalid(input) { error in
            XCTAssertEqual(error.details.count, 1)
            XCTAssertEqual(error.details[0].key, "title")
            XCTAssertEqual(error.details[0].message, "Title is required")
        }
    }
    
    func testUpdateCategory() throws {
        let uuid = UUID().uuidString
        let input = CategoryCreateObject(title: "title" + uuid)
        let uuid2 = UUID().uuidString
        let up = CategoryCreateObject(title: "title2" + uuid2)
        try update(input, up, CategoryGetObject.self) { item in
            XCTAssertEqual(item.title, "title2" + uuid2)
        }
    }
    
    func testPatchCategory() throws {
        let uuid = UUID().uuidString
        let input = CategoryCreateObject(title: "title" + uuid)
        let uuid2 = UUID().uuidString
        let up = CategoryCreateObject(title: "title2" + uuid2)

        try patch(input, up, CategoryGetObject.self) { item in
            XCTAssertEqual(item.title, "title2" + uuid2)
        }
    }
    
    func testUniqueKeyFailure() throws {
        
//        let uuid = UUID().uuidString
//        let input = CategoryCreateObject(key: "testUpdateKey" + uuid, name: "testUpdateName", notes: "testUpdateNotes")
//        try create(input, CategoryGetObject.self) { item in
//            /// ok
//        }
//
//        try createInvalid(input) { error in
//            XCTAssertEqual(error.details.count, 1)
//            XCTAssertEqual(error.details[0].key, "key")
//            XCTAssertEqual(error.details[0].message, "Key must be unique")
//        }
    }

    func testDeleteCategory() throws {
        let uuid = UUID().uuidString
        let input = CategoryCreateObject(title: "title" + uuid)
        try delete(input, CategoryGetObject.self)
    }
    
    func testMissingDeleteCategory() throws {
        try deleteMissing()
    }
}

