import Foundation

/// `EncodingStrategy` provides a mechanism to customize the behavior of encoders at the level of individual value types.
///
/// This struct allows developers to create tailored encoding behaviors for specific data types, ensuring data is serialized in the desired format or structure.
public struct EncodingStrategy {

	let encodeNil: ((_ value: Swift.Void, Encoder) throws -> Void)?
	let encodeBool: ((_ value: Swift.Bool, Encoder) throws -> Void)?
	let encodeString: ((_ value: Swift.String, Encoder) throws -> Void)?
	let encodeDouble: ((_ value: Swift.Double, Encoder) throws -> Void)?
	let encodeFloat: ((_ value: Swift.Float, Encoder) throws -> Void)?
	let encodeInt: ((_ value: Swift.Int, Encoder) throws -> Void)?
	let encodeInt8: ((_ value: Swift.Int8, Encoder) throws -> Void)?
	let encodeInt16: ((_ value: Swift.Int16, Encoder) throws -> Void)?
	let encodeInt32: ((_ value: Swift.Int32, Encoder) throws -> Void)?
	let encodeInt64: ((_ value: Swift.Int64, Encoder) throws -> Void)?
	let encodeUInt: ((_ value: Swift.UInt, Encoder) throws -> Void)?
	let encodeUInt8: ((_ value: Swift.UInt8, Encoder) throws -> Void)?
	let encodeUInt16: ((_ value: Swift.UInt16, Encoder) throws -> Void)?
	let encodeUInt32: ((_ value: Swift.UInt32, Encoder) throws -> Void)?
	let encodeUInt64: ((_ value: Swift.UInt64, Encoder) throws -> Void)?
	let encodeEncodable: ((_ value: Encodable, Encoder) throws -> Swift.Bool)?

	let encodeBoolIfNil: ((Encoder) throws -> Void)?
	let encodeStringIfNil: ((Encoder) throws -> Void)?
	let encodeDoubleIfNil: ((Encoder) throws -> Void)?
	let encodeFloatIfNil: ((Encoder) throws -> Void)?
	let encodeIntIfNil: ((Encoder) throws -> Void)?
	let encodeInt8IfNil: ((Encoder) throws -> Void)?
	let encodeInt16IfNil: ((Encoder) throws -> Void)?
	let encodeInt32IfNil: ((Encoder) throws -> Void)?
	let encodeInt64IfNil: ((Encoder) throws -> Void)?
	let encodeUIntIfNil: ((Encoder) throws -> Void)?
	let encodeUInt8IfNil: ((Encoder) throws -> Void)?
	let encodeUInt16IfNil: ((Encoder) throws -> Void)?
	let encodeUInt32IfNil: ((Encoder) throws -> Void)?
	let encodeUInt64IfNil: ((Encoder) throws -> Void)?
	let encodeEncodableIfNil: ((Encodable.Type, Encoder) throws -> Swift.Bool)?

	let encodeKey: ((String) -> String)?

