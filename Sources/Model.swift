
import Foundation

public protocol Model {
    var identifier: String? { get set }
    init?(serialized: [String: DataType])
}

extension Model {

    var properties: [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
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
            $0.label != nil && $0.value as? DataType != nil
         }

        for value in data {

            values[value.label!] = value.value as? DataType
        }

        return values
    }

    func save(handler: (error: ErrorType) -> ()) {

    }

    func save(database database: Orca, handler:() -> ()) {

    }

    func delete(handler: (error: ErrorType) -> ()) {

    }

    static func find(identifier: String,
        handler: (model: Self?, error: ErrorType) -> ()) {
    }

    static var collection: String {
        return "Test"
    }
}
