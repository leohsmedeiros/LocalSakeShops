import Testing
import Foundation
@testable import LocalSakeShops

@Suite("SakeShopDetailViewModel Tests")
@MainActor
struct SakeShopDetailViewModelTests {

    private func makeShop(
        mapsURL: URL? = nil,
        websiteURL: URL? = nil,
        rating: Double = 4.5
    ) -> SakeShop {
        SakeShop(
            id: UUID(),
            name: "Test Shop",
            description: "A test shop.",
            pictureURL: nil,
            rating: rating,
            address: "123 Test St",
            mapsURL: mapsURL,
            websiteURL: websiteURL
        )
    }

    // MARK: - canOpenMaps

    @Test("canOpenMaps is true when mapsURL is present")
    func canOpenMapsIsTrueWithURL() {
        let shop = makeShop(mapsURL: URL(string: "https://maps.app.goo.gl/abc"))
        let viewModel = SakeShopDetailViewModel(shop: shop)
        #expect(viewModel.canOpenMaps == true)
    }

    @Test("canOpenMaps is false when mapsURL is nil")
    func canOpenMapsIsFalseWithoutURL() {
        let shop = makeShop(mapsURL: nil)
        let viewModel = SakeShopDetailViewModel(shop: shop)
        #expect(viewModel.canOpenMaps == false)
    }

    // MARK: - canOpenWebsite

    @Test("canOpenWebsite is true when websiteURL is present")
    func canOpenWebsiteIsTrueWithURL() {
        let shop = makeShop(websiteURL: URL(string: "https://example.com"))
        let viewModel = SakeShopDetailViewModel(shop: shop)
        #expect(viewModel.canOpenWebsite == true)
    }

    @Test("canOpenWebsite is false when websiteURL is nil")
    func canOpenWebsiteIsFalseWithoutURL() {
        let shop = makeShop(websiteURL: nil)
        let viewModel = SakeShopDetailViewModel(shop: shop)
        #expect(viewModel.canOpenWebsite == false)
    }

    // MARK: - Rating exposure

    @Test("shop rating is exposed correctly")
    func shopRatingIsExposed() {
        let shop = makeShop(rating: 3.7)
        let viewModel = SakeShopDetailViewModel(shop: shop)
        #expect(viewModel.shop.rating == 3.7)
    }
}
