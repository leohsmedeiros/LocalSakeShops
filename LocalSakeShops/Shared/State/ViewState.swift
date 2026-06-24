import Foundation

/// Represents all possible states of a data-loading view.
///
/// Using a single `ViewState` eliminates impossible UI states such as
/// "loading = true AND data = non-nil" that arise from multiple `@Published` flags.
enum ViewState<T> {

    /// Initial state before any load has been requested.
    case idle

    /// A load is in progress; show a progress indicator.
    case loading

    /// The load completed successfully with associated data.
    case success(T)

    /// The load completed but returned no data to display.
    case empty

    /// The load failed with a human-readable message.
    case error(String)
}
