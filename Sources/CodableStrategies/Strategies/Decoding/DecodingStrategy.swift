import Foundation

/// `DecodingStrategy` represents a custom approach or method used to decode values from an encoded format.
///
/// This struct provides a way to specify customized decoding behaviors for specific data types or structures. By employing different decoding strategies, you can adjust the decoding process to accommodate various data formats, special requirements, or to handle potential discrepancies in the encoded data.
///
/// Use this struct in conjunction with decoders that support custom strategies to gain finer control over the decoding process.
public struct DecodingStrategy {

	let genericDecoderStrategy: any GenericTypeDecodingStrategy
	let decodeNil: ((Decoder, () throws -> Swift.Bool) throws -> Swift.Bool)
	let decodeKey: ((Swift.String) -> Swift.String)

	init(
		decodeNil: @escaping (Decoder, () throws -> Swift.Bool) throws -> Swift.Bool = { _, decode in try decode() },
		genericDecoderStrategy: any GenericTypeDecodingStrategy = EmptyGenericDecodingStrategy(),
		decodeKey: @escaping (Swift.String) -> Swift.String = { key in key }
	) {
		self.decodeNil = decodeNil
		self.genericDecoderStrategy = genericDecoderStrategy
		self.decodeKey = decodeKey
	}

	public func decode<T: Decodable>(_ type: T.Type, from decoder: Decoder, defaultDecoding decoding: () throws -> T) throws -> T {
		try genericDecoderStrategy.decode(from: decoder, defaultDecoding: decoding)
	}

	public func decodeIfPresent<T: Decodable>(_ type: T.Type, from decoder: Decoder, isPresent: Swift.Bool, defaultDecoding decoding: () throws -> T?) throws -> T? {
		try genericDecoderStrategy.decodeIfPresent(from: decoder, isPresent: isPresent, defaultDecoding: decoding)
	}
}

public protocol GenericTypeDecodingStrategyConvertable {
	
	var asGenericDecodingStrategy: GenericTypeDecodingStrategy { get }
}

public protocol GenericTypeDecodingStrategy: GenericTypeDecodingStrategyConvertable {

	func decode<T: Decodable>(from decoder: Decoder, defaultDecoding: () throws -> T) throws -> T
	func decodeIfPresent<T: Decodable>(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T?
}

extension GenericTypeDecodingStrategy {
	
	public var asGenericDecodingStrategy: any GenericTypeDecodingStrategy { self }
}

public protocol TypeDecodingStrategy<DecodedType>: GenericTypeDecodingStrategyConvertable {

	associatedtype DecodedType: Decodable

	func decode(from decoder: Decoder, defaultDecoding: () throws -> DecodedType) throws -> DecodedType
	func decodeIfPresent(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType?
}

extension TypeDecodingStrategy {

	public var asGenericDecodingStrategy: any GenericTypeDecodingStrategy {
		AnyGenericTypeDecodingStrategy(self)
	}
}

extension TypeDecodingStrategy {

	public var typeID: ObjectIdentifier {
		ObjectIdentifier(DecodedType.self)
	}

	public func decodeIfPresent(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType? {
		try defaultDecodingIfPresent(
			from: decoder,
			isPresent: isPresent,
			defaultDecoding: defaultDecoding,
			decoding: decode
		)
	}
}

public struct AnyTypeDecodingStrategy<DecodedType: Decodable>: TypeDecodingStrategy {
	
	private let decodeClosure: (Decoder, () throws -> DecodedType) throws -> DecodedType
	private let decodeIfPresentClosure: (Decoder, Bool, () throws -> DecodedType?) throws -> DecodedType?

	public init(
		_ strategy: any TypeDecodingStrategy<DecodedType>
	) {
		self.decodeClosure = strategy.decode
		self.decodeIfPresentClosure = strategy.decodeIfPresent
	}

