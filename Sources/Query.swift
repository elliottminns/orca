import Foundation

let databaseQueue = dispatch_queue_create("com.orca.queue",
                                          DISPATCH_QUEUE_SERIAL)

public struct Query<T: Model> {

    public typealias SingleHandler = (model: T?, error: ErrorType?) -> ()
    public typealias SaveHandler = (identifier: String?,
         error: ErrorType?) -> ()

    let database: Orca
    let collection: String
    let filters: [Filter]

    init(database: Orca) {
        self.database = database
        collection = T.collection
        filters = []
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
                                              filters: self.filters)
                
                let model = try T(serialized: data)
                
                handler(model: model, error: nil)
                
            } catch {
                handler(model: nil, error: error)
            }
        }
    }

    public func find(id: String, handler: SingleHandler) {
		filter("identifier", id).first(handler)
	}

    func save(model: T, handler: SaveHandler) {

        dispatch_async(databaseQueue) {

            if model.identifier == nil {
                model.identifier =
                    self.database.driver.generateUniqueIdentifier()
            }

            let data = model.serialize()

            let err: ErrorType?
            
            do {
                try self.database.driver.insert(collection: self.collection,
                    data: data)
                err = nil
            } catch {
                err = error
            }

            dispatch_async(dispatch_get_main_queue()) {
                handler(identifier: model.identifier, error: err)
            }
        }
    }
}

extension Query {

    func filter(key: String, _ value: String) -> Query {

		let filter = CompareFilter(key: key, value: value, comparison: .Equals)

        return Query(database: database, filters: self.filters + [filter])
	}

}
