@testable import CodableStrategies
import XCTest

final class EncoderDecoratorTests: XCTestCase {

	private let encoder = JSONEncoder()
	
	override func setUp() {
		super.setUp()
		encoder.outputFormatting = .sortedKeys
	}

	// MARK: - Bool

	/// Testing default true/false encoding as string
	func testEncodingBoolAsStringTrueFalseDefault() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Bool.string)

		let testValue = true
		let encodedData = try decoratedEncoder.encode(testValue)
		let encodedString = String(data: encodedData, encoding: .utf8) ?? ""

		XCTAssertEqual(encodedString, "\"true\"") // Since we expect the boolean 'true' to be encoded as the string "true".

		let testValueFalse = false
		let encodedDataFalse = try decoratedEncoder.encode(testValueFalse)
		let encodedStringFalse = String(data: encodedDataFalse, encoding: .utf8) ?? ""

		XCTAssertEqual(encodedStringFalse, "\"false\"") // Since we expect the boolean 'false' to be encoded as the string "false".
	}

	/// Testing custom string encoding for true/false
	func testEncodingBoolAsStringCustom() throws {
		let customTrue = "YES"
		let customFalse = "NO"
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Bool.string(true: customTrue, false: customFalse))

		let testValue = true
		let encodedData = try decoratedEncoder.encode(testValue)
		let encodedString = String(data: encodedData, encoding: .utf8) ?? ""

		XCTAssertEqual(encodedString, "\"\(customTrue)\"") // Since we expect the boolean 'true' to be encoded as our custom string.

		let testValueFalse = false
		let encodedDataFalse = try decoratedEncoder.encode(testValueFalse)
		let encodedStringFalse = String(data: encodedDataFalse, encoding: .utf8) ?? ""

		XCTAssertEqual(encodedStringFalse, "\"\(customFalse)\"") // Since we expect the boolean 'false' to be encoded as our custom string.
	}

	// MARK: - Data

	/// Testing default base64 encoding
	func testEncodingDataBase64WithDefaultOptions() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Data.base64)

		let testString = "Hello, CodableStrategies!"
		let testData = testString.data(using: .utf8) ?? Data()
		let encodedData = try decoratedEncoder.encode(testData)
		let encodedString = String(data: encodedData, encoding: .utf8) ?? ""

		// Here, we're using Data's own method to get the expected Base64 string.
		let expectedBase64String = testData.base64EncodedString()

		XCTAssertEqual(encodedString, "\"\(expectedBase64String)\"") // We expect the encoded Data to match the base64 string of our test data.
	}

	/// Testing base64 encoding with custom options
	func testEncodingDataBase64WithCustomOptions() throws {
		let customOptions: Data.Base64EncodingOptions = [.lineLength64Characters, .endLineWithCarriageReturn]
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Data.base64(options: customOptions))

		let testString = "Hello, CodableStrategies!"
		let testData = testString.data(using: .utf8) ?? Data()
		let encodedData = try decoratedEncoder.encode(testData)
		let encodedString = String(data: encodedData, encoding: .utf8) ?? ""

		// Here, we're using Data's own method with custom options to get the expected Base64 string.
		let expectedBase64String = testData.base64EncodedString(options: customOptions)

		XCTAssertEqual(encodedString, "\"\(expectedBase64String)\"") // We expect the encoded Data to match the base64 string of our test data with custom options.
	}

	// MARK: - Date

	/// Testing encoding a date as a default Date type
	func testEncodingDateAsDate() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.date)

		let testDate = Date()
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
		let expectedString = isoFormatter.string(from: testDate)

		XCTAssertEqual(encodedString, "\"\(expectedString)\"")
	}

	/// Testing encoding date using default ISO8601 format
	func testEncodingDateAsISO8601WithDefaultOptions() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.iso8601)

		let testDate = Date()
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		let isoFormatter = ISO8601DateFormatter()
		let expectedString = isoFormatter.string(from: testDate)

		XCTAssertEqual(encodedString, "\"\(expectedString)\"")
	}

	/// Testing encoding date using custom ISO8601 options
	func testEncodingDateAsISO8601WithCustomOptions() throws {
		let customOptions: ISO8601DateFormatter.Options = [.withInternetDateTime, .withDashSeparatorInDate]
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.iso8601(customOptions))

		let testDate = Date()
		let isoFormatter = ISO8601DateFormatter()
		isoFormatter.formatOptions = customOptions
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedString = String(data: encodedData, encoding: .utf8)!
		let expectedString = isoFormatter.string(from: testDate)

		XCTAssertEqual(encodedString, "\"\(expectedString)\"")
	}

	/// Testing encoding date using a custom formatter
	func testEncodingDateWithCustomFormatter() throws {
		let customFormatter = DateFormatter()
		customFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.formatted(customFormatter))

		let testDate = Date()
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedString = String(data: encodedData, encoding: .utf8)!
		let expectedString = customFormatter.string(from: testDate)

		XCTAssertEqual(encodedString, "\"\(expectedString)\"")
	}

	/// Testing encoding date using a custom string format
	func testEncodingDateWithCustomStringFormat() throws {
		let customFormat = "yyyy-MM-dd"
		let customFormatter = DateFormatter()
		customFormatter.dateFormat = customFormat
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.formatted(customFormat, locale: Locale.current, timeZone: TimeZone.current))

		let testDate = Date()
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedString = String(data: encodedData, encoding: .utf8)!
		let expectedString = customFormatter.string(from: testDate)

		XCTAssertEqual(encodedString, "\"\(expectedString)\"")
	}

	/// Testing encoding date as a timestamp (assuming Unix timestamp)
	func testEncodingDateAsTimestamp() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Date.timestamp)

		let testDate = Date()
		let encodedData = try decoratedEncoder.encode(testDate)
		let encodedTimestamp = Double(String(data: encodedData, encoding: .utf8)!)!

		let timestamp = testDate.timeIntervalSince1970

		XCTAssertEqual(encodedTimestamp, timestamp, accuracy: 0.001)
	}

	// MARK: - Decimal

	/// Testing encoding a Decimal as a String
	func testEncodingDecimalAsString() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Decimal.string)

		let testDecimal = Decimal(string: "123.456")!
		let encodedData = try decoratedEncoder.encode(testDecimal)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "\"123.456\"") // Expecting the Decimal as a quoted string.
	}

	/// Testing encoding a Decimal as a Number
	func testEncodingDecimalAsNumber() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Decimal.number)

		let testDecimal = Decimal(string: "123.456")!
		let encodedData = try decoratedEncoder.encode(testDecimal)
		let encodedDouble = Double(String(data: encodedData, encoding: .utf8)!)!

		XCTAssertEqual(encodedDouble, (testDecimal as NSDecimalNumber).doubleValue, accuracy: 0.001) // Expecting the Decimal as a number.
	}

	// MARK: - Key

	/// Testing encoding keys using default keys
	func testEncodingKeyUseDefaultKeys() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Key.useDefaultKeys)

		let model = TestKeysModel(firstName: "John", lastName: "Doe")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"firstName\":"))
		XCTAssertTrue(encodedString.contains("\"lastName\":"))
	}

	/// Testing encoding keys to snake case using default separator
	func testEncodingKeyToSnakeCaseWithDefaultSeparator() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Key.toSnakeCase(separator: "_"))

		let model = TestKeysModel(firstName: "John", lastName: "Doe")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"first_name\":"))
		XCTAssertTrue(encodedString.contains("\"last_name\":"))
	}

	/// Testing encoding keys to snake case using a custom separator
	func testEncodingKeyToSnakeCaseWithCustomSeparator() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Key.toSnakeCase(separator: "-"))

		let model = TestKeysModel(firstName: "John", lastName: "Doe")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"first-name\":"))
		XCTAssertTrue(encodedString.contains("\"last-name\":"))
	}

	/// Testing encoding keys to camel case using default separator (assuming default separator is "_")
	func testEncodingKeyToCamelCaseWithDefaultSeparator() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Key.toCamelCase)

		let model = TestKeysModel1(first_name: "John", last_name: "Doe")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"firstName\":"))
		XCTAssertTrue(encodedString.contains("\"lastName\":"))
	}

	// MARK: - Numeric

	/// Testing encoding numeric values as a String
	func testEncodingNumericAsString() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Numeric.string)

		let model = TestModel1(number: 123, optionalValue: nil, website: URL(string: "https://example.com")!)
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"number\":\"123\""))
	}

	// MARK: - Optional

	/// Testing encoding optional values as null
	func testEncodingOptionalAsNull() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Optional.null)

		let model = TestModel1(number: 123, optionalValue: nil, website: URL(string: "https://example.com")!)
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertTrue(encodedString.contains("\"optionalValue\":null"))
	}

	// MARK: - URL

	/// Testing encoding URL values as a URI
	func testEncodingURLAsUri() throws {
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .URL.uri)

		let model = URL(string: "https://example.com")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "\"https:\\/\\/example.com\"")
	}

	/// Testing encoding URL values as a URI
	func testEncodingURLAsUriWithoutEscapingSlashes() throws {
		encoder.outputFormatting = .withoutEscapingSlashes
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .URL.uri)

		let model = URL(string: "https://example.com")
		let encodedData = try decoratedEncoder.encode(model)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "\"https://example.com\"")
		encoder.outputFormatting = []
	}

	// MARK: - common tests

	/// Testing encoding of a single value
	func testEncodingSingleValue() throws {
		let testValue = 42
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Numeric.string)
		let encodedData = try decoratedEncoder.encode(testValue)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "\"42\"")
	}

	/// Testing encoding of a single object
	func testEncodingObject() throws {
		let person = Person(name: "John", age: 30)
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Numeric.string)
		let encodedData = try decoratedEncoder.encode(person)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "{\"age\":\"30\",\"name\":\"John\"}")
	}

	/// Testing encoding of an array of objects
	func testEncodingArray() throws {
		let group = [Person(name: "John", age: 30), Person(name: "Doe", age: 25)]
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Numeric.string)
		let encodedData = try decoratedEncoder.encode(group)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "[{\"age\":\"30\",\"name\":\"John\"},{\"age\":\"25\",\"name\":\"Doe\"}]")
	}

	/// Testing encoding of nested data structures
	func testEncodingNestedDataStructures() throws {
		let group = Group(groupName: "Test Group", members: [Person(name: "John", age: 30), Person(name: "Doe", age: 25)])
		let decoratedEncoder = EncoderDecorator(encoder, strategy: .Numeric.string)
		let encodedData = try decoratedEncoder.encode(group)
		let encodedString = String(data: encodedData, encoding: .utf8)!

		XCTAssertEqual(encodedString, "{\"groupName\":\"Test Group\",\"members\":[{\"age\":\"30\",\"name\":\"John\"},{\"age\":\"25\",\"name\":\"Doe\"}]}")
	}
}
