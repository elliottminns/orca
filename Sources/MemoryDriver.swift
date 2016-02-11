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
            return [:]
    }

    public func update(collection collection: String, filters: [Filter],
         data: [String : DataType]) throws {

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
