import Foundation

public extension DecodingStrategy {

	/// Numeric decoding strategies scope.
	enum Numeric {}
}

public extension DecodingStrategy.Numeric {

	/// Numeric coding strategy that tries to decode from a string if the value is quoted.
	static var string: DecodingStrategy {
		DecodingStrategy(
			decodeDouble: { try decodeFromString($0) { try $0.decode(Swift.Double.self) } },
			decodeFloat: { try decodeFromString($0) { try $0.decode(Swift.Float.self) } },
			decodeInt: { try decodeFromString($0) { try $0.decode(Swift.Int.self) } },
			decodeInt8: { try decodeFromString($0) { try $0.decode(Swift.Int8.self) } },
			decodeInt16: { try decodeFromString($0) { try $0.decode(Swift.Int16.self) } },
			decodeInt32: { try decodeFromString($0) { try $0.decode(Swift.Int32.self) } },
			decodeInt64: { try decodeFromString($0) { try $0.decode(Swift.Int64.self) } },
			decodeUInt: { try decodeFromString($0) { try $0.decode(Swift.UInt.self) } },
			decodeUInt8: { try decodeFromString($0) { try $0.decode(Swift.UInt8.self) } },
			decodeUInt16: { try decodeFromString($0) { try $0.decode(Swift.UInt16.self) } },
			decodeUInt32: { try decodeFromString($0) { try $0.decode(Swift.UInt32.self) } },
			decodeUInt64: { try decodeFromString($0) { try $0.decode(Swift.UInt64.self) } }
		)
	}
}

private extension DecodingStrategy.Numeric {

	@inline(__always)
	static func decodeFromString<T: LosslessStringConvertible>(_ decoder: Decoder, decode: (SingleValueDecodingContainer) throws -> T) throws -> T {
		let container = try decoder.singleValueContainer()
		let string = try container.decode(Swift.String.self)
		if let result = T(string) {
			return result
		}
		throw DecodingError.dataCorruptedError(
			in: container,
			debugDescription: "Expected a numeric value, but found \(string) instead."
		)
	}
}
