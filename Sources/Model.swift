
import Foundation

public protocol Model: class {
    var identifier: String? { get set }
    init?(serialized: [String: DataType])
}

extension Model {

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
            $0.value as? DataType != nil
        }.map {
            $0.value as! DataType
        }
    }

    func serialize() -> [String: DataType] {

        var values = [String: DataType]()
        let data = Mirror(reflecting: self).children.filter {
            $0.label != nil
        }

        for property in data {
            let label = property.label!

            var value: DataType?
            if let v = property.value as? DataType {
                value = v
            } else if let v = property.value as? Double {
                value = v
            } else if let v = property.value as? String {
                value = v
            } else if let v = property.value as? Float {
                value = v
            } else if let v = property.value as? Int {
                value = v
            } else if let v = property.value as? Bool {
                value = v
            }

            if let value = value {
                values[label] = value
            }
        }

        return values
    }

    public func save(handler: (error: ErrorType?) -> ()) {
        self.save(database: Orca.defaultOrca, handler: handler)
    }

    public func save(database database: Orca, handler: (error: ErrorType?) -> ()) {

            Query(database: database).save(self) { (model, error) in
                handler(error: error)
     
        }
    }

    public func delete(handler: (error: ErrorType?) -> ()) {
        self.delete(Orca.defaultOrca, handler: handler)
    }
    
    public func delete(database: Orca, handler: (error: ErrorType?) -> ()) {
        
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
        handler: (model: Self?, error: ErrorType?) -> ()) {
        
        find(Orca.defaultOrca, identifier: identifier, handler: handler)
    }
    
    public static func find(database: Orca, identifier: String,
                            handler: (model: Self?, error: ErrorType?) -> ()) {
        Query(database: database).find(identifier, handler: handler)
    }
    
    public static func findAll(handler: (models: [Self], error: ErrorType?) -> ()) {
        findAll(Orca.defaultOrca, handler: handler)
    }
    
    public static func findAll(database: Orca,
                               handler: (models: [Self], error: ErrorType?) -> ()) {
        Query(database: database).find(self, handler: handler)
    }

    static var collection: String {
        var type: String = String(self.dynamicType)
        if let range = type.rangeOfString(".Type") {
            type.removeRange(range)
        }
        
        type.append(Character("s"))
        type = type.lowercaseString
        
        return type
    }
}
