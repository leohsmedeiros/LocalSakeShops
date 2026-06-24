import Foundation

/// Contract for the use case that retrieves the full list of sake shops.
///
/// Abstracting the use case behind a protocol allows ViewModels to be tested with
/// a `MockFetchSakeShopsUseCase` without touching any real data sources.
protocol FetchSakeShopsUseCaseProtocol {

    /// Executes the use case.
    /// - Throws: `SakeShopError` propagated from the repository layer.
    /// - Returns: An ordered array of `SakeShop` domain entities.
    func execute() async throws -> [SakeShop]
}
