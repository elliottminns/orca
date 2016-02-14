
import Foundation

public enum ValueType {
    case String
    case Int
    case Double
    case Float
    case Bool
}

public protocol DataType {
    func toString() -> String
    static func fromString(string: String) -> Self
}

extension String: DataType {

    public func toString() -> String {
        return self
    }

    public static func fromString(string: String) -> String {
        return string
    }
}

extension Int: DataType {

    public func toString() -> String {
        return "\(self)"
    }

    static public func fromString(string: String) -> Int {
        return Int(string) ?? 0
    }
}

extension Double: DataType {

    public func toString() -> String {
        return "\(self)"
    }

    static public func fromString(string: String) -> Double {
        return Double(string) ?? 0
    }
}

extension Float: DataType {

    public func toString() -> String {
        return "\(self)"
    }

    static public func fromString(string: String) -> Float {
        return Float(string) ?? 0
    }
}

extension Bool: DataType {

    public func toString() -> String {
        return self == true ? "1" : "0"
    }

    static public func fromString(string: String) -> Bool {
        return string == "1"
    }

}
