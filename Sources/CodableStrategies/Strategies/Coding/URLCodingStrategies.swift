import Foundation

public extension CodingStrategy {

	/// URL encoding strategy scope.
	enum URL {}
}

public extension CodingStrategy.URL {

	static var `default`: CodingStrategy { .URL.uri }

	/// URI string.
	static var uri: CodingStrategy {
		CodingStrategy(Foundation.URL.self) { decoder in
			let container = try decoder.singleValueContainer()
			let urlString = try container.decode(Swift.String.self)
			guard let url = Foundation.URL(string: urlString) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid url string: \(urlString)"
				)
			}
			return url
		} encode: { url, encoder in
			var container = encoder.singleValueContainer()
			try container.encode(url.absoluteString)
		}
	}
}
