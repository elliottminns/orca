public enum DriverError: ErrorProtocol {
    case NoIdentifier
    case NotFound
    case NotImplemented
}

public protocol Driver {

    func generateUniqueIdentifier() -> String

    func findOne(collection collection: String,
        filters: [Filter], schema: [String: DataType.Type])
        throws -> [String: DataType]

    func find(collection collection: String, filters: [Filter],
        schema: [String: DataType.Type]) throws -> [[String: DataType]]

    func update(collection collection: String, filters: [Filter],
        data: [String : DataType],
        schema: [String: DataType.Type]) throws

    func insert(collection collection: String,
        data: [String: DataType], model: Model) throws

    func delete(collection collection: String, filters: [Filter],
        schema: [String: DataType.Type]) throws

}
