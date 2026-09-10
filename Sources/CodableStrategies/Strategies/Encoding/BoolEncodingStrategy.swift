import Foundation

public extension EncodingStrategy {

	/// Bool encoding strategy scope.
	enum Bool {}
}

public extension EncodingStrategy.Bool {

	/// Encodes booleans as quoted strings.
	static var string: EncodingStrategy {
		.Bool.string(true: "true", false: "false")
	}

	/// Encodes booleans as quoted strings.
	static func string(true trueString: Swift.String, false falseString: Swift.String) -> EncodingStrategy {
		EncodingStrategy(
			encodeBool: {
				var container = $1.singleValueContainer()
				let string = $0 ? trueString : falseString
				try container.encode(string)
			}
		)
	}
}
