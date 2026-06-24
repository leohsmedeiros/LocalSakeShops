import Foundation

/// Contract for fetching the list of sake shops from any data source.
///
/// Conforming types abstract over the underlying storage (bundled JSON, remote API, etc.)
/// so that use cases and ViewModels remain independent of transport details.
protocol SakeShopRepositoryProtocol {

    /// Fetches all available sake shops.
    /// - Throws: `SakeShopError` if the data cannot be retrieved or decoded.
    /// - Returns: An ordered array of `SakeShop` domain entities.
    func fetchShops() async throws -> [SakeShop]
}
