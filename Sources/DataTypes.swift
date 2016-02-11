
import Foundation

public enum ValueType {
    case String
    case Int
    case Double
    case Float
}

public protocol DataType {

}

extension String: DataType {

}

extension Int: DataType {

}

extension Double: DataType {

}

extension Float: DataType {

}
