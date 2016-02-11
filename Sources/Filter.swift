public protocol Filter {

}

public struct CompareFilter: Filter {

    public enum Comparison {
		case Equals
        case NotEquals
        case GreaterThanOrEquals
        case LessThanOrEquals
        case GreaterThan
        case LessThan
	}

    public let key: String

	public let value: String

	public let comparison: Comparison

	public init(key: String, value: String, comparison: Comparison) {
		self.key = key
		self.value = value
		self.comparison = comparison
	}

}
