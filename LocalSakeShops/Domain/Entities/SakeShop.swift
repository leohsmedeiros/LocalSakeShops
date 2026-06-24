import Foundation

/// A sake shop entry in the domain layer.
///
/// This struct is the sole representation of a shop used by ViewModels, Use Cases,
/// and Views. It is mapped from `SakeShopDTO` by `SakeShopMapper` and never
/// constructed directly from raw JSON.
struct SakeShop: Identifiable, Equatable, Hashable {

    /// Stable unique identifier generated at mapping time.
    let id: UUID

    /// Display name of the sake shop.
    let name: String

    /// Short description of the sake shop.
    let description: String

    /// Remote URL for the shop's cover photo, or `nil` if none is provided.
    let pictureURL: URL?

    /// Star rating clamped to the 0–5 range.
    let rating: Double

    /// Full postal address of the sake shop.
    let address: String

    /// URL to open the shop's location in a Maps application, or `nil` if unavailable.
    let mapsURL: URL?

    /// URL for the shop's website, or `nil` if absent or malformed.
    let websiteURL: URL?
}
