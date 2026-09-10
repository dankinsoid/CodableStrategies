import Foundation

struct DecoderIntrospect<Value: Decodable>: Decodable {

	let value: Value

	init(_ value: Value) {
		self.value = value
	}

	init(from decoder: Decoder) throws {
		let decoderWrapper = DecoderWrapper(decoder, strategy: .current)
		value = try decoderWrapper.decode(Value.self) {
			try Value(from: decoderWrapper)
		}
	}
}

private var _strategy: DecodingStrategy = .default
private var _ignoreStrategy: PartialKeyPath<DecodingStrategy>?

extension DecodingStrategy {

	static var current: DecodingStrategy {
			Thread.current.threadDictionary[ObjectIdentifier(DecodingStrategy.self)] as? DecodingStrategy ?? .default
	}

	static func withStrategy<T>(
		_ strategy: DecodingStrategy,
		operation: () throws -> T
	) rethrows -> T {
		let previousStrategy = current
		Thread.current.threadDictionary[ObjectIdentifier(DecodingStrategy.self)] = strategy
		defer {
			Thread.current.threadDictionary[ObjectIdentifier(DecodingStrategy.self)] = previousStrategy
		}
		return try operation()
	}
}
