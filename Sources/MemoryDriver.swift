final public class MemoryDriver {

}

extension MemoryDriver: Driver {
    public func findOne(collection collection: String,
        filters: [Filter]) throws -> [String: DataType] {
            return [:]
        }
}
