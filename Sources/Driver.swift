public protocol Driver {
    func findOne(collection collection: String,
        filters: [Filter]) throws -> [String: DataType]
}