	init(
		encodeNil: ((Void, Encoder) throws -> Void)? = nil,
		encodeBool: ((Swift.Bool, Encoder) throws -> Void)? = nil,
		encodeString: ((Swift.String, Encoder) throws -> Void)? = nil,
		encodeDouble: ((Swift.Double, Encoder) throws -> Void)? = nil,
		encodeFloat: ((Swift.Float, Encoder) throws -> Void)? = nil,
		encodeInt: ((Swift.Int, Encoder) throws -> Void)? = nil,
		encodeInt8: ((Swift.Int8, Encoder) throws -> Void)? = nil,
		encodeInt16: ((Swift.Int16, Encoder) throws -> Void)? = nil,
		encodeInt32: ((Swift.Int32, Encoder) throws -> Void)? = nil,
		encodeInt64: ((Swift.Int64, Encoder) throws -> Void)? = nil,
		encodeUInt: ((Swift.UInt, Encoder) throws -> Void)? = nil,
		encodeUInt8: ((Swift.UInt8, Encoder) throws -> Void)? = nil,
		encodeUInt16: ((Swift.UInt16, Encoder) throws -> Void)? = nil,
		encodeUInt32: ((Swift.UInt32, Encoder) throws -> Void)? = nil,
		encodeUInt64: ((Swift.UInt64, Encoder) throws -> Void)? = nil,
		encodeEncodable: ((Encodable, Encoder) throws -> Swift.Bool)? = nil,
		encodeBoolIfNil: ((Encoder) throws -> Void)? = nil,
		encodeStringIfNil: ((Encoder) throws -> Void)? = nil,
		encodeDoubleIfNil: ((Encoder) throws -> Void)? = nil,
		encodeFloatIfNil: ((Encoder) throws -> Void)? = nil,
		encodeIntIfNil: ((Encoder) throws -> Void)? = nil,
		encodeInt8IfNil: ((Encoder) throws -> Void)? = nil,
		encodeInt16IfNil: ((Encoder) throws -> Void)? = nil,
		encodeInt32IfNil: ((Encoder) throws -> Void)? = nil,
		encodeInt64IfNil: ((Encoder) throws -> Void)? = nil,
		encodeUIntIfNil: ((Encoder) throws -> Void)? = nil,
		encodeUInt8IfNil: ((Encoder) throws -> Void)? = nil,
		encodeUInt16IfNil: ((Encoder) throws -> Void)? = nil,
		encodeUInt32IfNil: ((Encoder) throws -> Void)? = nil,
		encodeUInt64IfNil: ((Encoder) throws -> Void)? = nil,
		encodeEncodableIfNil: ((Encodable.Type, Encoder) throws -> Swift.Bool)? = nil,
		encodeKey: ((Swift.String) -> Swift.String)? = nil
	) {
		self.encodeNil = encodeNil
		self.encodeBool = encodeBool
		self.encodeString = encodeString
		self.encodeDouble = encodeDouble
		self.encodeFloat = encodeFloat
		self.encodeInt = encodeInt
		self.encodeInt8 = encodeInt8
		self.encodeInt16 = encodeInt16
		self.encodeInt32 = encodeInt32
		self.encodeInt64 = encodeInt64
		self.encodeUInt = encodeUInt
		self.encodeUInt8 = encodeUInt8
		self.encodeUInt16 = encodeUInt16
		self.encodeUInt32 = encodeUInt32
		self.encodeUInt64 = encodeUInt64
		self.encodeEncodable = encodeEncodable
		self.encodeBoolIfNil = encodeBoolIfNil
		self.encodeStringIfNil = encodeStringIfNil
		self.encodeDoubleIfNil = encodeDoubleIfNil
		self.encodeFloatIfNil = encodeFloatIfNil
		self.encodeIntIfNil = encodeIntIfNil
		self.encodeInt8IfNil = encodeInt8IfNil
		self.encodeInt16IfNil = encodeInt16IfNil
		self.encodeInt32IfNil = encodeInt32IfNil
		self.encodeInt64IfNil = encodeInt64IfNil
		self.encodeUIntIfNil = encodeUIntIfNil
		self.encodeUInt8IfNil = encodeUInt8IfNil
		self.encodeUInt16IfNil = encodeUInt16IfNil
		self.encodeUInt32IfNil = encodeUInt32IfNil
		self.encodeUInt64IfNil = encodeUInt64IfNil
		self.encodeEncodableIfNil = encodeEncodableIfNil
		self.encodeKey = encodeKey
	}
}

public extension EncodingStrategy {

