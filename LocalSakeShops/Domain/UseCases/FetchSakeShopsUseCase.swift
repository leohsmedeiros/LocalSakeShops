import Foundation

/// Fetches the full list of sake shops from the repository.
///
/// Acts as the boundary between the presentation and data layers. Future filtering,
/// sorting, or caching logic belongs here — not in the ViewModel or repository.
final class FetchSakeShopsUseCase: FetchSakeShopsUseCaseProtocol {

    private let repository: SakeShopRepositoryProtocol

    /// Creates the use case with the given repository.
    /// - Parameter repository: The repository to delegate fetching to.
    init(repository: SakeShopRepositoryProtocol) {
        self.repository = repository
    }

    /// Executes the use case by delegating to the repository.
    /// - Throws: `SakeShopError` propagated from the repository.
    /// - Returns: The ordered list of `SakeShop` domain entities.
    func execute() async throws -> [SakeShop] {
        try await repository.fetchShops()
    }
}
