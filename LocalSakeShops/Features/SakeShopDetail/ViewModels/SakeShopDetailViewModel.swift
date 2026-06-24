import SwiftUI

/// ViewModel for the sake shop detail screen.
///
/// Provides computed availability flags so Views can conditionally show
/// tappable address and website controls.
@MainActor
@Observable
final class SakeShopDetailViewModel {

    /// The sake shop whose details are being displayed.
    let shop: SakeShop

    /// `true` when the shop has a valid Maps URL that can be opened.
    var canOpenMaps: Bool { shop.mapsURL != nil }

    /// `true` when the shop has a valid website URL that can be opened.
    var canOpenWebsite: Bool { shop.websiteURL != nil }
    
    /// The url to open, can be maps or website.
    var urlToOpen: URL?

    /// Creates the ViewModel for the given shop.
    /// - Parameter shop: The sake shop to display.
    init(shop: SakeShop) {
        self.shop = shop
    }

    /// Opens the shop's Maps URL in the device's default Maps application.
    func openMaps() {
        guard let url = shop.mapsURL else { return }
        urlToOpen = url
    }

    /// Opens the shop's website URL in the device's default web browser.
    func openWebsite() {
        guard let url = shop.websiteURL else { return }
        urlToOpen = url
    }
}
