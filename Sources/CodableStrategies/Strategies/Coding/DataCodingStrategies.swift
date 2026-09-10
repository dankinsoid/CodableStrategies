import Foundation

public extension CodingStrategy {

	/// Data coding strategy scope.
	enum Data {}
}

public extension CodingStrategy.Data {

	static var `default`: CodingStrategy { .Data.base64 }

	/// Encodes data as Base64 and decodes Base64 data.
	static var base64: CodingStrategy {
		.Data.base64()
	}

	/// Encodes data as Base64 and decodes Base64 data.
	static func base64(
		decodingOptions: Foundation.Data.Base64DecodingOptions = [],
		encodingOptions: Foundation.Data.Base64EncodingOptions = []
	) -> CodingStrategy {
		CodingStrategy(Foundation.Data.self) { decoder in
			let container = try decoder.singleValueContainer()
			let base64String = try container.decode(String.self)
			guard let data = Foundation.Data(base64Encoded: base64String, options: decodingOptions) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid base64 string: \(base64String)"
				)
			}
			return data
		} encode: { data, encoder in
			var container = encoder.singleValueContainer()
			try container.encode(data.base64EncodedString(options: encodingOptions))
		}
	}
}
