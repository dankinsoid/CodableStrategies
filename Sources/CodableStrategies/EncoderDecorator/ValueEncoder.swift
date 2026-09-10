import Foundation

/// A protocol representing an entity capable of encoding values into a specified target format.
///
/// The `ValueEncoder` protocol defines a standardized approach to encode instances of `Encodable` types
/// into various target formats, enabling adaptability and interchangeability of different encoding mechanisms.
///
/// - Generic Parameter `Target`: The type of the target format into which values will be encoded.
///
/// Example usage:
/// ```
/// struct MyModel: Encodable { ... }
///
/// let model = MyModel(...)
/// let jsonData: Data = try JSONEncoder().encode(model)
///
/// let anotherModel = MyModel(...)
/// let plistData: Data = try PropertyListEncoder().encode(anotherModel)
/// ```
///
/// - Note: The `JSONEncoder` and `PropertyListEncoder` are provided with extensions
///         to conform to `ValueEncoder` for out-of-the-box utility.
public protocol ValueEncoder<Target> {

	associatedtype Target
	func encode<T: Encodable>(_ value: T) throws -> Target
}

extension JSONEncoder: ValueEncoder {}
extension PropertyListEncoder: ValueEncoder {}
