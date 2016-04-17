public enum DriverError: ErrorProtocol {
    case NoIdentifier
    case NotFound
    case NotImplemented
}

public typealias Schema = [String: SchemaType]

public protocol Driver {

    func connect(_ url: String, handler: (error: ErrorProtocol?) -> ())

    func generateUniqueIdentifier() -> String

    func findOne(collection: String,
        filters: [Filter], schema: Schema)
        throws -> [String: DataType]

    func find(collection: String, filters: [Filter],
        schema: Schema) throws -> [[String: DataType]]

    func update(collection: String, filters: [Filter],
        data: [String : DataType],
        schema: Schema) throws

    func insert(collection: String,
        data: [String: DataType], model: Model) throws

    func delete(collection: String, filters: [Filter],
        schema: Schema) throws

}
