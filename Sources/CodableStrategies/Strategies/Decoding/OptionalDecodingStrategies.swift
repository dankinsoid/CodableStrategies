import Foundation

public extension DecodingStrategy {

	/// Optional encoding strategies scope.
	enum Optional {}
}

public extension DecodingStrategy.Optional {

	/// Encodes `nil` if decoding fails.
	static var nilIfError: DecodingStrategy {
		DecodingStrategy(OptionalDecodingStrategy())
	}
}

private struct OptionalDecodingStrategy: GenericTypeDecodingStrategy {

	func decode<T>(from decoder: any Decoder, defaultDecoding: () throws -> T) throws -> T where T : Decodable {
		try defaultDecoding()
	}

	func decodeIfPresent<T>(from decoder: any Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T? where T : Decodable {
		if isPresent {
			return try? defaultDecoding()
		} else {
			return nil
		}
	}
}

private extension Decoder {

	@inline(__always)
	func nilIfError<T>(_ decode: (SingleValueDecodingContainer) throws -> T) -> T? {
		let container = try? singleValueContainer()
		return container.flatMap { try? decode($0) }
	}
}
