import Foundation

public extension DecodingStrategy {
    
    /// Collection decoding strategy scope.
    enum Collection {}
}

public extension DecodingStrategy.Collection {
    
    /// Removes the failed elements from the collection.
    static var removeFailed: DecodingStrategy {
        DecodingStrategy(
            decode
        )
    }
}

private extension DecodingStrategy.Bool {
    
    static let defaultTrueString: Set<Swift.String> = ["true", "yes", "1"]
}
