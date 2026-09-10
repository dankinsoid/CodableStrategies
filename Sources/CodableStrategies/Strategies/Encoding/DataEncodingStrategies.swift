import Foundation

public extension EncodingStrategy {

	/// Data encoding strategy scope.
	enum Data {}
}

public extension EncodingStrategy.Data {

	static var `default`: EncodingStrategy { CodingStrategy.Data.default.encoding }

	/// Base64 string.
	static var base64: EncodingStrategy {
		CodingStrategy.Data.base64.encoding
	}

	/// Base64 string,.
	static func base64(options: Foundation.Data.Base64EncodingOptions) -> EncodingStrategy {
		CodingStrategy.Data.base64(encodingOptions: options).encoding
	}
}
