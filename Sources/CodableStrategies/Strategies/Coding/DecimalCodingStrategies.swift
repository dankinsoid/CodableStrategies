import Foundation

public extension CodingStrategy {

	/// Decimal coding strategy scope.
	enum Decimal {}
}

public extension CodingStrategy.Decimal {

	static var `default`: CodingStrategy { .Decimal.number }

	/// Coding strategy that encodes a decimal as a strings and tries to decode it from a string if the value is a quoted string.
	static var string: CodingStrategy {
		CodingStrategy(Foundation.Decimal.self) {
			let container = try $0.singleValueContainer()
			let string: Swift.String
			do {
				string = try container.decode(Swift.String.self)
			} catch {
				let double = try container.decode(Swift.Double.self)
				return Foundation.Decimal(double)
			}
			guard let decimal = Foundation.Decimal(string: string) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid decimal string: \(string)"
				)
			}
			return decimal
		} encode: { decimal, encoder in
			var container = encoder.singleValueContainer()
			try container.encode(decimal.description)
		}
	}

	/// Coding strategy that encodes a decimal as a number decode it from a number.
	static var number: CodingStrategy {
		CodingStrategy(Foundation.Decimal.self) {
			let container = try $0.singleValueContainer()
			let number = try container.decode(Swift.Double.self)
			return Foundation.Decimal(number)
		} encode: { decimal, encoder in
			var container = encoder.singleValueContainer()
			try container.encode((decimal as NSDecimalNumber).doubleValue)
		}
	}

	/// Coding strategy that encodes a decimal as a number and tries to decode it from a string if the value is a quoted string.
	static var decodeFromString: CodingStrategy {
		CodingStrategy(
			decoding: CodingStrategy.Decimal.string.decoding,
			encoding: CodingStrategy.Decimal.number.encoding
		)
	}
}
