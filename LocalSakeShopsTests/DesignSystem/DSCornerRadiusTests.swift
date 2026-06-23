import Testing
internal import CoreFoundation
@testable import LocalSakeShops

@Suite("DSCornerRadius Token Tests")
struct DSCornerRadiusTests {

    @Test func noneIsZero() {
        #expect(DSCornerRadius.none == 0)
    }

    @Test func smallEquals4() {
        #expect(DSCornerRadius.small == 4)
    }

    @Test func mediumEquals8() {
        #expect(DSCornerRadius.medium == 8)
    }

    @Test func largeEquals16() {
        #expect(DSCornerRadius.large == 16)
    }

    @Test func fullEquals9999() {
        #expect(DSCornerRadius.full == 9999)
    }

    @Test func scaleIsStrictlyIncreasing() {
        #expect(DSCornerRadius.none < DSCornerRadius.small)
        #expect(DSCornerRadius.small < DSCornerRadius.medium)
        #expect(DSCornerRadius.medium < DSCornerRadius.large)
        #expect(DSCornerRadius.large < DSCornerRadius.full)
    }
}
