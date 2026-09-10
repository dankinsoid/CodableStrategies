import Foundation

extension DecodingError {

	public var humanReadableString: String {
		switch self {
		case .typeMismatch(let type, let context):
			return "Type mismatch for \(type) at '\(context.codingPath.humanReadableString)': \(context.debugDescription)" + underlyingError(context)
		case .valueNotFound(let type, let context):
			return "Value of \(type) not found at '\(context.codingPath.humanReadableString)': \(context.debugDescription)" + underlyingError(context)
		case .keyNotFound(let key, let context):
			return "Key '\(key.stringValue)' not found at '\(context.codingPath.humanReadableString)'" + underlyingError(context)
		case .dataCorrupted(let context):
			return "Data corrupted at '\(context.codingPath.humanReadableString)': \(context.debugDescription)" + underlyingError(context)
		@unknown default:
			return localizedDescription
		}
	}

	private func underlyingError(_ context: Context) -> String {
		context.underlyingError.map { ", error: \($0)" } ?? ""
	}
}

extension DecodingError.Context {

	public var humanReadableString: String {
		var result = "Coding Path: \(codingPath.humanReadableString)\nDebug Description: \(debugDescription)"
		if let underlyingError {
			result += "\nUnderlying Error: \(underlyingError.localizedDescription)"
		}
		return result
	}
}

extension EncodingError {
	
	public var humanReadableString: String {
		switch self {
		case .invalidValue(let value, let context):
			return "Invalid value '\(value)' at '\(context.codingPath.humanReadableString)': \(context.debugDescription)" + underlyingError(context)
		@unknown default:
			return localizedDescription
		}
	}

	private func underlyingError(_ context: Context) -> String {
		context.underlyingError.map { ", error: \($0)" } ?? ""
	}
}

extension EncodingError.Context {

	public var humanReadableString: String {
		var result = "Coding Path: \(codingPath.humanReadableString)\nDebug Description: \(debugDescription)"
		if let underlyingError {
			result += "\nUnderlying Error: \(underlyingError.localizedDescription)"
		}
		return result
	}
}

extension [CodingKey] {

	public var humanReadableString: String {
		map {
			if let intKey = $0.intValue {
				return "[\(intKey)]"
			} else {
				return ".\($0.stringValue)"
			}
		}
		.joined()
	}
}
