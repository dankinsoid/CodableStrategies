import Foundation

public extension EncodingStrategy {

	/// Decimal encoding strategy scope.
	enum Decimal {}
}

public extension EncodingStrategy.Decimal {

	static var `default`: EncodingStrategy {
		CodingStrategy.Decimal.default.encoding
	}

	/// Quoted string
	static var string: EncodingStrategy {
		CodingStrategy.Decimal.string.encoding
	}

	/// Number
	static var number: EncodingStrategy {
		CodingStrategy.Decimal.number.encoding
	}
}
