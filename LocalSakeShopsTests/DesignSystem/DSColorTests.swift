import Testing
import UIKit
@testable import LocalSakeShops

/// Tests that every DSColor token resolves to a named asset in the app bundle.
/// If a color set is missing from Assets.xcassets, UIColor(named:) returns nil
/// and the test fails, surfacing the gap before the app is run.
@Suite("DSColor Token Tests")
struct DSColorTests {

    @Test func primaryResolves() {
        #expect(UIColor(named: "DSPrimary") != nil)
    }

    @Test func secondaryResolves() {
        #expect(UIColor(named: "DSSecondary") != nil)
    }

    @Test func backgroundResolves() {
        #expect(UIColor(named: "DSBackground") != nil)
    }

    @Test func surfaceResolves() {
        #expect(UIColor(named: "DSSurface") != nil)
    }

    @Test func onPrimaryResolves() {
        #expect(UIColor(named: "DSOnPrimary") != nil)
    }

    @Test func onSurfaceResolves() {
        #expect(UIColor(named: "DSOnSurface") != nil)
    }

    @Test func subduedResolves() {
        #expect(UIColor(named: "DSSubdued") != nil)
    }

    @Test func errorResolves() {
        #expect(UIColor(named: "DSError") != nil)
    }

    @Test func successResolves() {
        #expect(UIColor(named: "DSSuccess") != nil)
    }

    @Test func warningResolves() {
        #expect(UIColor(named: "DSWarning") != nil)
    }
}