	public init(decode: @escaping (Decoder, () throws -> DecodedType) throws -> DecodedType) {
		self.decodeClosure = decode
		self.decodeIfPresentClosure = { decoder, isPresent, defaultDecoding in
			try defaultDecodingIfPresent(
				from: decoder,
				isPresent: isPresent,
				defaultDecoding: defaultDecoding,
				decoding: decode
			)
		}
	}

	public init(
		decode: @escaping (Decoder, () throws -> DecodedType) throws -> DecodedType,
		decodeIfPresent: @escaping (Decoder, Bool, () throws -> DecodedType?
	) throws -> DecodedType?) {
		self.decodeClosure = decode
		self.decodeIfPresentClosure = decodeIfPresent
	}
	
	public func decode(from decoder: Decoder, defaultDecoding: () throws -> DecodedType) throws -> DecodedType {
		try decodeClosure(decoder, defaultDecoding)
	}
	
	public func decodeIfPresent(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType? {
		try decodeIfPresentClosure(decoder, isPresent, defaultDecoding)
	}
}

public struct EmptyTypeDecodingStrategy<DecodedType: Decodable>: TypeDecodingStrategy {
	
	public init() {}

	public func decode(from decoder: Decoder, defaultDecoding: () throws -> DecodedType) throws -> DecodedType {
		try defaultDecoding()
	}

	public func decodeIfPresent(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType? {
		if isPresent {
			return try defaultDecoding()
		} else {
			return nil
		}
	}
}

public struct ManyTypeDecodingStrategies<DecodedType: Decodable>: TypeDecodingStrategy {

	public let base: [AnyTypeDecodingStrategy<DecodedType>]

	public init(
		_ base: [AnyTypeDecodingStrategy<DecodedType>]
	) {
		self.base = base
	}

	@_disfavoredOverload
	public init(
		_ first: any TypeDecodingStrategy<DecodedType>,
		_ second: any TypeDecodingStrategy<DecodedType>
	) {
		self.init([AnyTypeDecodingStrategy(first), AnyTypeDecodingStrategy(second)])
	}
	
	@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
	public init(
		_ base: any TypeDecodingStrategy<DecodedType>...
	) {
		self.init(base.map { AnyTypeDecodingStrategy($0) })
	}

	public func decode(from decoder: Decoder, defaultDecoding: () throws -> DecodedType) throws -> DecodedType {
		try decode(i: 0, from: decoder, defaultDecoding: defaultDecoding)
	}

	public func decodeIfPresent(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType? {
		try decodeIfPresent(i: 0, isPresent: isPresent, from: decoder, defaultDecoding: defaultDecoding)
	}

	private func decode(i: Int, from decoder: Decoder, defaultDecoding: () throws -> DecodedType) throws -> DecodedType {
		guard base.indices.contains(i) else {
			return try defaultDecoding()
		}
		return try base[i].decode(from: decoder) {
			try decode(i: i + 1, from: decoder, defaultDecoding: defaultDecoding)
		}
	}

	private func decodeIfPresent(i: Int, isPresent: Bool, from decoder: Decoder, defaultDecoding: () throws -> DecodedType?) throws -> DecodedType? {
		guard base.indices.contains(i) else {
			return try defaultDecoding()
		}
		return try base[i].decodeIfPresent(from: decoder, isPresent: isPresent) {
			 try decodeIfPresent(i: i + 1, isPresent: isPresent, from: decoder, defaultDecoding: defaultDecoding)
		 }
	}
}

public struct AnyGenericTypeDecodingStrategy: GenericTypeDecodingStrategy {
	
	private let decodeClosure: (Decodable.Type, Decoder, () throws -> Decodable) throws -> Decodable
	private let decodeIfPresentClosure: (Decodable.Type, Decoder, Bool, () throws -> Decodable?) throws -> Decodable?
	
