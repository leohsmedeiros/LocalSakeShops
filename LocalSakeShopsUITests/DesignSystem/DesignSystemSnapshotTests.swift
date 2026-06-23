import XCTest

/// Snapshot tests for the design system preview screen.
///
/// These tests launch the app, capture screenshots via XCTAttachment, and attach
/// them to the test report. Reviewers inspect the attached images to verify visual
/// correctness. No pixel-diff comparison is performed — this keeps the test suite
/// stable across OS/device/font rendering changes while still providing a visual
/// audit trail on every CI run.
final class DesignSystemSnapshotTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Light Mode

    func testDesignSystemPreview_lightMode() throws {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "DesignSystemPreview_Light"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Dark Mode

    func testDesignSystemPreview_darkMode() throws {
        app.terminate()
        app.launchArguments += ["-UIUserInterfaceStyle", "dark", "2"]
        app.launch()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "DesignSystemPreview_Dark"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Scrollable Content

    func testDesignSystemPreview_scrollToBottom() throws {
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.exists, "Design system preview must contain a scroll view")

        scrollView.swipeUp()
        scrollView.swipeUp()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "DesignSystemPreview_Scrolled"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    // MARK: - Accessibility

    func testDesignSystemPreview_largeTextAccessibility() throws {
        app.terminate()
        app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityExtraExtraExtraLarge"]
        app.launch()

        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "DesignSystemPreview_LargeText"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
