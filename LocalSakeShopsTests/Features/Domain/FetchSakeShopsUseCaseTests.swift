import Testing
@testable import LocalSakeShops

@Suite("FetchSakeShopsUseCase Tests")
@MainActor
struct FetchSakeShopsUseCaseTests {

    private func makeShop(name: String = "Test Shop") -> SakeShop {
        SakeShop(
            id: UUID(),
            name: name,
            description: "",
            pictureURL: nil,
            rating: 4.0,
            address: "",
            mapsURL: nil,
            websiteURL: nil
        )
    }

    @Test("execute() delegates to repository and returns shops")
    func delegatesToRepository() async throws {
        let expectedShops = [makeShop(name: "A"), makeShop(name: "B")]
        let mockRepo = MockSakeShopRepository()
        mockRepo.stubbedResult = .success(expectedShops)
        let useCase = FetchSakeShopsUseCase(repository: mockRepo)

        let result = try await useCase.execute()

        #expect(result.map(\.name) == ["A", "B"])
    }

    @Test("execute() propagates repository errors unchanged")
    func propagatesErrors() async {
        let mockRepo = MockSakeShopRepository()
        mockRepo.stubbedResult = .failure(SakeShopError.dataNotFound)
        let useCase = FetchSakeShopsUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute()
            Issue.record("Expected error but none was thrown")
        } catch SakeShopError.dataNotFound {
            // expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test("fetchCallCount is exactly 1 per execute() call")
    func fetchCallCountIsOne() async throws {
        let mockRepo = MockSakeShopRepository()
        mockRepo.stubbedResult = .success([])
        let useCase = FetchSakeShopsUseCase(repository: mockRepo)

        _ = try? await useCase.execute()

        #expect(mockRepo.fetchCallCount == 1)
    }
}
