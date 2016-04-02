
import Foundation

public protocol Model: class {
    var identifier: String? { get set }
    init?(serialized: [String: DataType])
    static var schema: [String: DataType.Type] { get }
}

extension Model {

    static public func fullSchema() -> [String: DataType.Type] {

        var schema = self.schema

        schema["identifier"] = String.self

        return schema
    }
}

// MARK: - Reflection

extension Model {

    func valueFromAny(any: Any) -> DataType? {
        let value: DataType?
        if let v = any as? DataType {
            value = v
        } else if let v = any as? Double {
            value = v
        } else if let v = any as? String {
            value = v
        } else if let v = any as? Float {
            value = v
        } else if let v = any as? Int {
            value = v
        } else if let v = any as? Bool {
            value = v
        } else {
            value = nil
        }
        return value
    }

    var properties: [String] {
        return Mirror(reflecting: self).children
        .filter {
            $0.label != nil
        }.map {
             $0.label!
         }
    }

    var values: [DataType] {

        return Mirror(reflecting: self).children.filter {
            valueFromAny($0.value) != nil
        }.map {
            return valueFromAny($0.value)!
        }
    }

    func serialize() -> [String: DataType] {

        var values = [String: DataType]()
        let data = Mirror(reflecting: self).children.filter {
            $0.label != nil
        }

        for property in data {
            let label = property.label!

            if let value = valueFromAny(property.value) {
                values[label] = value
            }
        }

        return values
    }
}


// MARK: - Public Methods

extension Model {

    public func save(handler: (error: ErrorProtocol?) -> ()) {
        self.save(database: Database.defaultDatabase, handler: handler)
    }

    public func save(database database: Database,
        handler: (error: ErrorProtocol?) -> ()) {
            Query(database: database).save(self) { (model, error) in
                handler(error: error)

        }
    }

    public func delete(handler: (error: ErrorProtocol?) -> ()) {
        self.delete(Database.defaultDatabase, handler: handler)
    }

    public func delete(database: Database, handler: (error: ErrorProtocol?) -> ()) {

        guard let identifier = self.identifier else {
            handler(error: DriverError.NoIdentifier)
            return
        }

        let filter = CompareFilter(key: "identifier", value: identifier, comparison: .Equals)
        let filters: [Filter] = [filter]
        Query(database: database, filters: filters)
            .delete(self, handler: handler)
    }

    public static func find(identifier: String,
        handler: (model: Self?, error: ErrorProtocol?) -> ()) {

        find(Database.defaultDatabase, identifier: identifier, handler: handler)
    }

    public static func find(database: Database, identifier: String,
                            handler: (model: Self?, error: ErrorProtocol?) -> ()) {
        Query(database: database).find(identifier, handler: handler)
    }

    public static func findAll(handler: (models: [Self], error: ErrorProtocol?) -> ()) {
        findAll(Database.defaultDatabase, handler: handler)
    }

    public static func findAll(database: Database,
                               handler: (models: [Self], error: ErrorProtocol?) -> ()) {
        Query(database: database).find(self, handler: handler)
    }

    static var collection: String {
        var type: String = String(self.dynamicType)
        if let range = type.range(of: ".Type") {
            type.removeSubrange(range)
        }

        type.append(Character("s"))
        type = type.lowercased()

        return type
    }
}
