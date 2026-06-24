import Foundation
@testable import LocalSakeShops

/// Test double for `SakeShopRepositoryProtocol`.
///
/// Stubs a fixed result and records call counts for assertion in unit tests.
@MainActor
final class MockSakeShopRepository: SakeShopRepositoryProtocol {

    /// The result to return (or throw) when `fetchShops()` is called.
    var stubbedResult: Result<[SakeShop], Error> = .success([])

    /// Number of times `fetchShops()` has been invoked.
    private(set) var fetchCallCount = 0

    func fetchShops() async throws -> [SakeShop] {
        fetchCallCount += 1
        return try stubbedResult.get()
    }
}
