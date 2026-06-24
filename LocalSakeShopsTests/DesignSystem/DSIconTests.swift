import Testing
@testable import LocalSakeShops

@Suite("DSIcon Token Tests")
struct DSIconTests {

    @Test func searchSymbolIsNonEmpty() {
        #expect(!DSIcon.search.isEmpty)
    }

    @Test func backSymbolIsNonEmpty() {
        #expect(!DSIcon.back.isEmpty)
    }

    @Test func favoriteSymbolIsNonEmpty() {
        #expect(!DSIcon.favorite.isEmpty)
    }

    @Test func favoriteFilledSymbolIsNonEmpty() {
        #expect(!DSIcon.favoriteFilled.isEmpty)
    }

    @Test func mapSymbolIsNonEmpty() {
        #expect(!DSIcon.map.isEmpty)
    }

    @Test func locationSymbolIsNonEmpty() {
        #expect(!DSIcon.location.isEmpty)
    }

    @Test func filterSymbolIsNonEmpty() {
        #expect(!DSIcon.filter.isEmpty)
    }

    @Test func shareSymbolIsNonEmpty() {
        #expect(!DSIcon.share.isEmpty)
    }

    @Test func infoSymbolIsNonEmpty() {
        #expect(!DSIcon.info.isEmpty)
    }

    @Test func closeSymbolIsNonEmpty() {
        #expect(!DSIcon.close.isEmpty)
    }

    @Test func menuSymbolIsNonEmpty() {
        #expect(!DSIcon.menu.isEmpty)
    }

    @Test func calendarSymbolIsNonEmpty() {
        #expect(!DSIcon.calendar.isEmpty)
    }

    @Test func phoneSymbolIsNonEmpty() {
        #expect(!DSIcon.phone.isEmpty)
    }

    @Test func websiteSymbolIsNonEmpty() {
        #expect(!DSIcon.website.isEmpty)
    }

    @Test func chevronRightSymbolIsNonEmpty() {
        #expect(!DSIcon.chevronRight.isEmpty)
    }

    @Test func starSymbolIsNonEmpty() {
        #expect(!DSIcon.star.isEmpty)
    }

    @Test func starFillSymbolIsNonEmpty() {
        #expect(!DSIcon.starFill.isEmpty)
    }

    @Test func starHalfFillSymbolIsNonEmpty() {
        #expect(!DSIcon.starHalfFill.isEmpty)
    }

    @Test func shopPlaceholderSymbolIsNonEmpty() {
        #expect(!DSIcon.shopPlaceholder.isEmpty)
    }
}
