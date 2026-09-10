import Foundation

public extension EncodingStrategy {

	/// Numeric encoding strategies scope.
	enum Numeric {}
}

public extension EncodingStrategy.Numeric {

	/// Numeric encoding strategy that encodes numbers as quoted strings.
	static var string: EncodingStrategy {
		EncodingStrategy(
			encodeDouble: { try encodeToString($0, $1) },
			encodeFloat: { try encodeToString($0, $1) },
			encodeInt: { try encodeToString($0, $1) },
			encodeInt8: { try encodeToString($0, $1) },
			encodeInt16: { try encodeToString($0, $1) },
			encodeInt32: { try encodeToString($0, $1) },
			encodeInt64: { try encodeToString($0, $1) },
			encodeUInt: { try encodeToString($0, $1) },
			encodeUInt8: { try encodeToString($0, $1) },
			encodeUInt16: { try encodeToString($0, $1) },
			encodeUInt32: { try encodeToString($0, $1) },
			encodeUInt64: { try encodeToString($0, $1) }
		)
	}
}

private extension EncodingStrategy.Numeric {

	@inline(__always)
	static func encodeToString<T: CustomStringConvertible>(_ value: T, _ encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(value.description)
	}
}
