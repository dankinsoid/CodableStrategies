import Foundation

public extension DecodingStrategy {

	/// URL decoding strategy scope.
	enum URL {}
}

public extension DecodingStrategy.URL {

	static var `default`: DecodingStrategy {
		CodingStrategy.URL.default.decoding
	}

	/// URI string.
	static var uri: DecodingStrategy {
		CodingStrategy.URL.uri.decoding
	}
}
