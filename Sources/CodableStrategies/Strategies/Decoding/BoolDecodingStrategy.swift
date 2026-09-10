import Foundation

public extension DecodingStrategy {

	/// Bool decoding strategy scope.
	enum Bool {}
}

public extension DecodingStrategy.Bool {

	/// Decodes booleans from strings if the value is quoted.
	static var string: DecodingStrategy {
		.Bool.string {
			defaultTrueString.contains($0.lowercased())
		}
	}

	/// Decodes booleans from strings if the value is quoted.
	static func string(_ condition: @escaping (Swift.String) -> Swift.Bool) -> DecodingStrategy {
		DecodingStrategy(Bool.self) {
			let container = try $0.singleValueContainer()
			return try condition(container.decode(Swift.String.self))
		}
	}
}

private extension DecodingStrategy.Bool {

	static let defaultTrueString: Set<Swift.String> = ["true", "yes", "1"]
}
