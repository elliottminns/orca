
import Foundation

public enum ValueType {
    case String
    case Int
    case Double
    case Float
    case Bool
}

extension Orca {
    static public var supportedTypes: [DataType.Type] {
        return [String.self, Int.self, Double.self, Float.self, Bool.self]
    }
}

public protocol DataType {
    static func fromString(string: String) -> Self?
    func toString() -> String
}

extension DataType {

    public var typeString: String {
        return "\(self.dynamicType)"
    }

    static func dataTypeFromTypeString(string: String) -> DataType.Type? {

        for type in Orca.supportedTypes {

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
}

extension Int: DataType {
    static public func fromString(string: String) -> Int? {
        return Int(string)
    }

    public func toString() -> String {
        return "\(self)"
    }
}

extension Double: DataType {
    static public func fromString(string: String) -> Double? {
        return Double(string)
    }

    public func toString() -> String {
        return "\(self)"
    }
}

extension Float: DataType {
    static public func fromString(string: String) -> Float? {
        return Float(string)
    }

    public func toString() -> String {
        return "\(self)"
    }
}

extension Bool: DataType {
    static public func fromString(string: String) -> Bool? {
        return string == "1"
    }

    public func toString() -> String {
        return self ? "1" : "0"
    }
}
