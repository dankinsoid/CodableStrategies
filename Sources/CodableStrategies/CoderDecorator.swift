import Foundation

public struct CoderDecorator<SourceTarget>: ValueDecoder, ValueEncoder {

	public typealias Source = SourceTarget
	public typealias Target = SourceTarget

	public let encoder: EncoderDecorator<SourceTarget>
	public let decoder: DecoderDecorator<SourceTarget>

	public init(
		decoder: DecoderDecorator<SourceTarget>,
		encoder: EncoderDecorator<SourceTarget>
	) {
		self.decoder = decoder
		self.encoder = encoder
	}

	@_disfavoredOverload
	public init(
		decoder: any ValueDecoder<SourceTarget>,
		encoder: any ValueEncoder<SourceTarget>,
		strategy: CodingStrategy = .default
	) {
		self.init(
			decoder: DecoderDecorator(decoder, strategy: strategy.decoding),
			encoder: EncoderDecorator(encoder, strategy: strategy.encoding)
		)
	}

	public func decode<T>(_ type: T.Type, from source: SourceTarget) throws -> T where T: Decodable {
		try decode(from: source)
	}

	public func decode<T>(from source: SourceTarget) throws -> T where T: Decodable {
		try decoder.decode(from: source)
	}

	@_disfavoredOverload
	public func encode<T: Encodable>(_ value: T) throws -> SourceTarget {
		try encode(value)
	}

	public func encode(_ value: any Encodable) throws -> SourceTarget {
		try encoder.encode(value)
	}
}

public typealias ValueCoder<SourceTarget> = ValueDecoder<SourceTarget> & ValueEncoder<SourceTarget>

@available(*, deprecated, renamed: "CoderDecorator")
public typealias CoderProxy<SourceTarget> = CoderDecorator<SourceTarget>
