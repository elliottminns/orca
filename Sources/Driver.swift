public enum DriverError: ErrorType {
    case NoIdentifier
    case NotFound
}

public protocol Driver {

    func generateUniqueIdentifier() -> String

    func findOne(collection collection: String,
        filters: [Filter]) throws -> [String: DataType]

    func update(collection collection: String, filters: [Filter],
        data: [String: DataType]) throws

    func insert(collection collection: String,
        data: [String: DataType]) throws

    func delete(collection collection: String, filters: [Filter]) throws
}
