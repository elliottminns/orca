import Foundation

final public class MemoryDriver {

    typealias Collection = [String: Document]

    typealias Document = [String: DataType]

    typealias Store = [String: Collection]

    var store: Store

    public init() {
        self.store = Store()
    }

}

extension MemoryDriver: Driver {

    public func printDatabase() {
        print("database: [{")
        for (key, collection) in store {
            print("    \(key): [{")
            for (key, document) in collection {
                print("        \(key): { ")

                for (key, value) in document {
                    print("            \(key): \(value)")
                }
                print("        },")
            }
            print("    }]")
        }
        print("}]")
    }

    public func generateUniqueIdentifier() -> String {
        return NSUUID().UUIDString
    }

    public func findOne(collection collection: String,
        filters: [Filter]) throws -> [String: DataType] {
        
        var id: String?
        
        for filter in filters {
            if let filter = filter as? CompareFilter {
                if filter.key == "identifier" {
                    id = filter.value
                }
            }
        }
        
        if let id = id {
            if let data = self.store[collection]?[id] {
                return data
            } else {
                throw DriverError.NotFound
            }
        } else {
            throw DriverError.NoIdentifier
        }
        
    }

    public func update(collection collection: String, filters: [Filter],
         data: [String : DataType]) throws {
        
        var original = try findOne(collection: collection, filters: filters)
        
        guard let identifier = original["identifier"] as? String else {
            throw DriverError.NoIdentifier
        }
        
        guard let _ = store[collection] else {
            throw DriverError.NotFound
        }
        
        for (key, value) in data {
            
            original[key] = value
        }
        
        store[collection]?[identifier] = original
    }

    public func insert(collection collection: String,
        data: [String: DataType]) throws {
            
            guard let identifier = data["identifier"] as? String else {
                throw DriverError.NoIdentifier
            }

            var collectionData: Collection

            if let col = store[collection] {

                collectionData = col

            } else {

                collectionData = Collection()
            }

            var document = Document()

            for (key, value) in data {

                document[key] = value
            }

            collectionData[identifier] = document
            store[collection] = collectionData
    }

    public func delete (collection collection: String,
        filters: [Filter]) throws {

    }
}
