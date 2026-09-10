import Foundation

public struct EncoderIntrospect: Encodable {

	let value: Encodable
	let strategy: EncodingStrategy

	public func encode(to encoder: Encoder) throws {
		let encoderWrapper = EncoderWrapper(encoder, strategy: strategy)
		try encoderWrapper.encode(value) { _ in
			try value.encode(to: encoderWrapper)
		}
	}
}
