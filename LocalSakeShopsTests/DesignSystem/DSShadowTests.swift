import Testing
import SwiftUI
@testable import LocalSakeShops

@Suite("DSShadow Token Tests")
struct DSShadowTests {

    @Test func noneHasZeroRadius() {
        #expect(DSShadow.none.radius == 0)
    }

    @Test func lowHasPositiveRadius() {
        #expect(DSShadow.low.radius > 0)
    }

    @Test func mediumRadiusGreaterThanLow() {
        #expect(DSShadow.medium.radius > DSShadow.low.radius)
    }

    @Test func highRadiusGreaterThanMedium() {
        #expect(DSShadow.high.radius > DSShadow.medium.radius)
    }

    @Test func shadowHasColorComponent() {
        let shadow = DSShadow.low
        let _ = shadow.color
    }

    @Test func shadowHasOffsetComponents() {
        let shadow = DSShadow.medium
        let _ = shadow.x
        let _ = shadow.y
    }
}
