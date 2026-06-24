import Testing
@testable import LocalSakeShops

/// Integration tests for `BundledJSONDataSource`.
///
/// These tests load the real `sake_shops.json` from the test bundle. Ensure
/// `sake_shops.json` is added to the `LocalSakeShopsTests` target membership
/// in Xcode, or tests (a) and (b) will fail with `fileNotFound` for the wrong reason.
@Suite("BundledJSONDataSource Tests")
struct BundledJSONDataSourceTests {

    private let dataSource = BundledJSONDataSource()

    @Test("Loads sake_shops.json and decodes all 10 shops")
    func loadsSakeShopsJSON() async throws {
        let shops = try await dataSource.load([SakeShopDTO].self, from: "sake_shops")
        #expect(shops.count == 10)
    }

    @Test("Throws fileNotFound for a nonexistent filename")
    func throwsFileNotFoundForMissingFile() async {
        await #expect(throws: BundledJSONError.self) {
            _ = try await dataSource.load([SakeShopDTO].self, from: "nonexistent_file")
        }
    }

    @Test("Error type is fileNotFound, not decodingFailed")
    func errorIsFileNotFound() async {
        do {
            _ = try await dataSource.load([SakeShopDTO].self, from: "nonexistent_file")
            Issue.record("Expected an error but none was thrown")
        } catch BundledJSONError.fileNotFound {
            // expected
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
