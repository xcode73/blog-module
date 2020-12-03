//
//  BlogPostAdminController.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Fluent
import FeatherCore

struct BlogPostAdminController: ViperAdminViewController {
    typealias Module = BlogModule
    typealias Model = BlogPostModel
    typealias EditForm = BlogPostEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.title,
        "date"
    ]
    
    func searchList(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$title ~~ searchTerm)
    }

    private func path(_ model: Model) -> String {
        Model.path + model.id!.uuidString + ".jpg"
    }
    
    func beforeList(req: Request, queryBuilder qb: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        qb.join(FrontendMetadata.self, on: \FrontendMetadata.$reference == \Model.$id, method: .inner)
    }

    func beforeList(req: Request, order: FieldKey, sort: Sort, queryBuilder qb: QueryBuilder<Model>) -> QueryBuilder<Model> {
        if order == "date" {
            return qb.sort(FrontendMetadata.self, \.$date, sort.direction)
        }
        return qb.sort(order, sort.direction)
    }

    func beforeListRender(page: ViewKit.Page<Model>) -> LeafData {
        .dictionary([
            "items": .array(page.items.map(\.leafDataWithMetadata)),
            "info": page.info.leafData
        ])
    }

    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        var future: EventLoopFuture<Void> = req.eventLoop.future()
        if let id = form.modelId, let uuid = UUID(uuidString: id) {
            future = findMetadata(on: req.db, uuid: uuid).map { form.metadata = $0 }
        }

        return req.eventLoop.flatten([
            BlogCategoryModel.query(on: req.db).all().mapEach(\.formFieldStringOption).map { form.categoryId.options = $0 },
            BlogAuthorModel.query(on: req.db).all().mapEach(\.formFieldStringOption).map { form.authorId.options = $0 },
            future,
        ])
    }
 
    func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        model.id = UUID()
        var future: EventLoopFuture<Model> = req.eventLoop.future(model)
        if let data = form.image.data {
            let key = path(model)
            future = req.fs.upload(key: key, data: data).map { url in
                //form.image.value = url
                model.imageKey = key
                return model
            }
        }
        return future
    }
    
    func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
        let key = path(model)
        var future: EventLoopFuture<Model> = req.eventLoop.future(model)
        if
            (form.image.delete || form.image.data != nil),
            FileManager.default.fileExists(atPath: req.fs.resolve(key: key))
        {
            future = req.fs.delete(key: key).map { model }
        }
        if let data = form.image.data {
            return future.flatMap { model in
                return req.fs.upload(key: key, data: data).map { url in
                    //form.image.value = url
                    model.imageKey = key
                    return model
                }
            }
        }
        return future
    }

    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        req.fs.delete(key: path(model)).map { model }
    }

}
