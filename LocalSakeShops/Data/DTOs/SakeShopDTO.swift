import Foundation

/// Data Transfer Object mirroring the JSON structure in `sake_shops.json`.
///
/// This type is used exclusively by `BundledJSONDataSource` and `SakeShopMapper`.
/// It MUST NOT be used in ViewModels or Views — convert it to `SakeShop` first.
struct SakeShopDTO: Decodable {

    /// Display name of the sake shop.
    let name: String

    /// Short description of the sake shop.
    let description: String

    /// Cover photo URL string, or `nil` if the JSON value is `null`.
    let picture: String?

    /// Raw star rating from the JSON (may be outside the 0–5 range before mapping).
    let rating: Double

    /// Full postal address of the sake shop.
    let address: String

    /// Latitude/longitude pair as `[lat, lng]`, or `nil` if absent.
    let coordinates: [Double]?

    /// Google Maps short link for the shop's location, or `nil` if absent.
    let googleMapsLink: String?

    /// Website URL string, or `nil` if absent.
    let website: String?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case picture
        case rating
        case address
        case coordinates
        case googleMapsLink = "google_maps_link"
        case website
    }
}
