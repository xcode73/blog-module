//
//  BlogModuleTests.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 08. 23..
//

import XCTest
import XCTVapor
import Spec
import FeatherCore

import FluentSQLiteDriver
import LiquidLocalDriver

import SystemModule
import UserModule
import ApiModule
import AdminModule
import FrontendModule

@testable import BlogModule

final class BlogModuleTests: XCTestCase {

//    private func configFeather() throws -> Feather {
//        let baseUrl = #file.split(separator: "/").dropLast().joined(separator: "/")
//        print(baseUrl)
//        
//        let feather = try Feather(env: .testing)
//        try feather.configure(database: .sqlite(.memory),
//                              databaseId: .sqlite,
//                              fileStorage: .local(publicUrl: Application.baseUrl, publicPath: baseUrl, workDirectory: "assets"),
//                              fileStorageId: .local,
//                              modules: [
//                                UserBuilder(),
//                                SystemBuilder(),
//                                AdminBuilder(),
//                                FrontendBuilder(),
//                                ApiBuilder(),
//                                BlogBuilder(),
//                              ])
//
//        try feather.app.describe("System install must succeed")
//            .get("/system/install/")
//            .expect(.ok)
//            .expect(.html)
//            .test(.inMemory)
//        
//        return feather
//    }

    func testBlogPostList() throws {
//        let feather = try configFeather()
//        defer { feather.stop() }
//
//        try feather.app.describe("Welcome page must present after install")
//            .get("/api/blog/posts/")
//            .expect(.ok)
//            .expect(.json)
//            .expect { value in
//                print(value.body.string)
////                XCTAssertTrue(value.body.string.contains("Welcome"))
//            }
//            .test(.inMemory)
    }

    func testBlogPostList2() {
//        try app
//            .describe("Blog API should return posts")
//            .get("/api/blog/")
//            .header("accept", "application/json")
//            .body(userBody)
//            .expect(.ok)
//            .expect(.json)
//            .expect("content-length", ["81"])
//            .expect(UserTokenResponse.self) { content in
//                token = content.value
//            }
//            .test(.inMemory)
    }

}