	/// Initializes an encoding strategy for representing any nil value.
	init(nil encode: @escaping (Encoder) throws -> Void) { self.init(encodeNil: { _, encoder in try encode(encoder) }) }
	/// Initializes an encoding strategy for representing a boolean value.
	init(_ type: Swift.Bool.Type, encode: @escaping (_ value: Swift.Bool, Encoder) throws -> Void) { self.init(encodeBool: encode) }
	/// Initializes an encoding strategy for representing a string value.
	init(_ type: Swift.String.Type, encode: @escaping (_ value: Swift.String, Encoder) throws -> Void) { self.init(encodeString: encode) }
	/// Initializes an encoding strategy for representing a double value.
	init(_ type: Swift.Double.Type, encode: @escaping (_ value: Swift.Double, Encoder) throws -> Void) { self.init(encodeDouble: encode) }
	/// Initializes an encoding strategy for representing a float value.
	init(_ type: Swift.Float.Type, encode: @escaping (_ value: Swift.Float, Encoder) throws -> Void) { self.init(encodeFloat: encode) }
	/// Initializes an encoding strategy for representing an int value.
	init(_ type: Swift.Int.Type, encode: @escaping (_ value: Swift.Int, Encoder) throws -> Void) { self.init(encodeInt: encode) }
	/// Initializes an encoding strategy for representing an int8 value.
	init(_ type: Swift.Int8.Type, encode: @escaping (_ value: Swift.Int8, Encoder) throws -> Void) { self.init(encodeInt8: encode) }
	/// Initializes an encoding strategy for representing an int16 value.
	init(_ type: Swift.Int16.Type, encode: @escaping (_ value: Swift.Int16, Encoder) throws -> Void) { self.init(encodeInt16: encode) }
	/// Initializes an encoding strategy for representing an int32 value.
	init(_ type: Swift.Int32.Type, encode: @escaping (_ value: Swift.Int32, Encoder) throws -> Void) { self.init(encodeInt32: encode) }
	/// Initializes an encoding strategy for representing an int64 value.
	init(_ type: Swift.Int64.Type, encode: @escaping (_ value: Swift.Int64, Encoder) throws -> Void) { self.init(encodeInt64: encode) }
	/// Initializes an encoding strategy for representing an uint value.
	init(_ type: Swift.UInt.Type, encode: @escaping (_ value: Swift.UInt, Encoder) throws -> Void) { self.init(encodeUInt: encode) }
	/// Initializes an encoding strategy for representing an uint8 value.
	init(_ type: Swift.UInt8.Type, encode: @escaping (_ value: Swift.UInt8, Encoder) throws -> Void) { self.init(encodeUInt8: encode) }
	/// Initializes an encoding strategy for representing an uint16 value.
	init(_ type: Swift.UInt16.Type, encode: @escaping (_ value: Swift.UInt16, Encoder) throws -> Void) { self.init(encodeUInt16: encode) }
	/// Initializes an encoding strategy for representing an uint32 value.
	init(_ type: Swift.UInt32.Type, encode: @escaping (_ value: Swift.UInt32, Encoder) throws -> Void) { self.init(encodeUInt32: encode) }
	/// Initializes an encoding strategy for representing an uint64 value.
	init(_ type: Swift.UInt64.Type, encode: @escaping (_ value: Swift.UInt64, Encoder) throws -> Void) { self.init(encodeUInt64: encode) }
	/// Initializes an encoding strategy using a custom encoding closure.
	///
	/// The provided closure allows you to define a custom encoding behavior for the provided `Encodable` value. If the closure doesn't handle encoding for the given type or instance, it should return `false` to indicate that the default encoding behavior should be used.
	init(encode: @escaping (_ value: Encodable, Encoder) throws -> Swift.Bool) { self.init(encodeEncodable: encode) }

	/// Initializes an encoding strategy for a specific encodable type.
	init<T: Encodable>(
		_ type: T.Type,
		encode: @escaping (_ value: T, Encoder) throws -> Void
	) {
		self.init(
			encodeEncodable: {
				guard let value = $0 as? T else {
					return false
				}
				try encode(value, $1)
				return true
			}
		)
	}

