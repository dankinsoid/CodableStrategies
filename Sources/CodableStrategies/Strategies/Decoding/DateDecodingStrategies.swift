import Foundation

public extension DecodingStrategy {

	/// Date decoding strategy.
	enum Date {}
}

public extension DecodingStrategy.Date {

	static var `default`: DecodingStrategy { CodingStrategy.Date.default.decoding }

	/// full-date notation as defined by RFC 3339, section 5.6, for example, 2017-07-21.
	static var date: DecodingStrategy {
		CodingStrategy.Date.date.decoding
	}

	/// the date-time notation as defined by RFC 3339, section 5.6, for example, 2017-07-21T17:32:28Z.
	static var iso8601: DecodingStrategy {
		CodingStrategy.Date.iso8601.decoding
	}

	/// Decodes dates following the ISO 8601 standard with custom options.
	static func iso8601(_ option: ISO8601DateFormatter.Options) -> DecodingStrategy {
		CodingStrategy.Date.iso8601(option).decoding
	}

	/// Decodes dates following the ISO 8601 standard with various custom options.
	static func iso8601(formats options: [ISO8601DateFormatter.Options]) -> DecodingStrategy {
		CodingStrategy.Date.iso8601(encodeTo: [], decodeFrom: options).decoding
	}

	/// Decodes dates with custom DateFormatter.
	static func formatted(_ formatter: DateFormatter) -> DecodingStrategy {
		CodingStrategy.Date.formatted(formatter).decoding
	}

	/// Decodes/encodes dates with custom string format.
	static func formatted(
		_ format: String,
		locale: Locale = Locale(identifier: "en_US_POSIX"),
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .autoupdatingCurrent
	) -> DecodingStrategy {
		CodingStrategy.Date.formatted(format, locale: locale, timeZone: timeZone).decoding
	}

	/// Decodes/encodes dates with custom string format.
	static func formatted(
		formats: Set<String>,
		locale: Locale = Locale(identifier: "en_US_POSIX"),
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .autoupdatingCurrent
	) -> DecodingStrategy {
		CodingStrategy.Date.formatted(encodeTo: "", decodeFrom: formats, locale: locale, timeZone: timeZone).decoding
	}

	/// the interval between the date value and 00:00:00 UTC on 1 January 1970.
	static var timestamp: DecodingStrategy {
		CodingStrategy.Date.timestamp.decoding
	}

	/// Custom date decoding strategy
	static func custom(
		decode: @escaping (SingleValueDecodingContainer) throws -> Foundation.Date
	) -> DecodingStrategy {
		DecodingStrategy(Foundation.Date.self) {
			try decode($0.singleValueContainer())
		}
	}
}
