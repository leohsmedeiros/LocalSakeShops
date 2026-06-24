import Foundation
@testable import LocalSakeShops

/// Test double for `BundledJSONDataSourceProtocol`.
///
/// Stubs a raw `Data` payload or an error, and records the filename passed
/// to `load(_:from:)` for assertion in unit tests.
final class MockBundledJSONDataSource: BundledJSONDataSourceProtocol {

    /// The result to return (or throw) when `load(_:from:)` is called.
    var stubbedResult: Result<Data, Error>

    /// Number of times `load(_:from:)` has been invoked.
    private(set) var loadCallCount = 0

    /// The last filename argument passed to `load(_:from:)`.
    private(set) var lastFilename: String?

    init(stubbedResult: Result<Data, Error>) {
        self.stubbedResult = stubbedResult
    }

    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T {
        loadCallCount += 1
        lastFilename = filename
        let data = try stubbedResult.get()
        return try JSONDecoder().decode(T.self, from: data)
    }
}
