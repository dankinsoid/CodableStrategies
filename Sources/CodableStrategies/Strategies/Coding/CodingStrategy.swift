import Foundation

/// A structure that combines encoding and decoding strategies, enabling consistent data transformations.
///
/// `CodingStrategy` serves as a centralized strategy hub, consolidating separate encoding and decoding strategies for seamless data processing.
public struct CodingStrategy {

	/// The encoding strategy applied during data serialization.
	public let encoding: EncodingStrategy

	/// The decoding strategy applied during data deserialization.
	public let decoding: DecodingStrategy

	/// Initializes a new instance of `CodingStrategy` with distinct encoding and decoding strategies.
	///
	/// - Parameters:
	///   - decoding: The strategy to be used during the decoding process.
	///   - encoding: The strategy to be used during the encoding process.
	public init(
		decoding: DecodingStrategy,
		encoding: EncodingStrategy
	) {
		self.encoding = encoding
		self.decoding = decoding
	}

	/// Initializes a new instance of `CodingStrategy` for a specific codable type, with custom encoding and decoding closures.
	///
	/// This initializer offers a more granular setup, allowing for custom logic during the encode and decode processes.
	///
	/// - Parameters:
	///   - type: The `Codable` type for which the strategies will be applied.
	///   - decode: A closure that defines custom decoding logic for the provided type.
	///   - encode: A closure that defines custom encoding logic for the provided type.
	public init<T: Codable>(
		_ type: T.Type,
		decode: @escaping (Decoder) throws -> T,
		encode: @escaping (T, Encoder) throws -> Void
	) {
		self.init(
			decoding: DecodingStrategy(type, decode: decode),
			encoding: EncodingStrategy(type, encode: encode)
		)
	}
}

public extension CodingStrategy {

	/// Default coding strategy, can be changed globally.
	static var `default` = CodingStrategy(decoding: .default, encoding: .default)
}
