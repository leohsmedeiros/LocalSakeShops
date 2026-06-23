import Testing
internal import CoreFoundation
@testable import LocalSakeShops

@Suite("DSSpacing Token Tests")
struct DSSpacingTests {

    @Test func xsEquals4() {
        #expect(DSSpacing.xs == 4)
    }

    @Test func smEquals8() {
        #expect(DSSpacing.sm == 8)
    }

    @Test func mdEquals16() {
        #expect(DSSpacing.md == 16)
    }

    @Test func lgEquals24() {
        #expect(DSSpacing.lg == 24)
    }

    @Test func xlEquals40() {
        #expect(DSSpacing.xl == 40)
    }

    @Test func gutterEquals16() {
        #expect(DSSpacing.gutter == 16)
    }

    @Test func marginEquals20() {
        #expect(DSSpacing.margin == 20)
    }

    @Test func scaleIsStrictlyIncreasing() {
        #expect(DSSpacing.xs < DSSpacing.sm)
        #expect(DSSpacing.sm < DSSpacing.md)
        #expect(DSSpacing.md < DSSpacing.lg)
        #expect(DSSpacing.lg < DSSpacing.xl)
    }
}
