import Foundation

public extension CodingStrategy {

	/// Bool coding strategy scope.
	enum Bool {}
}

public extension CodingStrategy.Bool {

	/// Decodes booleans from strings if the value is quoted.
	static var decodeFromString: CodingStrategy {
		CodingStrategy(decoding: .Bool.string, encoding: EncodingStrategy())
	}

	/// Encodes booleans as strings and decodes booleans from strings if the value is quoted.
	static var string: CodingStrategy {
		CodingStrategy(decoding: .Bool.string, encoding: .Bool.string)
	}
}
