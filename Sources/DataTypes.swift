
import Foundation

public enum ValueType {
    case String
    case Int
    case Double
    case Float
    case Bool
}

public protocol DataType {

}

extension DataType {
    var type: String {
        return "\(self.dynamicType)"
    }
}

extension String: DataType {

}

extension Int: DataType {

}

extension Double: DataType {

}

extension Float: DataType {

}

extension Bool: DataType {

}
