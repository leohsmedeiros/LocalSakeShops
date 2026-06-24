import Foundation
@testable import LocalSakeShops

/// Test double for `FetchSakeShopsUseCaseProtocol`.
///
/// Stubs a fixed result and records call counts for assertion in unit tests.
@MainActor
final class MockFetchSakeShopsUseCase: FetchSakeShopsUseCaseProtocol {

    /// The result to return (or throw) when `execute()` is called.
    var stubbedResult: Result<[SakeShop], Error> = .success([])

    /// Number of times `execute()` has been invoked.
    private(set) var executeCallCount = 0

    func execute() async throws -> [SakeShop] {
        executeCallCount += 1
        return try stubbedResult.get()
    }
}
