import Foundation

/// Domain-layer errors surfaced by the sake shop data pipeline.
///
/// These errors are propagated through the repository → use case → ViewModel chain
/// and converted to user-facing messages in `ViewState.error(String)`.
enum SakeShopError: Error, LocalizedError {

    /// The data source file could not be found in the app bundle.
    case dataNotFound

    /// The raw data exists but could not be decoded into the expected model.
    case decodingFailed(Error)

    /// A human-readable description suitable for display in the UI error state.
    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "The shop data could not be found. Please reinstall the app."
        case .decodingFailed:
            return "The shop data is corrupted and could not be loaded."
        }
    }
}
