import Foundation

/// A protocol representing an entity capable of decoding values from a specified source.
///
/// The `ValueDecoder` protocol allows for a standardized way to decode instances of `Decodable` types
/// from various sources, facilitating the adaptability and interchangeability of different decoding mechanisms.
///
/// - Generic Parameter `Source`: The type of the source from which values will be decoded.
///
/// Example usage:
/// ```
/// struct MyModel: Decodable { ... }
///
/// let jsonData: Data = ...
/// let model: MyModel = try JSONDecoder().decode(MyModel.self, from: jsonData)
///
/// let plistData: Data = ...
/// let anotherModel: MyModel = try PropertyListDecoder().decode(MyModel.self, from: plistData)
/// ```
///
/// - Note: The `JSONDecoder` and `PropertyListDecoder` are provided with extensions
///         to conform to `ValueDecoder` for out-of-the-box utility.
public protocol ValueDecoder<Source> {

	associatedtype Source
	func decode<T: Decodable>(_ type: T.Type, from source: Source) throws -> T
}

extension JSONDecoder: ValueDecoder {}
extension PropertyListDecoder: ValueDecoder {}
