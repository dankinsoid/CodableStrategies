import Foundation

public extension CodingStrategy {

	/// Date coding strategy scope.
	enum Date {}
}

public extension CodingStrategy.Date {

	static var `default`: CodingStrategy { .Date.timestamp }

	/// ISO 8601 full-date notation as defined by RFC 3339, section 5.6, for example, 2017-07-21.
	static var date: CodingStrategy {
		.Date.iso8601([.withFullDate, .withDashSeparatorInDate])
	}

	/// ISO 8601 date-time notation as defined by RFC 3339, for example, 2016-06-13T16:00:00+00:00.
	static var iso8601: CodingStrategy {
		.Date.iso8601(
			encodeTo: defaultOptions,
			decodeFrom: [
				defaultOptions,
				[defaultOptions, .withFractionalSeconds],
				[defaultOptions, .withColonSeparatorInTimeZone],
				[defaultOptions, .withColonSeparatorInTimeZone, .withFractionalSeconds],
				[.withFullDate, .withDashSeparatorInDate],
			]
		)
	}

	/// Decodes/encodes dates following the ISO 8601 standard with custom options.
	static func iso8601(_ options: ISO8601DateFormatter.Options) -> CodingStrategy {
		.Date.iso8601(encodeTo: options, decodeFrom: [])
	}

	/// Decodes/encodes dates following the ISO 8601 standard with custom options.
	static func iso8601(
		encodeTo format: ISO8601DateFormatter.Options,
		decodeFrom formats: [ISO8601DateFormatter.Options]
	) -> CodingStrategy {
		.Date.custom { container in
			let string = try container.decode(Swift.String.self)
			var formats = formats
			if !formats.contains(format) {
				formats.insert(format, at: 0)
			}
			var date: Date?
			while date == nil, !formats.isEmpty {
				isoFormatter.formatOptions = formats.removeFirst()
				date = isoFormatter.date(from: string)
			}
			guard let date else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid date format. Expected ISO8601 string."
				)
			}
			return date
		} encode: { date, container in
			isoFormatter.formatOptions = format
			return try container.encode(isoFormatter.string(from: date))
		}
	}

	/// Decodes/encodes dates with custom DateFormatter.
	static func formatted(_ formatter: DateFormatter) -> CodingStrategy {
		.Date.custom { container in
			let string = try container.decode(Swift.String.self)
			guard let date = formatter.date(from: string) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid date format. Expected \(formatter.dateFormat ?? "") string."
				)
			}
			return date
		} encode: { date, container in
			try container.encode(formatter.string(from: date))
		}
	}

	/// Decodes/encodes dates with custom string format.
	static func formatted(
		_ format: String,
		locale: Locale = Locale(identifier: "en_US_POSIX"),
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .autoupdatingCurrent
	) -> CodingStrategy {
		.Date.formatted(encodeTo: format, decodeFrom: [], locale: locale, timeZone: timeZone)
	}

	/// Decodes/encodes dates with custom string format.
	static func formatted(
		encodeTo format: String,
		decodeFrom formats: Set<String>,
		locale: Locale = Locale(identifier: "en_US_POSIX"),
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .autoupdatingCurrent
	) -> CodingStrategy {
		.Date.custom { container in
			let string = try container.decode(Swift.String.self)
			dateFormatter.dateFormat = format
			dateFormatter.locale = locale
			dateFormatter.timeZone = timeZone
			var date: Date?
			var formats = formats.union([format])
			while date == nil, !formats.isEmpty {
				dateFormatter.dateFormat = formats.removeFirst()
				date = dateFormatter.date(from: string)
			}
			guard let date else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid date format. Expected \(format) string."
				)
			}
			return date
		} encode: { date, container in
			dateFormatter.dateFormat = format
			dateFormatter.locale = locale
			dateFormatter.timeZone = timeZone
			return try container.encode(dateFormatter.string(from: date))
		}
	}

	/// The interval between the date value and 00:00:00 UTC on 1 January 1970.
	static var timestamp: CodingStrategy {
		.Date.custom { container in
			try Foundation.Date(timeIntervalSince1970: container.decode(TimeInterval.self))
		} encode: { date, container in
			try container.encode(date.timeIntervalSince1970)
		}
	}

	/// Custom date coding strategy.
	static func custom(
		decode: @escaping (SingleValueDecodingContainer) throws -> Foundation.Date,
		encode: @escaping (Foundation.Date, inout SingleValueEncodingContainer) throws -> Void
	) -> CodingStrategy {
		CodingStrategy(Foundation.Date.self) {
			try decode($0.singleValueContainer())
		} encode: {
			var container = $1.singleValueContainer()
			try encode($0, &container)
		}
	}
}

extension CodingStrategy.Date {

	private static let isoFormatter = ISO8601DateFormatter()
	private static let defaultOptions: ISO8601DateFormatter.Options = [.withFullDate, .withFullTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
	private static let dateFormatter = DateFormatter()
}
