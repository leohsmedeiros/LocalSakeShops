import Testing
import Foundation
@testable import LocalSakeShops

@Suite("SakeShopRepository Tests")
struct SakeShopRepositoryTests {

    // MARK: - Helpers

    private func makeValidJSON(count: Int = 2) throws -> Data {
        let items = (0..<count).map { i in
            """
            {
              "name": "Shop \(i)",
              "description": "Desc \(i)",
              "picture": null,
              "rating": 4.0,
              "address": "Address \(i)",
              "coordinates": null,
              "google_maps_link": null,
              "website": null
            }
            """
        }.joined(separator: ",")
        let json = "[\(items)]"
        guard let data = json.data(using: .utf8) else {
            throw BundledJSONError.decodingFailed(
                NSError(domain: "test", code: 0)
            )
        }
        return data
    }

    // MARK: - Success path

    @Test("Success: valid JSON data is mapped to SakeShop entities")
    func successPathReturnsMappedShops() async throws {
        let data = try makeValidJSON(count: 2)
        let mock = MockBundledJSONDataSource(stubbedResult: .success(data))
        let repo = SakeShopRepository(dataSource: mock, filename: "fake_shops")

        let shops = try await repo.fetchShops()

        #expect(shops.count == 2)
        #expect(shops[0].name == "Shop 0")
        #expect(shops[1].name == "Shop 1")
    }

    // MARK: - Error mapping

    @Test("fileNotFound from data source maps to SakeShopError.dataNotFound")
    func fileNotFoundMapsToDataNotFound() async {
        let mock = MockBundledJSONDataSource(
            stubbedResult: .failure(BundledJSONError.fileNotFound("fake"))
        )
        let repo = SakeShopRepository(dataSource: mock)

        do {
            _ = try await repo.fetchShops()
            Issue.record("Expected error but none was thrown")
        } catch SakeShopError.dataNotFound {
            // expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("decodingFailed from data source maps to SakeShopError.decodingFailed")
    func decodingFailedMapsToDecodingFailed() async {
        let underlying = NSError(domain: "test", code: 42)
        let mock = MockBundledJSONDataSource(
            stubbedResult: .failure(BundledJSONError.decodingFailed(underlying))
        )
        let repo = SakeShopRepository(dataSource: mock)

        do {
            _ = try await repo.fetchShops()
            Issue.record("Expected error but none was thrown")
        } catch SakeShopError.decodingFailed {
            // expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    // MARK: - Call count

    @Test("loadCallCount is exactly 1 after fetchShops()")
    func loadCallCountIsOne() async throws {
        let data = try makeValidJSON(count: 1)
        let mock = MockBundledJSONDataSource(stubbedResult: .success(data))
        let repo = SakeShopRepository(dataSource: mock)

        _ = try await repo.fetchShops()

        #expect(mock.loadCallCount == 1)
    }
}
