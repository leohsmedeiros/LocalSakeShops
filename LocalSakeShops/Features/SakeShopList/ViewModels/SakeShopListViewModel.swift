import Foundation

/// ViewModel for the sake shop list screen.
///
/// Manages the single `state` published property that drives all UI variants
/// (loading, success, empty, error). Business logic lives here; views only observe.
@MainActor
@Observable
final class SakeShopListViewModel {

    /// The current loading state of the shop list.
    private(set) var state: ViewState<[SakeShop]> = .idle

    private let fetchShops: FetchSakeShopsUseCaseProtocol

    /// Creates the ViewModel with its use case dependency.
    /// - Parameter fetchShops: The use case to call when loading begins.
    init(fetchShops: FetchSakeShopsUseCaseProtocol) {
        self.fetchShops = fetchShops
    }

    /// Initiates a shop list load, cycling through `.loading` → `.success` / `.empty` / `.error`.
    func loadShops() async {
        state = .loading
        do {
            let shops = try await fetchShops.execute()
            state = shops.isEmpty ? .empty : .success(shops)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription
                ?? error.localizedDescription
            state = .error(message)
        }
    }
}
