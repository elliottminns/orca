import Foundation
import Echo

let databaseQueue = dispatch_queue_create("com.orca.queue",
                                          DISPATCH_QUEUE_SERIAL)

public class Query<T: Model> {

    public typealias Handler = (error: ErrorType?) -> ()
    public typealias SingleHandler = (model: T?, error: ErrorType?) -> ()
    public typealias MultipleHandler = (models: [T], error: ErrorType?) -> ()
    public typealias SaveHandler = (identifier: String?,
         error: ErrorType?) -> ()

    let database: Orca
    let collection: String
    var filters: [Filter]

    convenience init(database: Orca) {
        self.init(database: database, filters: [])
    }

    init(database: Orca, filters: [Filter]) {
        self.database = database
        collection = T.collection
        self.filters = filters
    }

    public func first(handler: SingleHandler) {

        dispatch_async(databaseQueue) {
            do {

                let driver = self.database.driver

                let data = try driver.findOne(collection: self.collection,
                                              filters: self.filters,
                                              schema: T.fullSchema())

                let model = T(serialized: data)

                dispatch_async(dispatch_get_main_queue(), {
                    handler(model: model, error: nil)
                })

            } catch {

                dispatch_async(dispatch_get_main_queue(), {
                    handler(model: nil, error: error)
                })
            }
        }
    }

    public func find(id: String, handler: SingleHandler) {
		filter("identifier", id).first(handler)
	}

    public func find(model: T.Type, handler: MultipleHandler) {
        dispatch_async(databaseQueue) {

            let err: ErrorType?
            var models: [T] = []
            do {

                let driver = self.database.driver

                let dataModels = try driver.find(collection: self.collection,
                                                 filters: self.filters,
                                                 schema: T.fullSchema())

                for data in dataModels {
                    if let model = T(serialized: data) {
                        models.append(model)
                    }
                }
                err = nil
            } catch {
                err = error
            }

            dispatch_async(dispatch_get_main_queue()) {
                handler(models: models, error: err)
            }
        }
    }

    func save(model: T, handler: SingleHandler) {
        if model.identifier == nil {
            insert(model, handler: handler)
        } else {
            update(model, handler: handler)
        }

    }

    func insert(model: T, handler: SingleHandler) {

        dispatch_async(databaseQueue) {

            if model.identifier == nil {
                model.identifier =
                    self.database.driver.generateUniqueIdentifier()


                let data = model.serialize()

                let err: ErrorType?

                do {
                    try self.database.driver.insert(collection: self.collection,
                                                    data: data, model: model)
                    err = nil
                } catch {
                    err = error
                }

                dispatch_async(dispatch_get_main_queue()) {
                    handler(model: model, error: err)
                }
            }

        }
    }

    func update(model: T, handler: SingleHandler) {

        guard let identifier = model.identifier else {
            handler(model: model, error: DriverError.NoIdentifier)
            return
        }

        dispatch_async(databaseQueue) {

            let data = model.serialize()

            let err: ErrorType?

            do {
                let compare = CompareFilter(key: "identifier",
                    value: identifier, comparison: .Equals)
                self.filters.append(compare)

                try self.database.driver.update(collection: self.collection,
                                                filters: self.filters,
                                                data: data,
                                                schema: T.fullSchema())

                err = nil
            } catch {
                err = error
            }

            dispatch_async(dispatch_get_main_queue()) {
                handler(model: model, error: err)
            }
        }
    }

    func delete(model: T, handler: Handler) {
        dispatch_async(databaseQueue) {

            let err: ErrorType?

            do {
                try self.database.driver.delete(collection: self.collection,
                                                filters: self.filters,
                                                schema: T.fullSchema())
                err = nil
            } catch {
                err = error
            }

            handler(error: err)

        }
    }
}

extension Query {

    func filter(key: String, _ value: String) -> Query {

		let filter = CompareFilter(key: key, value: value, comparison: .Equals)
        self.filters.append(filter)
        return Query(database: self.database, filters: self.filters)
	}

}
