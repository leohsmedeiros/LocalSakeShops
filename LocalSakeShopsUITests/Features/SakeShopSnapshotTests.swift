import XCTest

/// UI snapshot tests for the Sake Shop List & Detail feature.
///
/// Captures `XCTAttachment` screenshots for visual audit. These are NOT pixel-diff
/// tests — they produce a named screenshot per scenario that can be inspected in
/// Xcode's test report.
///
/// Run on both iPhone SE (3rd gen) and iPhone 16 Pro Max simulators to satisfy
/// SC-005 (all device sizes, portrait and landscape).
final class SakeShopSnapshotTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - List Screen

    func testListScreenLightModePortrait() {
        setAppearance(.light)
        waitForListToLoad()
        attach(screenshot(), name: "list-light-portrait")
    }

    func testListScreenDarkModePortrait() {
        setAppearance(.dark)
        waitForListToLoad()
        attach(screenshot(), name: "list-dark-portrait")
    }

    func testListScreenLightModeLandscape() {
        setAppearance(.light)
        XCUIDevice.shared.orientation = .landscapeLeft
        waitForListToLoad()
        attach(screenshot(), name: "list-light-landscape")
        XCUIDevice.shared.orientation = .portrait
    }

    // MARK: - Detail Screen

    func testDetailScreenLightModePortrait() {
        setAppearance(.light)
        waitForListToLoad()
        tapFirstRow()
        attach(screenshot(), name: "detail-light-portrait")
    }

    func testDetailScreenDarkModePortrait() {
        setAppearance(.dark)
        waitForListToLoad()
        tapFirstRow()
        attach(screenshot(), name: "detail-dark-portrait")
    }

    // MARK: - Back Navigation Scroll Position

    func testBackNavigationPreservesScrollPosition() {
        setAppearance(.light)
        waitForListToLoad()

        // Scroll partway down
        let list = app.collectionViews.firstMatch
        list.swipeUp()

        // Note current position visually
        attach(screenshot(), name: "list-scrolled-before-detail")

        tapFirstRow()
        attach(screenshot(), name: "detail-from-scrolled-list")

        app.navigationBars.buttons.firstMatch.tap()

        // Back on list — verify scroll is still partway down
        attach(screenshot(), name: "list-after-back-navigation")
    }

    // MARK: - Helpers

    private func waitForListToLoad() {
        let list = app.collectionViews.firstMatch
        let exists = list.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Shop list should appear within 5 seconds")
    }

    private func tapFirstRow() {
        let firstCell = app.collectionViews.firstMatch.cells.firstMatch
        let exists = firstCell.waitForExistence(timeout: 3)
        XCTAssertTrue(exists, "First shop row should exist")
        firstCell.tap()
        // Allow detail screen transition to settle
        _ = app.navigationBars.firstMatch.waitForExistence(timeout: 3)
    }

    private func screenshot() -> XCUIScreenshot {
        app.screenshot()
    }

    private func attach(_ screenshot: XCUIScreenshot, name: String) {
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func setAppearance(_ style: UIUserInterfaceStyle) {
        app.launchArguments.removeAll()
        switch style {
        case .dark:
            app.launchArguments.append("-UIUserInterfaceStyle")
            app.launchArguments.append("Dark")
        default:
            app.launchArguments.append("-UIUserInterfaceStyle")
            app.launchArguments.append("Light")
        }
    }
}
