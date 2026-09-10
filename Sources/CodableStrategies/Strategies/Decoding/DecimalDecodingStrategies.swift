import Foundation

public extension DecodingStrategy {

	/// Decimal decoding strategy scope.
	enum Decimal {}
}

public extension DecodingStrategy.Decimal {

	static var `default`: DecodingStrategy {
		CodingStrategy.Decimal.default.decoding
	}

	/// Decimal coding strategy that tries to decode from a string if the value is quoted.
	static var string: DecodingStrategy {
		CodingStrategy.Decimal.decodeFromString.decoding
	}

	/// Number
	static var number: DecodingStrategy {
		CodingStrategy.Decimal.number.decoding
	}
}
