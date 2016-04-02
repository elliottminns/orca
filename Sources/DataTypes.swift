
import Foundation

public enum ValueType {
    case String
    case Int
    case Double
    case Float
    case Bool
}

extension Database {
    static public var supportedTypes: [DataType.Type] {
        return [String.self, Int.self, Double.self, Float.self, Bool.self]
    }
}

public protocol DataType {
    static func fromString(string: String) -> Self?
    func toString() -> String
    static var valueType: ValueType { get }
}

extension DataType {

    public var typeString: String {
        return "\(self.dynamicType)"
    }

    static func dataTypeFromTypeString(string: String) -> DataType.Type? {

        for type in Database.supportedTypes {

            if "\(type)" == string {
                return type
            }
        }

        return nil
    }

}

extension String: DataType {
    static public func fromString(string: String) -> String? {
        return string
    }

    public func toString() -> String {
        return "\(self)"
    }

    static public var valueType: ValueType {
        return .String
    }
}

extension Int: DataType {
    static public func fromString(string: String) -> Int? {
        return Int(string)
    }

    public func toString() -> String {
        return "\(self)"
    }

    static public var valueType: ValueType {
        return .Int
    }
}

extension Double: DataType {
    static public func fromString(string: String) -> Double? {
        return Double(string)
    }

    public func toString() -> String {
        return "\(self)"
    }

    static public var valueType: ValueType {
        return .Double
    }


}

extension Float: DataType {
    static public func fromString(string: String) -> Float? {
        return Float(string)
    }

    public func toString() -> String {
        return "\(self)"
    }

    static public var valueType: ValueType {
        return .Float
    }
}

extension Bool: DataType {
    static public func fromString(string: String) -> Bool? {
        return string == "1"
    }

    public func toString() -> String {
        return self ? "1" : "0"
    }

    static public var valueType: ValueType {
        return .Bool
    }
}
