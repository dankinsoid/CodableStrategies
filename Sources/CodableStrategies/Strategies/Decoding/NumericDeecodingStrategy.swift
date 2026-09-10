import Foundation

public extension DecodingStrategy {

	/// Numeric decoding strategies scope.
	enum Numeric {}
}

public extension DecodingStrategy.Numeric {

	/// Numeric coding strategy that tries to decode from a string if the value is quoted.
	static var string: DecodingStrategy {
		DecodingStrategy(StringDecodingStrategy())
	}
	
	private struct StringDecodingStrategy: GenericTypeDecodingStrategy {
		
		func decode<T>(from decoder: any Decoder, defaultDecoding: () throws -> T) throws -> T where T : Decodable {
			switch T.self {
			case is DecoderNumeric.Type:
				return try DecodingStrategy.Numeric.decodeFromString(decoder) {
					try defaultDecoding()
				} decode: {
					try $0.decode(T.self)
				}
			default:
				return try defaultDecoding()
			}
		}
	}
}

private protocol DecoderNumeric: Decodable, LosslessStringConvertible {}
	
extension Double: DecoderNumeric {}
extension Float: DecoderNumeric {}
extension Int: DecoderNumeric {}
extension Int8: DecoderNumeric {}
extension Int16: DecoderNumeric {}
extension Int32: DecoderNumeric {}
extension Int64: DecoderNumeric {}
extension UInt: DecoderNumeric {}
extension UInt8: DecoderNumeric {}
extension UInt16: DecoderNumeric {}
extension UInt32: DecoderNumeric {}
extension UInt64: DecoderNumeric {}
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension UInt128: DecoderNumeric {}

private extension DecodingStrategy.Numeric {

	@inline(__always)
	static func decodeFromString<T>(_ decoder: Decoder, defaultDecoding: () throws -> T, decode: (SingleValueDecodingContainer) throws -> T) throws -> T {
		do {
			let container = try decoder.singleValueContainer()
			let string = try container.decode(Swift.String.self)
			if let type = (T.self as? DecoderNumeric.Type), let result = type.init(string) as? T {
				return result
			}
			throw DecodingError.dataCorrupted(
				DecodingError.Context(
					codingPath: decoder.codingPath,
					debugDescription: "Invalid \(T.self) string '\(String(string.prefix(100)))'\(string.count > 100 ? "..." : "")"
				)
			)
		} catch {
			return try defaultDecoding()
		}
	}
}
