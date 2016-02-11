import Foundation

public struct Query<T: Model> {

    public typealias SingleHandler = (model: T?, error: ErrorType?) -> ()
    public typealias SaveHandler = (identifier: String?,
         error: ErrorType?) -> ()

    let database: Orca
    let collection: String
    var filters = [Filter]()

    init(database: Orca) {
        self.database = database
        collection = T.collection
    }

    public func first(handler: SingleHandler) {

    }

    public mutating func find(id: String, handler: SingleHandler) {
		return self.filter("identifier", id)
            .first { (model: T?, error: ErrorType?) in

        }
	}

    func save(model: T, handler: SaveHandler) {
        let queue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)

        dispatch_async(queue) {

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

    mutating func filter(key: String, _ value: String) -> Query {

		let filter = CompareFilter(key: key, value: value, comparison: .Equals)

		self.filters.append(filter)

		return self
	}

}
