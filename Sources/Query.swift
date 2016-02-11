
public struct Query<T: Model> {

    public typealias SingleHandler = (model: T?, error: ErrorType?) -> ()

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
		return self.filter("identifier", id).first { (model: T?, error: ErrorType?) in

        }
	}

    func save(model: T, handler: (model: T, error: ErrorType?) -> ()) {

        let _ = model.serialize()

    }
}

extension Query {

    mutating func filter(key: String, _ value: String) -> Query {

		let filter = CompareFilter(key: key, value: value, comparison: .Equals)

		self.filters.append(filter)

		return self
	}

}
