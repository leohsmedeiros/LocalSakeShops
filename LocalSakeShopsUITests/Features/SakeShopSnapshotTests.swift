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
        // App is NOT launched here — each test calls launchApp() so that
        // -UIUserInterfaceStyle can be set on launchArguments before launch.
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - List Screen

    func testListScreenLightModePortrait() {
        launchApp(appearance: .light)
        waitForListToLoad()
        attach(screenshot(), name: "list-light-portrait")
    }

    func testListScreenDarkModePortrait() {
        launchApp(appearance: .dark)
        waitForListToLoad()
        attach(screenshot(), name: "list-dark-portrait")
    }

    func testListScreenLightModeLandscape() {
        launchApp(appearance: .light)
        XCUIDevice.shared.orientation = .landscapeLeft
        waitForListToLoad()
        attach(screenshot(), name: "list-light-landscape")
        XCUIDevice.shared.orientation = .portrait
    }

    // MARK: - Detail Screen

    func testDetailScreenLightModePortrait() {
        launchApp(appearance: .light)
        waitForListToLoad()
        tapFirstRow()
        attach(screenshot(), name: "detail-light-portrait")
    }

    func testDetailScreenDarkModePortrait() {
        launchApp(appearance: .dark)
        waitForListToLoad()
        tapFirstRow()
        attach(screenshot(), name: "detail-dark-portrait")
    }

    // MARK: - Back Navigation Scroll Position

    func testBackNavigationPreservesScrollPosition() {
        launchApp(appearance: .light)
        waitForListToLoad()

        // Scroll partway down to move away from the first row
        app.scrollViews.firstMatch.swipeUp()
        attach(screenshot(), name: "list-scrolled-before-detail")

        tapFirstRow()
        attach(screenshot(), name: "detail-from-scrolled-list")

        // Tap the back button
        app.navigationBars.buttons.firstMatch.tap()
        _ = app.scrollViews.firstMatch.waitForExistence(timeout: 3)
        attach(screenshot(), name: "list-after-back-navigation")
    }

    // MARK: - Helpers

    /// Creates a fresh app instance, sets appearance launch arguments, and launches.
    /// Must be called at the start of every test instead of relying on setUp.
    private func launchApp(appearance: UIUserInterfaceStyle = .light) {
        app = XCUIApplication()
        app.launchArguments = [
            "-UIUserInterfaceStyle",
            appearance == .dark ? "Dark" : "Light"
        ]
        app.launch()
    }

    /// Waits for the navigation title and at least one shop row to confirm the list loaded.
    ///
    /// The list is rendered as `ScrollView > LazyVStack > NavigationLink.buttonStyle(.plain)`,
    /// so shops appear as buttons in the accessibility tree — not as collection view cells.
    private func waitForListToLoad() {
        let navBar = app.navigationBars["Local Sake Shops"]
        XCTAssertTrue(
            navBar.waitForExistence(timeout: 5),
            "Navigation bar 'Local Sake Shops' should appear within 5 seconds"
        )
        let firstShop = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(
            firstShop.waitForExistence(timeout: 5),
            "At least one shop row should appear in the list"
        )
    }

    /// Taps the first shop row and waits for the detail screen navigation to settle.
    private func tapFirstRow() {
        let firstShop = app.scrollViews.firstMatch.buttons.firstMatch
        XCTAssertTrue(
            firstShop.waitForExistence(timeout: 3),
            "First shop row should be tappable"
        )
        firstShop.tap()
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
}
