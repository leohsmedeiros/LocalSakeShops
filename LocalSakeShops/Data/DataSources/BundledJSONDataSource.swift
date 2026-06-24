import Foundation

/// Errors thrown exclusively by `BundledJSONDataSource`.
///
/// Defined with internal (Swift default) access so that `SakeShopRepository`
/// and its tests can pattern-match these cases from separate files.
enum BundledJSONError: Error {

    /// No file with the given name exists in the main bundle.
    case fileNotFound(String)

    /// The file was found but could not be decoded into the requested type.
    case decodingFailed(Error)
}

/// Loads any `Decodable` type from a JSON file bundled inside the app.
///
/// This is the single, reusable data source for all bundle-based JSON features.
/// To add a new data type, create a new DTO, mapper, and repository — this class
/// requires zero changes.
final class BundledJSONDataSource: BundledJSONDataSourceProtocol {

    /// Loads and decodes a value from a bundled `.json` file.
    /// - Parameters:
    ///   - type: The `Decodable` type to decode.
    ///   - filename: The file name without the `.json` extension.
    /// - Throws: `BundledJSONError.fileNotFound` if the file is absent,
    ///           `BundledJSONError.decodingFailed` if JSON decoding fails.
    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw BundledJSONError.fileNotFound(filename)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw BundledJSONError.decodingFailed(decodingError)
        } catch {
            throw BundledJSONError.decodingFailed(error)
        }
    }
}
