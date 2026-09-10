import Foundation

public extension DecodingStrategy {

	/// Data decoding strategy scope.
	enum Data {}
}

public extension DecodingStrategy.Data {

	static var `default`: DecodingStrategy { CodingStrategy.Data.default.decoding }

	/// Base64 string.
	static var base64: DecodingStrategy {
		CodingStrategy.Data.base64.decoding
	}

	/// Base64 string,.
	static func base64(options: Foundation.Data.Base64DecodingOptions) -> DecodingStrategy {
		CodingStrategy.Data.base64(decodingOptions: options).decoding
	}
}