	public init<T: Decodable>(
		_ strategy: any TypeDecodingStrategy<T>
	) {
		self.decodeClosure = { type, decoder, defaultDecoding in
			guard type is T.Type else {
				return try defaultDecoding()
			}
			return try strategy.decode(from: decoder) {
				let value = try defaultDecoding()
				guard let result = value as? T else {
					throw DecodingError.typeMismatch(
						T.self,
						DecodingError.Context(
							codingPath: decoder.codingPath,
							debugDescription: "Expected type \(T.self), but got \(Swift.type(of: value))."
						)
					)
				}
				return result
			}
		}
		self.decodeIfPresentClosure = { type, decoder, isPresent, defaultDecoding in
			guard type is T.Type else {
				return try defaultDecoding()
			}
			return try strategy.decodeIfPresent(from: decoder, isPresent: isPresent) {
				let value = try defaultDecoding()
				if let value {
					guard let result = value as? T else {
						throw DecodingError.typeMismatch(
							T.self,
							DecodingError.Context(
								codingPath: decoder.codingPath,
								debugDescription: "Expected type \(T.self), but got \(Swift.type(of: value))."
							)
						)
					}
					return result
				} else {
					return nil
				}
			}
		}
	}

	public func decode<T: Decodable>(from decoder: Decoder, defaultDecoding: () throws -> T) throws -> T {
		let value = try decodeClosure(T.self, decoder, defaultDecoding)
		guard let result = value as? T else {
			throw DecodingError.typeMismatch(
				T.self,
				DecodingError.Context(
					codingPath: decoder.codingPath,
					debugDescription: "Expected type \(T.self), but got \(type(of: value))."
				)
			)
		}
		return result
	}

	public func decodeIfPresent<T: Decodable>(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T? {
		let value = try decodeIfPresentClosure(T.self, decoder, isPresent, defaultDecoding)
		if let value {
			guard let result = value as? T else {
				throw DecodingError.typeMismatch(
					T.self,
					DecodingError.Context(
						codingPath: decoder.codingPath,
						debugDescription: "Expected type \(T.self), but got \(type(of: value))."
					)
				)
			}
			return result
		} else {
			return nil
		}
	}
}

extension GenericTypeDecodingStrategy {

	public func decodeIfPresent<T: Decodable>(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T? {
		try defaultDecodingIfPresent(
			from: decoder,
			isPresent: isPresent,
			defaultDecoding: defaultDecoding,
			decoding: decode
		)
	}
}

public struct EmptyGenericDecodingStrategy: GenericTypeDecodingStrategy {

	public init() {}

	public func decode<T: Decodable>(from decoder: Decoder, defaultDecoding: () throws -> T) throws -> T {
		try defaultDecoding()
	}

	public func decodeIfPresent<T: Decodable>(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T? {
		try defaultDecoding()
	}
}

private func defaultDecodingIfPresent<T: Decodable>(
		from decoder: Decoder,
		isPresent: Bool,
		defaultDecoding: () throws -> T?,
		decoding: (Decoder, () throws -> T) throws -> T
) throws -> T? {
	if isPresent {
		let closure = defaultDecoding
		return try decoding(decoder) {
			guard let result = try closure() else {
				throw DecodingError.dataCorrupted(
					DecodingError.Context(
						codingPath: decoder.codingPath,
						debugDescription: "No value present for \(T.self)"
					)
				)
			}
			return result
		}
	} else {
		return nil
	}
}

public struct ManyGenericTypeDecodingStrategies: GenericTypeDecodingStrategy {

	public let base: [any GenericTypeDecodingStrategy]

	public init(
		_ base: [any GenericTypeDecodingStrategy]
	) {
		self.base = base
	}
	
	public init(
		_ base: any GenericTypeDecodingStrategy...
	) {
		self.init(base)
	}

	public func decode<T: Decodable>(from decoder: Decoder, defaultDecoding: () throws -> T) throws -> T {
		try decode(i: 0, from: decoder, defaultDecoding: defaultDecoding)
	}

	public func decodeIfPresent<T: Decodable>(from decoder: Decoder, isPresent: Bool, defaultDecoding: () throws -> T?) throws -> T? {
		try decodeIfPresent(i: 0, isPresent: isPresent, from: decoder, defaultDecoding: defaultDecoding)
	}

