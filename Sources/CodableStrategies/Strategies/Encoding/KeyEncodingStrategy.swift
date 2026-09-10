import Foundation

public extension EncodingStrategy {

	/// Key encoding strategy scope.
	enum Key {}
}

public extension EncodingStrategy.Key {

	/// Does not change the key.
	static var useDefaultKeys: EncodingStrategy = .Key.custom { $0 }

	/// Custom key encoding strategy.
	static func custom(_ encode: @escaping (Swift.String) -> Swift.String) -> EncodingStrategy {
		EncodingStrategy(encodeKey: encode)
	}

	/// Encodes from camelCase to snake_case.
	static var toSnakeCase: EncodingStrategy {
		CodingStrategy.Key.encodeToSnakeCaseDecodeFromCamelCase.encoding
	}

	/// Encodes from camelCase to snake_case with a custom separator.
	static func toSnakeCase(separator: Swift.String) -> EncodingStrategy {
		CodingStrategy.Key.encodeToSnakeCaseDecodeFromCamelCase(separator: separator).encoding
	}

	/// Encodes from snake_case to camelCase.
	static var toCamelCase: EncodingStrategy {
		CodingStrategy.Key.encodeToCamelCaseDecodeFromSnakeCase.encoding
	}

	/// Encodes from snake_case to camelCase with a custom separator.
	static func toCamelCase(separator: Swift.String) -> EncodingStrategy {
		CodingStrategy.Key.encodeToCamelCaseDecodeFromSnakeCase(separator: separator).encoding
	}
}
