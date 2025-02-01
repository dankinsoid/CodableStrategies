import Foundation

struct DecoderWrapper: Decoder {

	let wrapped: Decoder
	let strategy: DecodingStrategy
	var codingPath: [CodingKey] { wrapped.codingPath }
	var userInfo: [CodingUserInfoKey: Any] { wrapped.userInfo }
	private var ignoreStrategy: PartialKeyPath<DecodingStrategy>?

	init(
		_ wrapped: Decoder,
		strategy: DecodingStrategy,
		ignoreStrategy: PartialKeyPath<DecodingStrategy>? = nil
	) {
		self.wrapped = wrapped
		self.strategy = strategy
		self.ignoreStrategy = ignoreStrategy
	}

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		try KeyedDecodingContainer(
			KeyedDecodingContainerWrapper(
				wrapped: wrapped.container(keyedBy: AnyCodingKey.self),
				decoder: self
			)
		)
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		try UnkeyedDecodingContainerWrapper(
			wrapped: wrapped.unkeyedContainer(),
			decoder: self
		)
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		try SingleValueDecodingContainerWrapper(
			wrapped: wrapped.singleValueContainer(),
			decoder: self
		)
	}

	@inline(__always)
	func decode<T>(
		_ type: T.Type,
		_ keyPath: KeyPath < DecodingStrategy, ((Decoder) throws -> T)?>,
		decode: () throws -> T
	) throws -> T {
		do {
			if ignoreStrategy != keyPath, let decode = strategy[keyPath: keyPath] {
				return try decode(ignoring(keyPath))
			}
		} catch let strategyError {
			do {
				return try decode()
			} catch {
				throw strategyError
			}
		}
		return try decode()
	}

	@inline(__always)
	func decode<T: Decodable>(_ type: T.Type, decode: () throws -> DecoderIntrospect<T>) throws -> T {
		do {
			if ignoreStrategy != \.decodeDecodable, let result = try strategy.decodeDecodable?(type, ignoring(\.decodeDecodable)) as? T {
				return result
			}
			DecodingStrategy.current = strategy
			DecodingStrategy.currentIgnoring = ignoreStrategy
		} catch let strategyError {
			do {
				return try decode().value
			} catch {
				throw strategyError
			}
		}
		return try decode().value
	}

	@inline(__always)
	func decodeIfPresent<T>(
		present: Bool,
		_ keyPathIfNil: KeyPath < DecodingStrategy, ((Decoder) throws -> T?)?>,
		_ keyPath: KeyPath < DecodingStrategy, ((Decoder) throws -> T)?>,
		decode: () throws -> T?
	) throws -> T? {
		do {
			if present {
				if ignoreStrategy != keyPath, let decode = strategy[keyPath: keyPath] {
					return try decode(ignoring(keyPath))
				}
			} else if ignoreStrategy != keyPathIfNil, let decode = strategy[keyPath: keyPathIfNil] {
				return try decode(ignoring(keyPathIfNil))
			}
		} catch let strategyError {
			do {
				return try decode()
			} catch {
				throw strategyError
			}
		}
		return try decode()
	}

	@inline(__always)
	func decodeIfPresent<T: Decodable>(present: Bool, decode: () throws -> DecoderIntrospect<T>?) throws -> T? {
		DecodingStrategy.current = strategy
		DecodingStrategy.currentIgnoring = ignoreStrategy
		do {
			if present {
				if ignoreStrategy != \.decodeDecodable, let decode = strategy.decodeDecodable {
					return try decode(T.self, ignoring(\.decodeDecodable)) as? T
				}
			} else if ignoreStrategy != \.decodeDecodableIfNil, let decode = strategy.decodeDecodableIfNil {
				return try decode(T.self, ignoring(\.decodeDecodableIfNil)) as? T
			}
		} catch let strategyError {
			do {
				return try decode()?.value
			} catch {
				throw strategyError
			}
		}
		return try decode()?.value
	}

	@inline(__always)
	func ignoring(_ keyPath: PartialKeyPath<DecodingStrategy>?) -> DecoderWrapper {
		var copy = self
		copy.ignoreStrategy = keyPath ?? copy.ignoreStrategy
		return copy
	}

	func child(_ wrapped: Decoder) -> DecoderWrapper {
		DecoderWrapper(
			wrapped,
			strategy: strategy,
			ignoreStrategy: ignoreStrategy
		)
	}
}