	/// Initializes an encoding strategy to represent a nil value for a boolean type.
	init(ifNil type: Swift.Bool.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeBoolIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for a string type.
	init(ifNil type: Swift.String.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeStringIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for a double type.
	init(ifNil type: Swift.Double.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeDoubleIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for a float type.
	init(ifNil type: Swift.Float.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeFloatIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an int type.
	init(ifNil type: Swift.Int.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeIntIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an int8 type.
	init(ifNil type: Swift.Int8.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeInt8IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an int16 type.
	init(ifNil type: Swift.Int16.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeInt16IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an int32 type.
	init(ifNil type: Swift.Int32.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeInt32IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an int64 type.
	init(ifNil type: Swift.Int64.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeInt64IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an uint type.
	init(ifNil type: Swift.UInt.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeUIntIfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an uint8 type.
	init(ifNil type: Swift.UInt8.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeUInt8IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an uint16 type.
	init(ifNil type: Swift.UInt16.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeUInt16IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an uint32 type.
	init(ifNil type: Swift.UInt32.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeUInt32IfNil: encode) }
	/// Initializes an encoding strategy to represent a nil value for an uint64 type.
	init(ifNil type: Swift.UInt64.Type, encode: @escaping (Encoder) throws -> Void) { self.init(encodeUInt64IfNil: encode) }
	/// Initializes an encoding strategy using a custom encoding closure.
	///
	/// The provided closure allows you to define a custom encoding behavior for the provided nil value. If the closure doesn't handle encoding for the given type or instance, it should return `false` to indicate that the default encoding behavior should be used.
	init(encodeIfNil: @escaping (Encodable.Type, Encoder) throws -> Swift.Bool) { self.init(encodeEncodableIfNil: encodeIfNil) }

	/// Initializes an encoding strategy to represent a nil value for a specific type.
	init<T: Encodable>(
		ifNil type: T.Type,
		encode: @escaping (Encoder) throws -> Void
	) {
		self.init(
			encodeEncodableIfNil: {
				guard $0 is T.Type else {
					return false
				}
				try encode($1)
				return true
			}
		)
	}

	/// Merges the current encoding strategy with another one, producing a combined result.
	///
	/// This function allows developers to compose complex encoding strategies by layering multiple strategies together. In the event of overlapping configuration, the strategy from the `other` parameter takes precedence.
	///
	/// - Warning: In the event of overlapping or conflicting configurations, the strategy from the incoming `other` parameter takes precedence. This means if two strategies address the same type or condition, the last one provided (from `other`) will be applied.
	///
	/// - Parameter other: The other encoding strategy to be merged.
	/// - Returns: A new `EncodingStrategy` that combines the configurations of the current and provided strategies.
	func merging(with other: EncodingStrategy) -> EncodingStrategy {
		EncodingStrategy(
			encodeNil: other.encodeNil ?? encodeNil,
			encodeBool: other.encodeBool ?? encodeBool,
			encodeString: other.encodeString ?? encodeString,
			encodeDouble: other.encodeDouble ?? encodeDouble,
			encodeFloat: other.encodeFloat ?? encodeFloat,
			encodeInt: other.encodeInt ?? encodeInt,
			encodeInt8: other.encodeInt8 ?? encodeInt8,
			encodeInt16: other.encodeInt16 ?? encodeInt16,
			encodeInt32: other.encodeInt32 ?? encodeInt32,
			encodeInt64: other.encodeInt64 ?? encodeInt64,
			encodeUInt: other.encodeUInt ?? encodeUInt,
			encodeUInt8: other.encodeUInt8 ?? encodeUInt8,
			encodeUInt16: other.encodeUInt16 ?? encodeUInt16,
			encodeUInt32: other.encodeUInt32 ?? encodeUInt32,
			encodeUInt64: other.encodeUInt64 ?? encodeUInt64,
			encodeEncodable: other.encodeEncodable.map { encodeEncodable in
				{
					if try encodeEncodable($0, $1) {
						return true
					}
					if let encode = self.encodeEncodable {
						return try encode($0, $1)
					}
					return false
				}
			} ?? encodeEncodable,
			encodeBoolIfNil: other.encodeBoolIfNil ?? encodeBoolIfNil,
			encodeStringIfNil: other.encodeStringIfNil ?? encodeStringIfNil,
			encodeDoubleIfNil: other.encodeDoubleIfNil ?? encodeDoubleIfNil,
			encodeFloatIfNil: other.encodeFloatIfNil ?? encodeFloatIfNil,
			encodeIntIfNil: other.encodeIntIfNil ?? encodeIntIfNil,
			encodeInt8IfNil: other.encodeInt8IfNil ?? encodeInt8IfNil,
			encodeInt16IfNil: other.encodeInt16IfNil ?? encodeInt16IfNil,
			encodeInt32IfNil: other.encodeInt32IfNil ?? encodeInt32IfNil,
			encodeInt64IfNil: other.encodeInt64IfNil ?? encodeInt64IfNil,
			encodeUIntIfNil: other.encodeUIntIfNil ?? encodeUIntIfNil,
			encodeUInt8IfNil: other.encodeUInt8IfNil ?? encodeUInt8IfNil,
			encodeUInt16IfNil: other.encodeUInt16IfNil ?? encodeUInt16IfNil,
			encodeUInt32IfNil: other.encodeUInt32IfNil ?? encodeUInt32IfNil,
			encodeUInt64IfNil: other.encodeUInt64IfNil ?? encodeUInt64IfNil,
			encodeEncodableIfNil: other.encodeEncodableIfNil.map { encodeEncodableIfNil in
				{
					if try encodeEncodableIfNil($0, $1) {
						return true
					}
					if let encode = self.encodeEncodableIfNil {
						return try encode($0, $1)
					}
					return false
				}
			} ?? encodeEncodableIfNil,
			encodeKey: other.encodeKey ?? encodeKey
		)
	}
}

extension EncodingStrategy: ExpressibleByArrayLiteral {

	@_disfavoredOverload
	public init(arrayLiteral elements: EncodingStrategy...) {
		self = elements.reduce(EncodingStrategy()) { $0.merging(with: $1) }
	}
}

public extension EncodingStrategy {

	static var `default`: EncodingStrategy = [.Date.default, .URL.default, .Decimal.default]
}
