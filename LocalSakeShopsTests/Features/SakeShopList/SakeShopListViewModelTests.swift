import Testing
import Foundation
@testable import LocalSakeShops

@Suite("SakeShopListViewModel Tests")
@MainActor
struct SakeShopListViewModelTests {

    private func makeShop(name: String = "Shop") -> SakeShop {
        SakeShop(
            id: UUID(),
            name: name,
            description: "",
            pictureURL: nil,
            rating: 4.0,
            address: "Some Address",
            mapsURL: nil,
            websiteURL: nil
        )
    }

    @Test("Initial state is idle")
    func initialStateIsIdle() {
        let mockUseCase = MockFetchSakeShopsUseCase()
        let viewModel = SakeShopListViewModel(fetchShops: mockUseCase)

        guard case .idle = viewModel.state else {
            Issue.record("Expected .idle, got \(viewModel.state)")
            return
        }
    }

    @Test("loadShops() transitions to success with returned shops")
    func loadShopsTransitionsToSuccess() async {
        let shops = [makeShop(name: "A"), makeShop(name: "B")]
        let mockUseCase = MockFetchSakeShopsUseCase()
        mockUseCase.stubbedResult = .success(shops)
        let viewModel = SakeShopListViewModel(fetchShops: mockUseCase)

        await viewModel.loadShops()

        guard case .success(let result) = viewModel.state else {
            Issue.record("Expected .success, got \(viewModel.state)")
            return
        }
        #expect(result.map(\.name) == ["A", "B"])
    }

    @Test("loadShops() transitions to empty when result is empty")
    func loadShopsTransitionsToEmpty() async {
        let mockUseCase = MockFetchSakeShopsUseCase()
        mockUseCase.stubbedResult = .success([])
        let viewModel = SakeShopListViewModel(fetchShops: mockUseCase)

        await viewModel.loadShops()

        guard case .empty = viewModel.state else {
            Issue.record("Expected .empty, got \(viewModel.state)")
            return
        }
    }

    @Test("loadShops() transitions to error when use case throws")
    func loadShopsTransitionsToError() async {
        let mockUseCase = MockFetchSakeShopsUseCase()
        mockUseCase.stubbedResult = .failure(SakeShopError.dataNotFound)
        let viewModel = SakeShopListViewModel(fetchShops: mockUseCase)

        await viewModel.loadShops()

        guard case .error = viewModel.state else {
            Issue.record("Expected .error, got \(viewModel.state)")
            return
        }
    }

    @Test("executeCallCount is exactly 1 after loadShops()")
    func executeCallCountIsOne() async {
        let mockUseCase = MockFetchSakeShopsUseCase()
        mockUseCase.stubbedResult = .success([])
        let viewModel = SakeShopListViewModel(fetchShops: mockUseCase)

        await viewModel.loadShops()

        #expect(mockUseCase.executeCallCount == 1)
    }
}
