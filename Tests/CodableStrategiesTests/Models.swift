import Foundation

/// Model for the tests
struct TestKeysModel: Codable {

	var firstName: String
	var lastName: String
}

struct TestKeysModel1: Codable {

	var first_name: String
	var last_name: String
}

/// Model for the tests
struct TestModel1: Codable {
	var number: Int
	var optionalValue: String?
	var website: URL?
}

struct Person: Codable {
	var name: String
	var age: Int
}

struct ModelWithOptionals: Codable {
	var int: Int?
	var string: String?
}

struct Group: Codable {
	var groupName: String
	var members: [Person]
}
