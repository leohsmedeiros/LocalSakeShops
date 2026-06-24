import Foundation

/// Contract for loading a `Decodable` value from a named data source.
///
/// The generic load method makes this protocol reusable for any JSON file in the
/// bundle — a new feature needs only a new DTO, mapper, and repository; the data
/// source itself requires zero changes.
protocol BundledJSONDataSourceProtocol {

    /// Loads and decodes a value of the specified type from a named resource.
    /// - Parameters:
    ///   - type: The `Decodable` type to decode into.
    ///   - filename: The resource filename without extension.
    /// - Throws: `BundledJSONError` if the file is missing or the data cannot be decoded.
    /// - Returns: A decoded value of type `T`.
    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T
}
