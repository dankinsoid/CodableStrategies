import Foundation

public extension EncodingStrategy {

	/// Date encoding strategy.
	enum Date {}
}

public extension EncodingStrategy.Date {

	static var `default`: EncodingStrategy { CodingStrategy.Date.default.encoding }

	/// full-date notation as defined by RFC 3339, section 5.6, for example, 2017-07-21.
	static var date: EncodingStrategy {
		CodingStrategy.Date.date.encoding
	}

	/// the date-time notation as defined by RFC 3339, section 5.6, for example, 2017-07-21T17:32:28Z.
	static var iso8601: EncodingStrategy {
		CodingStrategy.Date.iso8601.encoding
	}

	/// Encodes dates following the ISO 8601 standard with custom options.
	static func iso8601(_ option: ISO8601DateFormatter.Options) -> EncodingStrategy {
		CodingStrategy.Date.iso8601(option).encoding
	}

	/// Decodes dates with custom DateFormatter.
	static func formatted(_ formatter: DateFormatter) -> EncodingStrategy {
		CodingStrategy.Date.formatted(formatter).encoding
	}

	/// Decodes/encodes dates with custom string format.
	static func formatted(
		_ format: String,
		locale: Locale = Locale(identifier: "en_US_POSIX"),
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .autoupdatingCurrent
	) -> EncodingStrategy {
		CodingStrategy.Date.formatted(format, locale: locale, timeZone: timeZone).encoding
	}

	/// the interval between the date value and 00:00:00 UTC on 1 January 1970.
	static var timestamp: EncodingStrategy {
		CodingStrategy.Date.timestamp.encoding
	}

	/// Custom date encoding strategy
	static func custom(
		encode: @escaping (Foundation.Date, inout SingleValueEncodingContainer) throws -> Void
	) -> EncodingStrategy {
		EncodingStrategy(Foundation.Date.self) {
			var container = $1.singleValueContainer()
			try encode($0, &container)
		}
	}
}
