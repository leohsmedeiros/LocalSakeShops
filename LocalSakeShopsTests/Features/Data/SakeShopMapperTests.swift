import Testing
@testable import LocalSakeShops

@Suite("SakeShopMapper Tests")
struct SakeShopMapperTests {

    // MARK: - Full mapping

    @Test("Full DTO maps to entity with correct field values")
    func fullDTOMapsCorrectly() {
        let dto = SakeShopDTO(
            name: "Test Shop",
            description: "A test sake shop.",
            picture: "https://example.com/photo.jpg",
            rating: 4.5,
            address: "123 Sake St",
            coordinates: [36.6, 138.2],
            googleMapsLink: "https://maps.app.goo.gl/abc123",
            website: "https://example.com"
        )
        let shop = SakeShopMapper.map(dto)

        #expect(shop.name == "Test Shop")
        #expect(shop.description == "A test sake shop.")
        #expect(shop.pictureURL == URL(string: "https://example.com/photo.jpg"))
        #expect(shop.rating == 4.5)
        #expect(shop.address == "123 Sake St")
        #expect(shop.mapsURL == URL(string: "https://maps.app.goo.gl/abc123"))
        #expect(shop.websiteURL == URL(string: "https://example.com"))
    }

    // MARK: - Null picture

    @Test("Null picture maps to nil pictureURL")
    func nullPictureMapsToNil() {
        let dto = SakeShopDTO(
            name: "Midori Nagano",
            description: "Shopping center.",
            picture: nil,
            rating: 4.0,
            address: "Some address",
            coordinates: nil,
            googleMapsLink: nil,
            website: nil
        )
        let shop = SakeShopMapper.map(dto)
        #expect(shop.pictureURL == nil)
    }

    // MARK: - Rating clamping

    @Test("Rating below 0 is clamped to 0")
    func ratingBelowZeroClampsToZero() {
        let dto = SakeShopDTO(
            name: "X", description: "", picture: nil,
            rating: -1.5, address: "", coordinates: nil,
            googleMapsLink: nil, website: nil
        )
        #expect(SakeShopMapper.map(dto).rating == 0.0)
    }

    @Test("Rating above 5 is clamped to 5")
    func ratingAboveFiveClampsToFive() {
        let dto = SakeShopDTO(
            name: "X", description: "", picture: nil,
            rating: 7.9, address: "", coordinates: nil,
            googleMapsLink: nil, website: nil
        )
        #expect(SakeShopMapper.map(dto).rating == 5.0)
    }

    // MARK: - URL parsing

    @Test("Invalid URL string maps to nil")
    func invalidURLMapsToNil() {
        let dto = SakeShopDTO(
            name: "X", description: "", picture: "not a url",
            rating: 4.0, address: "", coordinates: nil,
            googleMapsLink: "also not a url", website: "  "
        )
        let shop = SakeShopMapper.map(dto)
        #expect(shop.pictureURL == nil)
        #expect(shop.mapsURL == nil)
        #expect(shop.websiteURL == nil)
    }

    // MARK: - Batch mapping

    @Test("Batch mapping preserves original order")
    func batchMappingPreservesOrder() {
        let names = ["Alpha", "Beta", "Gamma"]
        let dtos = names.map { name in
            SakeShopDTO(
                name: name, description: "", picture: nil,
                rating: 4.0, address: "", coordinates: nil,
                googleMapsLink: nil, website: nil
            )
        }
        let shops = SakeShopMapper.map(dtos)
        #expect(shops.map(\.name) == names)
    }
}
