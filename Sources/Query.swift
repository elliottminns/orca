import Foundation
import Echo

public class Query<T: Model> {

    public typealias Handler = (error: ErrorProtocol?) -> ()
    public typealias SingleHandler = (model: T?, error: ErrorProtocol?) -> ()
    public typealias MultipleHandler = (models: [T], error: ErrorProtocol?) -> ()
    public typealias SaveHandler = (identifier: String?,
         error: ErrorProtocol?) -> ()

    let database: Database
    let collection: String
    var filters: [Filter]

    convenience init(database: Database) {
        self.init(database: database, filters: [])
    }

    init(database: Database, filters: [Filter]) {
        self.database = database
        collection = T.collection
        self.filters = filters
    }

    public func first(_ handler: SingleHandler) {
        do {

            let driver = self.database.driver

            let data = try driver.findOne(collection: self.collection,
                                            filters: self.filters,
                                            schema: T.fullSchema())

            let model = T(serialized: data)

            handler(model: model, error: nil)

        } catch {
             handler(model: nil, error: error)
         }
    }

    public func find(_ id: String, handler: SingleHandler) {
		filter("identifier", id).first(handler)
	}

    public func find(_ model: T.Type, handler: MultipleHandler) {
        let err: ErrorProtocol?
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

        handler(models: models, error: err)
    }

    func save(_ model: T, handler: SingleHandler) {
        if model.identifier == nil {
            insert(model: model, handler: handler)
        } else {
            update(model: model, handler: handler)
        }

    }

    func insert(model: T, handler: SingleHandler) {

        if model.identifier == nil {
            model.identifier = self.database.driver.generateUniqueIdentifier()


            let data = model.serialize()

            let err: ErrorProtocol?

            do {
                 try self.database.driver.insert(collection: self.collection,
                                                    data: data, model: model)
                err = nil
            } catch {
                err = error
            }

            handler(model: model, error: err)
        }
    }

    func update(model: T, handler: SingleHandler) {

        guard let identifier = model.identifier else {
            handler(model: model, error: DriverError.NoIdentifier)
            return
        }

        let data = model.serialize()

        let err: ErrorProtocol?

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

        handler(model: model, error: err)
    }

    func delete(_ model: T, handler: Handler) {
            let err: ErrorProtocol?

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

extension Query {

    func filter(_ key: String, _ value: String) -> Query {

		let filter = CompareFilter(key: key, value: value, comparison: .Equals)
        self.filters.append(filter)
        return Query(database: self.database, filters: self.filters)
	}

}
