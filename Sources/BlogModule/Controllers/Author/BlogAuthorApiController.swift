//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 11..
//

import FeatherCore
import BlogModuleApi

struct BlogAuthorApiController: ApiContentController {
    typealias Model = BlogAuthorModel

    func get(_ req: Request) throws -> EventLoopFuture<BlogAuthorGetObject> {
        accessGet(req: req).throwingFlatMap { hasAccess in
            guard hasAccess else {
                return req.eventLoop.future(error: Abort(.forbidden))
            }
            guard
                let rawValue = req.parameters.get(idParamKey),
                let id = UUID(uuidString: rawValue)
            else {
                return req.eventLoop.future(error: Abort(.badRequest))
            }
            return Model.query(on: req.db)
                .filter(\.$id == id)
                .with(\.$links).first()
                .unwrap(or: Abort(.notFound))
                .map(\.getContent)
        }
    }
}
