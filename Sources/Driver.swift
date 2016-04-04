public enum DriverError: ErrorProtocol {
    case NoIdentifier
    case NotFound
    case NotImplemented
}

public typealias Schema = [String: SchemaType]

public protocol Driver {

    func connect(url: String, handler: (error: ErrorProtocol?) -> ())

    func generateUniqueIdentifier() -> String

    func findOne(collection collection: String,
        filters: [Filter], schema: Schema)
        throws -> [String: DataType]

    func find(collection collection: String, filters: [Filter],
        schema: Schema) throws -> [[String: DataType]]

    func update(collection collection: String, filters: [Filter],
        data: [String : DataType],
        schema: Schema) throws

    func insert(collection collection: String,
        data: [String: DataType], model: Model) throws

    func delete(collection collection: String, filters: [Filter],
        schema: Schema) throws

}
