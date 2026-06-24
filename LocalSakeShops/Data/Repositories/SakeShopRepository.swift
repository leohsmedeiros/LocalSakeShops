import Foundation

/// Concrete repository that loads sake shops from a bundled JSON file.
///
/// Translates `BundledJSONError` values into `SakeShopError` so the domain layer
/// remains decoupled from data-source error types.
final class SakeShopRepository: SakeShopRepositoryProtocol {

    private let dataSource: BundledJSONDataSourceProtocol
    private let filename: String

    /// Creates a repository backed by the given data source.
    /// - Parameters:
    ///   - dataSource: The data source to read JSON from. Defaults to `BundledJSONDataSource`.
    ///   - filename: The JSON filename (without extension). Defaults to `"sake_shops"`.
    init(dataSource: BundledJSONDataSourceProtocol, filename: String = "sake_shops") {
        self.dataSource = dataSource
        self.filename = filename
    }

    /// Loads and maps the list of sake shops.
    /// - Throws: `SakeShopError.dataNotFound` if the file is missing,
    ///           `SakeShopError.decodingFailed` if the JSON cannot be parsed.
    func fetchShops() async throws -> [SakeShop] {
        do {
            let dtos = try await dataSource.load([SakeShopDTO].self, from: filename)
            return SakeShopMapper.map(dtos)
        } catch BundledJSONError.fileNotFound {
            throw SakeShopError.dataNotFound
        } catch let BundledJSONError.decodingFailed(underlying) {
            throw SakeShopError.decodingFailed(underlying)
        } catch {
            throw SakeShopError.decodingFailed(error)
        }
    }
}