	private func decode<T: Decodable>(i: Int, from decoder: Decoder, defaultDecoding: () throws -> T) throws -> T {
		guard base.indices.contains(i) else {
			return try defaultDecoding()
		}
		return try base[i].decode(from: decoder) {
			try decode(i: i + 1, from: decoder, defaultDecoding: defaultDecoding)
		}
	}

	private func decodeIfPresent<T: Decodable>(i: Int, isPresent: Bool, from decoder: Decoder, defaultDecoding: () throws -> T?) throws -> T? {
		guard base.indices.contains(i) else {
			return try defaultDecoding()
		}
		return try base[i].decodeIfPresent(from: decoder, isPresent: isPresent) {
			 try decodeIfPresent(i: i + 1, isPresent: isPresent, from: decoder, defaultDecoding: defaultDecoding)
		 }
	}
}

public extension DecodingStrategy {

	/// Initializes a decoding strategy to handle `nil` values.
	init(nil decode: @escaping (Decoder) throws -> Swift.Bool) {
		self.init(decodeNil: { decoder, defaultDecoding in
			do {
				return try decode(decoder)
			} catch {
				return try defaultDecoding()
			}
		})
	}

	init(_ first: any GenericTypeDecodingStrategyConvertable, _ rest: any GenericTypeDecodingStrategyConvertable...) {
		self.init(
			genericDecoderStrategy: ManyGenericTypeDecodingStrategies(
				[first.asGenericDecodingStrategy] + rest.map(\.asGenericDecodingStrategy)
			)
		)
	}

	/// Initializes a generic decoding strategy for specific `Decodable` types.
	init<T: Decodable>(
		_ type: T.Type,
		decode: @escaping (Decoder) throws -> T
	) {
		self.init(
			AnyTypeDecodingStrategy<T> { decoder, defaultDecoding in
				do {
					return try decode(decoder)
				} catch {
					return try defaultDecoding()
				}
			}
		)
	}

	/// Initializes a generic decoding strategy for handling `nil` values for specific `Decodable` types.
	/// - Parameters:
	///   - type: The type to decode when it's `nil`.
	///   - decode: A closure that decodes the given type.
	init<T: Decodable>(
		ifPresent type: T.Type,
		decode: @escaping (Decoder, Swift.Bool) throws -> T?
	) {
		self.init(
			AnyTypeDecodingStrategy<T> { _, defaultDecoding in
				try defaultDecoding()
			} decodeIfPresent: { decoder, isPresent, defaultDecoding in
				do {
					return try decode(decoder, isPresent)
				} catch {
					return try defaultDecoding()
				}
			}
		)
	}

	/// Merges the current decoding strategy with another, producing a new `DecodingStrategy`.
	/// In the event of conflicts between the two strategies, the strategy from the `other` parameter takes precedence.
	///
	/// - Warning: If multiple strategies are specified for the same type, all of them will be attempted in the order they are provided.
	/// - Parameter other: The `DecodingStrategy` to merge with.
	/// - Returns: A new merged `DecodingStrategy`.
	func merging(with other: DecodingStrategy) -> DecodingStrategy {
		DecodingStrategy(
			decodeNil: { [first = decodeNil, second = other.decodeNil] decoder, defaultDecoding in
				try first(decoder) {
					try second(decoder, defaultDecoding)
				}
			},
			genericDecoderStrategy: ManyGenericTypeDecodingStrategies(
				genericDecoderStrategy,
				other.genericDecoderStrategy
			),
			decodeKey: { [first = decodeKey, second = other.decodeKey] key in
				second(first(key))
			}
		)
	}
}

extension DecodingStrategy: ExpressibleByArrayLiteral {

	@_disfavoredOverload
	public init(arrayLiteral elements: DecodingStrategy...) {
		self = elements.reduce(DecodingStrategy()) { $0.merging(with: $1) }
	}
}

public extension DecodingStrategy {

	static var `default`: DecodingStrategy = [.Date.default, .URL.default, .Decimal.default]
}
