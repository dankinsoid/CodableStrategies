import Foundation

public extension DecodingStrategy {

	/// Key decoding strategy scope.
	enum Key {}
}

public extension DecodingStrategy.Key {

	/// Does not change the key.
	static var useDefaultKeys: DecodingStrategy = .Key.custom { $0 }

	/// Custom key decoding strategy.
	static func custom(_ decode: @escaping (Swift.String) -> Swift.String) -> DecodingStrategy {
		DecodingStrategy(decodeKey: decode)
	}

	/// Decodes from snake_case to camelCase.
	static var fromSnakeCase: DecodingStrategy {
		CodingStrategy.Key.encodeToCamelCaseDecodeFromSnakeCase.decoding
	}

	/// Decodes from camelCase to snake_case with a custom separator.
	static func fromSnakeCase(separator: Swift.String) -> DecodingStrategy {
		CodingStrategy.Key.encodeToCamelCaseDecodeFromSnakeCase(separator: separator).decoding
	}

	/// Decodes from camelCase to snake_case .
	static var fromCamelCase: DecodingStrategy {
		CodingStrategy.Key.encodeToSnakeCaseDecodeFromCamelCase.decoding
	}

	/// Decodes from camelCase to snake_case with a custom separator.
	static func fromCamelCase(separator: Swift.String) -> DecodingStrategy {
		CodingStrategy.Key.encodeToSnakeCaseDecodeFromCamelCase(separator: separator).decoding
	}
}
