import Foundation

/// Maps `SakeShopDTO` data transfer objects to `SakeShop` domain entities.
///
/// All data cleaning (URL parsing, rating clamping, UUID generation) happens here.
/// Neither the DTO nor the entity should contain mapping logic.
enum SakeShopMapper {

    /// Maps a single `SakeShopDTO` to a `SakeShop` domain entity.
    /// - Parameter dto: The raw data transfer object decoded from JSON.
    /// - Returns: A cleaned, ID-stamped `SakeShop` ready for use in the domain layer.
    static func map(_ dto: SakeShopDTO) -> SakeShop {
        SakeShop(
            id: UUID(),
            name: dto.name,
            description: dto.description,
            pictureURL: parseURL(dto.picture),
            rating: min(max(dto.rating, 0.0), 5.0),
            address: dto.address,
            mapsURL: parseURL(dto.googleMapsLink),
            websiteURL: parseURL(dto.website)
        )
    }

    // URL(string:) on newer Foundation can return a non-nil relative-reference URL for
    // arbitrary strings. Requiring a non-nil scheme ensures only absolute URLs survive.
    private static func parseURL(_ string: String?) -> URL? {
        guard let string,
              let url = URL(string: string),
              url.scheme != nil else { return nil }
        return url
    }

    /// Maps an array of `SakeShopDTO` objects, preserving their original order.
    /// - Parameter dtos: The raw array decoded from JSON.
    /// - Returns: A mapped array of `SakeShop` entities in the same order.
    static func map(_ dtos: [SakeShopDTO]) -> [SakeShop] {
        dtos.map { map($0) }
    }
}
