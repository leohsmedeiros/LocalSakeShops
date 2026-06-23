import Testing
import SwiftUI
@testable import LocalSakeShops

@Suite("DSTypography Token Tests")
struct DSTypographyTests {

    @Test func displayStyleIsAccessible() {
        let _ = DSTypography.display
    }

    @Test func headlineLargeStyleIsAccessible() {
        let _ = DSTypography.headlineLarge
    }

    @Test func headlineMediumStyleIsAccessible() {
        let _ = DSTypography.headlineMedium
    }

    @Test func headlineSmallStyleIsAccessible() {
        let _ = DSTypography.headlineSmall
    }

    @Test func bodyLargeStyleIsAccessible() {
        let _ = DSTypography.bodyLarge
    }

    @Test func bodyMediumStyleIsAccessible() {
        let _ = DSTypography.bodyMedium
    }

    @Test func labelLargeStyleIsAccessible() {
        let _ = DSTypography.labelLarge
    }

    @Test func labelSmallStyleIsAccessible() {
        let _ = DSTypography.labelSmall
    }

    @Test func displayFontSizeIs40() {
        #expect(DSTypography.display.size == 40)
    }

    @Test func bodyMediumFontSizeIs16() {
        #expect(DSTypography.bodyMedium.size == 16)
    }
}