private final class KeyedDecodingContainerWrapper<Key: CodingKey>: KeyedDecodingContainerProtocol {

	var wrapped: KeyedDecodingContainer<AnyCodingKey>
	let _decoder: DecoderWrapper
	var codingPath: [CodingKey] { wrapped.codingPath }
	var allKeys: [Key] {
		wrapped.allKeys.compactMap {
			Key(stringValue: $0.stringValue)
		}
	}

	init(wrapped: KeyedDecodingContainer<AnyCodingKey>, decoder: DecoderWrapper) {
		self.wrapped = wrapped
		_decoder = decoder
	}

	func contains(_ key: Key) -> Bool {
		wrapped.contains(map(key))
	}

	func decodeNil(forKey key: Key) throws -> Bool {
		try decoder(key, \.decodeNil).decode(Bool.self, \.decodeNil) { try wrapped.decodeNil(forKey: map(key)) }
	}

	func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		try decoder(key, \.decodeBool).decode(type, \.decodeBool) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: String.Type, forKey key: Key) throws -> String {
		try decoder(key, \.decodeString).decode(type, \.decodeString) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
		try decoder(key, \.decodeDouble).decode(type, \.decodeDouble) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
		try decoder(key, \.decodeFloat).decode(type, \.decodeFloat) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		try decoder(key, \.decodeInt).decode(type, \.decodeInt) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
		try decoder(key, \.decodeInt8).decode(type, \.decodeInt8) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
		try decoder(key, \.decodeInt16).decode(type, \.decodeInt16) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
		try decoder(key, \.decodeInt32).decode(type, \.decodeInt32) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
		try decoder(key, \.decodeInt64).decode(type, \.decodeInt64) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
		try decoder(key, \.decodeUInt).decode(type, \.decodeUInt) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
		try decoder(key, \.decodeUInt8).decode(type, \.decodeUInt8) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
		try decoder(key, \.decodeUInt16).decode(type, \.decodeUInt16) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
		try decoder(key, \.decodeUInt32).decode(type, \.decodeUInt32) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
		try decoder(key, \.decodeUInt64).decode(type, \.decodeUInt64) { try wrapped.decode(type, forKey: map(key)) }
	}

	func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
		try decoder(key, \.decodeDecodable).decode(type) { try wrapped.decode(DecoderIntrospect<T>.self, forKey: map(key)) }
	}

	func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
		let anykey = map(key)
		return try decoder(key, \.decodeBoolIfNil).decodeIfPresent(present: notNil(anykey), \.decodeBoolIfNil, \.decodeBool) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
		let anykey = map(key)
		return try decoder(key, \.decodeStringIfNil).decodeIfPresent(present: notNil(anykey), \.decodeStringIfNil, \.decodeString) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
		let anykey = map(key)
		return try decoder(key, \.decodeDoubleIfNil).decodeIfPresent(present: notNil(anykey), \.decodeDoubleIfNil, \.decodeDouble) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float? {
		let anykey = map(key)
		return try decoder(key, \.decodeFloatIfNil).decodeIfPresent(present: notNil(anykey), \.decodeFloatIfNil, \.decodeFloat) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
		let anykey = map(key)
		return try decoder(key, \.decodeIntIfNil).decodeIfPresent(present: notNil(anykey), \.decodeIntIfNil, \.decodeInt) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8? {
		let anykey = map(key)
		return try decoder(key, \.decodeInt8IfNil).decodeIfPresent(present: notNil(anykey), \.decodeInt8IfNil, \.decodeInt8) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16? {
		let anykey = map(key)
		return try decoder(key, \.decodeInt16IfNil).decodeIfPresent(present: notNil(anykey), \.decodeInt16IfNil, \.decodeInt16) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32? {
		let anykey = map(key)
		return try decoder(key, \.decodeInt32IfNil).decodeIfPresent(present: notNil(anykey), \.decodeInt32IfNil, \.decodeInt32) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64? {
		let anykey = map(key)
		return try decoder(key, \.decodeInt64IfNil).decodeIfPresent(present: notNil(anykey), \.decodeInt64IfNil, \.decodeInt64) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt? {
		let anykey = map(key)
		return try decoder(key, \.decodeUIntIfNil).decodeIfPresent(present: notNil(anykey), \.decodeUIntIfNil, \.decodeUInt) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8? {
		let anykey = map(key)
		return try decoder(key, \.decodeUInt8IfNil).decodeIfPresent(present: notNil(anykey), \.decodeUInt8IfNil, \.decodeUInt8) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16? {
		let anykey = map(key)
		return try decoder(key, \.decodeUInt16IfNil).decodeIfPresent(present: notNil(anykey), \.decodeUInt16IfNil, \.decodeUInt16) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32? {
		let anykey = map(key)
		return try decoder(key, \.decodeUInt32IfNil).decodeIfPresent(present: notNil(anykey), \.decodeUInt32IfNil, \.decodeUInt32) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64? {
		let anykey = map(key)
		return try decoder(key, \.decodeUInt64IfNil).decodeIfPresent(present: notNil(anykey), \.decodeUInt64IfNil, \.decodeUInt64) {
			try wrapped.decodeIfPresent(type, forKey: anykey)
		}
	}

	func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T: Decodable {
		let anykey = map(key)
		return try decoder(key, \.decodeDecodableIfNil).decodeIfPresent(present: notNil(anykey)) {
			try wrapped.decodeIfPresent(DecoderIntrospect<T>.self, forKey: anykey)
		}
	}

	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
		try KeyedDecodingContainer<NestedKey>(
			KeyedDecodingContainerWrapper<NestedKey>(
				wrapped: wrapped.nestedContainer(keyedBy: AnyCodingKey.self, forKey: map(key)),
				decoder: decoder(key, nil)
			)
		)
	}

	func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		try UnkeyedDecodingContainerWrapper(
			wrapped: wrapped.nestedUnkeyedContainer(forKey: map(key)),
			decoder: decoder(key, nil)
		)
	}

	func superDecoder() throws -> Decoder {
		try DecoderWrapper(wrapped.superDecoder(), strategy: _decoder.strategy)
	}

	func superDecoder(forKey key: Key) throws -> Decoder {
		try DecoderWrapper(wrapped.superDecoder(forKey: map(key)), strategy: _decoder.strategy)
	}

	@inline(__always)
	private func map(_ key: any CodingKey) -> AnyCodingKey {
		AnyCodingKey(
			_decoder.strategy.decodeKey?(key.stringValue) ?? key.stringValue
		)
	}

	@inline(__always)
	private func decoder(_ key: Key, _ ignoring: PartialKeyPath<DecodingStrategy>?) -> DecoderWrapper {
		_decoder.child(
			KeyedContainerDecoder(
				key: key,
				base: KeyedDecodingContainerWrapper(
					wrapped: wrapped,
					decoder: _decoder.ignoring(ignoring)
				),
				userInfo: _decoder.userInfo
			)
		)
	}

	@inline(__always)
	private func notNil(_ key: AnyCodingKey) -> Bool {
		wrapped.contains(key) && !((try? wrapped.decodeNil(forKey: key)) ?? false)
	}
}

private final class UnkeyedDecodingContainerWrapper: UnkeyedDecodingContainer {

	var wrapped: UnkeyedDecodingContainer
	let _decoder: DecoderWrapper
	var codingPath: [CodingKey] { wrapped.codingPath }
	var isAtEnd: Bool { wrapped.isAtEnd }
	var currentIndex: Int { wrapped.currentIndex }
	var count: Int? { wrapped.count }

	init(wrapped: UnkeyedDecodingContainer, decoder: DecoderWrapper) {
		self.wrapped = wrapped
		_decoder = decoder
	}

	func decodeNil() -> Bool {
        (try? decoder(\.decodeNil) { try $0.decode(Bool.self, \.decodeNil) { try wrapped.decodeNil() } }) ?? false
	}

	func decode(_ type: Bool.Type) throws -> Bool {
        try decoder(\.decodeBool) { try $0.decode(type, \.decodeBool) { try wrapped.decode(type) } }
	}

	func decode(_ type: String.Type) throws -> String {
		try decoder(\.decodeString).decode(type, \.decodeString) { try wrapped.decode(type) }
	}

	func decode(_ type: Double.Type) throws -> Double {
		try decoder(\.decodeDouble).decode(type, \.decodeDouble) { try wrapped.decode(type) }
	}

	func decode(_ type: Float.Type) throws -> Float {
		try decoder(\.decodeFloat).decode(type, \.decodeFloat) { try wrapped.decode(type) }
	}

	func decode(_ type: Int.Type) throws -> Int {
		try decoder(\.decodeInt).decode(type, \.decodeInt) { try wrapped.decode(type) }
	}

	func decode(_ type: Int8.Type) throws -> Int8 {
		try decoder(\.decodeInt8).decode(type, \.decodeInt8) { try wrapped.decode(type) }
	}

	func decode(_ type: Int16.Type) throws -> Int16 {
		try decoder(\.decodeInt16).decode(type, \.decodeInt16) { try wrapped.decode(type) }
	}

	func decode(_ type: Int32.Type) throws -> Int32 {
		try decoder(\.decodeInt32).decode(type, \.decodeInt32) { try wrapped.decode(type) }
	}

	func decode(_ type: Int64.Type) throws -> Int64 {
		try decoder(\.decodeInt64).decode(type, \.decodeInt64) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt.Type) throws -> UInt {
		try decoder(\.decodeUInt).decode(type, \.decodeUInt) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt8.Type) throws -> UInt8 {
		try decoder(\.decodeUInt8).decode(type, \.decodeUInt8) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt16.Type) throws -> UInt16 {
		try decoder(\.decodeUInt16).decode(type, \.decodeUInt16) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt32.Type) throws -> UInt32 {
		try decoder(\.decodeUInt32).decode(type, \.decodeUInt32) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt64.Type) throws -> UInt64 {
		try decoder(\.decodeUInt64).decode(type, \.decodeUInt64) { try wrapped.decode(type) }
	}

	func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
		try decoder(\.decodeDecodable).decode(type) { try wrapped.decode(DecoderIntrospect<T>.self) }
	}

	func decodeIfPresent(_ type: Bool.Type) throws -> Bool? {
		try decoder(\.decodeBoolIfNil).decodeIfPresent(present: notNil, \.decodeBoolIfNil, \.decodeBool) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: String.Type) throws -> String? {
		try decoder(\.decodeStringIfNil).decodeIfPresent(present: notNil, \.decodeStringIfNil, \.decodeString) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Double.Type) throws -> Double? {
		try decoder(\.decodeDoubleIfNil).decodeIfPresent(present: notNil, \.decodeDoubleIfNil, \.decodeDouble) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Float.Type) throws -> Float? {
		try decoder(\.decodeFloatIfNil).decodeIfPresent(present: notNil, \.decodeFloatIfNil, \.decodeFloat) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Int.Type) throws -> Int? {
		try decoder(\.decodeIntIfNil).decodeIfPresent(present: notNil, \.decodeIntIfNil, \.decodeInt) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Int8.Type) throws -> Int8? {
		try decoder(\.decodeInt8IfNil).decodeIfPresent(present: notNil, \.decodeInt8IfNil, \.decodeInt8) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Int16.Type) throws -> Int16? {
		try decoder(\.decodeInt16IfNil).decodeIfPresent(present: notNil, \.decodeInt16IfNil, \.decodeInt16) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Int32.Type) throws -> Int32? {
		try decoder(\.decodeInt32IfNil).decodeIfPresent(present: notNil, \.decodeInt32IfNil, \.decodeInt32) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: Int64.Type) throws -> Int64? {
		try decoder(\.decodeInt64IfNil).decodeIfPresent(present: notNil, \.decodeInt64IfNil, \.decodeInt64) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: UInt.Type) throws -> UInt? {
		try decoder(\.decodeUIntIfNil).decodeIfPresent(present: notNil, \.decodeUIntIfNil, \.decodeUInt) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8? {
		try decoder(\.decodeUInt8IfNil).decodeIfPresent(present: notNil, \.decodeUInt8IfNil, \.decodeUInt8) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16? {
		try decoder(\.decodeUInt16IfNil).decodeIfPresent(present: notNil, \.decodeUInt16IfNil, \.decodeUInt16) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32? {
		try decoder(\.decodeUInt32IfNil).decodeIfPresent(present: notNil, \.decodeUInt32IfNil, \.decodeUInt32) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64? {
		try decoder(\.decodeUInt64IfNil).decodeIfPresent(present: notNil, \.decodeUInt64IfNil, \.decodeUInt64) { try wrapped.decodeIfPresent(type) }
	}

	func decodeIfPresent<T>(_: T.Type) throws -> T? where T: Decodable {
		try decoder(\.decodeDecodableIfNil).decodeIfPresent(present: notNil) { try wrapped.decodeIfPresent(DecoderIntrospect<T>.self) }
	}

	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
		try KeyedDecodingContainer(
			KeyedDecodingContainerWrapper(
				wrapped: wrapped.nestedContainer(keyedBy: AnyCodingKey.self),
				decoder: decoder(nil)
			)
		)
	}

	func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		try UnkeyedDecodingContainerWrapper(
			wrapped: wrapped.nestedUnkeyedContainer(),
			decoder: decoder(nil)
		)
	}

	func superDecoder() throws -> Decoder {
		try DecoderWrapper(wrapped.superDecoder(), strategy: _decoder.strategy)
	}

	@inline(__always)
    private func decoder<T>(_ ignoring: PartialKeyPath<DecodingStrategy>?, decode: (DecoderWrapper) throws -> T) rethrows -> T {
        try decode(
            _decoder.child(
                UnkeyedContainerDecoder(
                    base: UnkeyedDecodingContainerWrapper(
                        wrapped: wrapped,
                        decoder: _decoder.ignoring(ignoring)
                    ),
                    userInfo: _decoder.userInfo
                )
            )
        )
    }

	@inline(__always)
	private var notNil: Bool {
		!isAtEnd && !decodeNil()
	}
}

private struct SingleValueDecodingContainerWrapper: SingleValueDecodingContainer {

	var wrapped: SingleValueDecodingContainer
	let decoder: DecoderWrapper
	var codingPath: [CodingKey] { wrapped.codingPath }

	func decodeNil() -> Bool {
		(try? decoder.decode(Bool.self, \.decodeNil) { wrapped.decodeNil() }) ?? false
	}

	func decode(_ type: Bool.Type) throws -> Bool {
		try decoder.decode(type, \.decodeBool) { try wrapped.decode(type) }
	}

	func decode(_ type: String.Type) throws -> String {
		try decoder.decode(type, \.decodeString) { try wrapped.decode(type) }
	}

	func decode(_ type: Double.Type) throws -> Double {
		try decoder.decode(type, \.decodeDouble) { try wrapped.decode(type) }
	}

	func decode(_ type: Float.Type) throws -> Float {
		try decoder.decode(type, \.decodeFloat) { try wrapped.decode(type) }
	}

	func decode(_ type: Int.Type) throws -> Int {
		try decoder.decode(type, \.decodeInt) { try wrapped.decode(type) }
	}

	func decode(_ type: Int8.Type) throws -> Int8 {
		try decoder.decode(type, \.decodeInt8) { try wrapped.decode(type) }
	}

	func decode(_ type: Int16.Type) throws -> Int16 {
		try decoder.decode(type, \.decodeInt16) { try wrapped.decode(type) }
	}

	func decode(_ type: Int32.Type) throws -> Int32 {
		try decoder.decode(type, \.decodeInt32) { try wrapped.decode(type) }
	}

	func decode(_ type: Int64.Type) throws -> Int64 {
		try decoder.decode(type, \.decodeInt64) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt.Type) throws -> UInt {
		try decoder.decode(type, \.decodeUInt) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt8.Type) throws -> UInt8 {
		try decoder.decode(type, \.decodeUInt8) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt16.Type) throws -> UInt16 {
		try decoder.decode(type, \.decodeUInt16) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt32.Type) throws -> UInt32 {
		try decoder.decode(type, \.decodeUInt32) { try wrapped.decode(type) }
	}

	func decode(_ type: UInt64.Type) throws -> UInt64 {
		try decoder.decode(type, \.decodeUInt64) { try wrapped.decode(type) }
	}

	func decode<T: Decodable>(_ type: T.Type) throws -> T {
		try decoder.decode(type) {
			try wrapped.decode(DecoderIntrospect<T>.self)
		}
	}
}

private struct KeyedContainerDecoder<Key: CodingKey>: Decoder, SingleValueDecodingContainer {

	let key: Key
	let base: KeyedDecodingContainerWrapper<Key>
	let userInfo: [CodingUserInfoKey: Any]
	var codingPath: [CodingKey] { base.codingPath + [key] }

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		try base.nestedContainer(keyedBy: type, forKey: key)
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		try base.nestedUnkeyedContainer(forKey: key)
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		self
	}

	func decodeNil() -> Bool { (try? base.decodeNil(forKey: key)) ?? false }
	func decode(_ type: Bool.Type) throws -> Bool { try base.decode(type, forKey: key) }
	func decode(_ type: String.Type) throws -> String { try base.decode(type, forKey: key) }
	func decode(_ type: Double.Type) throws -> Double { try base.decode(type, forKey: key) }
	func decode(_ type: Float.Type) throws -> Float { try base.decode(type, forKey: key) }
	func decode(_ type: Int.Type) throws -> Int { try base.decode(type, forKey: key) }
	func decode(_ type: Int8.Type) throws -> Int8 { try base.decode(type, forKey: key) }
	func decode(_ type: Int16.Type) throws -> Int16 { try base.decode(type, forKey: key) }
	func decode(_ type: Int32.Type) throws -> Int32 { try base.decode(type, forKey: key) }
	func decode(_ type: Int64.Type) throws -> Int64 { try base.decode(type, forKey: key) }
	func decode(_ type: UInt.Type) throws -> UInt { try base.decode(type, forKey: key) }
	func decode(_ type: UInt8.Type) throws -> UInt8 { try base.decode(type, forKey: key) }
	func decode(_ type: UInt16.Type) throws -> UInt16 { try base.decode(type, forKey: key) }
	func decode(_ type: UInt32.Type) throws -> UInt32 { try base.decode(type, forKey: key) }
	func decode(_ type: UInt64.Type) throws -> UInt64 { try base.decode(type, forKey: key) }
	func decode<T: Decodable>(_ type: T.Type) throws -> T { try base.decode(type, forKey: key) }
}

private struct UnkeyedContainerDecoder: Decoder, SingleValueDecodingContainer {

	let base: UnkeyedDecodingContainerWrapper
	let userInfo: [CodingUserInfoKey: Any]
	var codingPath: [CodingKey] { base.codingPath + [AnyCodingKey(intValue: base.currentIndex)] }

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		try base.nestedContainer(keyedBy: type)
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		try base.nestedUnkeyedContainer()
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		self
	}

	func decodeNil() -> Bool { base.decodeNil() }
	func decode(_ type: Bool.Type) throws -> Bool { try base.decode(type) }
	func decode(_ type: String.Type) throws -> String { try base.decode(type) }
	func decode(_ type: Double.Type) throws -> Double { try base.decode(type) }
	func decode(_ type: Float.Type) throws -> Float { try base.decode(type) }
	func decode(_ type: Int.Type) throws -> Int { try base.decode(type) }
	func decode(_ type: Int8.Type) throws -> Int8 { try base.decode(type) }
	func decode(_ type: Int16.Type) throws -> Int16 { try base.decode(type) }
	func decode(_ type: Int32.Type) throws -> Int32 { try base.decode(type) }
	func decode(_ type: Int64.Type) throws -> Int64 { try base.decode(type) }
	func decode(_ type: UInt.Type) throws -> UInt { try base.decode(type) }
	func decode(_ type: UInt8.Type) throws -> UInt8 { try base.decode(type) }
	func decode(_ type: UInt16.Type) throws -> UInt16 { try base.decode(type) }
	func decode(_ type: UInt32.Type) throws -> UInt32 { try base.decode(type) }
	func decode(_ type: UInt64.Type) throws -> UInt64 { try base.decode(type) }
	func decode<T: Decodable>(_ type: T.Type) throws -> T { try base.decode(type) }
}
