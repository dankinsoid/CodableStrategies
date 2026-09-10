import Foundation

public extension EncodingStrategy {

	/// Optional encoding strategies scope.
	enum Optional {}
}

public extension EncodingStrategy.Optional {

	/// Encodes `nil` if value is missed.
	static var null: EncodingStrategy {
		EncodingStrategy(
			encodeBoolIfNil: { try $0.encodeNil() },
			encodeStringIfNil: { try $0.encodeNil() },
			encodeDoubleIfNil: { try $0.encodeNil() },
			encodeFloatIfNil: { try $0.encodeNil() },
			encodeIntIfNil: { try $0.encodeNil() },
			encodeInt8IfNil: { try $0.encodeNil() },
			encodeInt16IfNil: { try $0.encodeNil() },
			encodeInt32IfNil: { try $0.encodeNil() },
			encodeInt64IfNil: { try $0.encodeNil() },
			encodeUIntIfNil: { try $0.encodeNil() },
			encodeUInt8IfNil: { try $0.encodeNil() },
			encodeUInt16IfNil: { try $0.encodeNil() },
			encodeUInt32IfNil: { try $0.encodeNil() },
			encodeUInt64IfNil: { try $0.encodeNil() },
			encodeEncodableIfNil: { _, encoder in try encoder.encodeNil(); return true }
		)
	}
}

private extension Encoder {

	@inline(__always)
	func encodeNil() throws {
		var container = singleValueContainer()
		try container.encodeNil()
	}
}
