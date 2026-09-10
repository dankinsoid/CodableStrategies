import Foundation

/// A decorator that wraps an encoder, providing enhanced functionality with custom encoding strategies.
///
/// `EncoderDecorator` offers a standardized interface for encoding, but with the added flexibility of specifying encoding strategies.
/// This makes it possible to modify encoding behavior without creating entirely new encoder implementations.
///
/// - Generic Parameter `Target`: The type of the target format into which values will be encoded.
///
/// Example usage:
/// ```
/// let myModel = MyModel(...)
/// let customEncoder = EncoderDecorator(JSONEncoder()) { introspect in
///     // custom encoding logic using `introspect`
/// }
/// let jsonData: Data = try customEncoder.encode(myModel)
/// ```
///
/// - Note: The decorator uses `EncodingStrategy` to determine its behavior during the encoding process.
///         If a specific strategy is not provided, `.default` is used.
public struct EncoderDecorator<Target>: ValueEncoder {

	private let _encode: (_ value: EncoderIntrospect) throws -> Target
	public var strategy: EncodingStrategy

	/// Initializes a new instance of `EncoderDecorator` with a specified encoding strategy and a custom encoding closure.
	///
	/// - Parameters:
	///   - strategy: The encoding strategy to be used. Defaults to `.default`.
	///   - encode: A closure that defines the custom encoding logic using `EncoderIntrospect`.
	public init(
		strategy: EncodingStrategy = .default,
		encode: @escaping (EncoderIntrospect) throws -> Target
	) {
		self.strategy = strategy
		_encode = encode
	}

	/// Initializes a new instance of `EncoderDecorator` using a provided encoder and an optional encoding strategy.
	///
	/// - Parameters:
	///   - encoder: An encoder that conforms to `ValueEncoder<Target>`.
	///   - strategy: The encoding strategy to be used. Defaults to `.default`.
	public init(_ encoder: any ValueEncoder<Target>, strategy: EncodingStrategy = .default) {
		self.init(strategy: strategy) {
			try encoder.encode($0)
		}
	}

	/// Encodes a value of a specific `Encodable` type into the `Target` format.
	///
	/// - Parameter value: The value to encode.
	/// - Returns: The encoded value in the `Target` format.
	/// - Throws: An error if encoding fails.
	@_disfavoredOverload
	public func encode<T: Encodable>(_ value: T) throws -> Target {
		try encode(value)
	}

	/// Encodes a value that conforms to the `Encodable` protocol into the `Target` format.
	///
	/// - Parameter value: The value to encode.
	/// - Returns: The encoded value in the `Target` format.
	/// - Throws: An error if encoding fails.
	public func encode(_ value: any Encodable) throws -> Target {
		try _encode(EncoderIntrospect(value: value, strategy: strategy))
	}
}

@available(*, deprecated, renamed: "EncoderDecorator")
public typealias EncoderProxy<Target> = EncoderDecorator<Target>
