import Testing
import Foundation
@testable import LocalSakeShops

/// Tests that every DSColor token has a matching color asset in Assets.xcassets.
@Suite("DSColor Token Tests")
struct DSColorTests {

    private static let colorNames = [
        "DSPrimary",
        "DSSecondary",
        "DSBackground",
        "DSSurface",
        "DSOnPrimary",
        "DSOnSurface",
        "DSSubdued",
        "DSError",
        "DSSuccess",
        "DSWarning"
    ]

    @Test func allColorAssetsExist() throws {
        let assetsCatalogURL = try DSColorTests.findAssetsCatalog()

        for colorName in Self.colorNames {
            let colorSetURL = assetsCatalogURL
                .appendingPathComponent("\(colorName).colorset")
                .appendingPathComponent("Contents.json")

            #expect(
                FileManager.default.fileExists(atPath: colorSetURL.path),
                "Missing color asset: \(colorName).colorset"
            )
        }
    }

    private static func findAssetsCatalog() throws -> URL {
        var currentURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()

        while currentURL.path != "/" {
            let possibleURL = currentURL
                .appendingPathComponent("LocalSakeShops")
                .appendingPathComponent("Assets.xcassets")

            if FileManager.default.fileExists(atPath: possibleURL.path) {
                return possibleURL
            }

            currentURL.deleteLastPathComponent()
        }

        throw AssetCatalogError.notFound
    }

    private enum AssetCatalogError: Error {
        case notFound
    }
}
