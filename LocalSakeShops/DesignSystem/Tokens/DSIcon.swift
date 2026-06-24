import Foundation

/// Centralized icon token namespace for the LocalSakeShops design system.
///
/// All icon references MUST use this namespace instead of raw SF Symbols strings.
/// This decouples feature code from system icon names and provides a single point
/// of change if icons are swapped for custom assets. Values are SF Symbols identifiers.
enum DSIcon {

    /// Magnifying glass — search and find actions.
    static let search = "magnifyingglass"

    /// Chevron left — back navigation.
    static let back = "chevron.left"

    /// Heart outline — add to favorites.
    static let favorite = "heart"

    /// Heart filled — item is favorited.
    static let favoriteFilled = "heart.fill"

    /// Map — view map or location overview.
    static let map = "map"

    /// Map pin — specific location marker.
    static let location = "mappin.and.ellipse"

    /// Slider — filter and sort controls.
    static let filter = "slider.horizontal.3"

    /// Share — system share sheet.
    static let share = "square.and.arrow.up"

    /// Info circle — details or help content.
    static let info = "info.circle"

    /// X mark — dismiss or close a sheet.
    static let close = "xmark"

    /// Three horizontal lines — navigation menu or sidebar.
    static let menu = "line.3.horizontal"

    /// Calendar — date or event information.
    static let calendar = "calendar"

    /// Phone — call action.
    static let phone = "phone"

    /// Globe — external website link.
    static let website = "globe"

    /// Chevron right — inline navigation or disclosure.
    static let chevronRight = "chevron.right"

    /// Star outline — empty rating star.
    static let star = "star"

    /// Star filled — full rating star.
    static let starFill = "star.fill"

    /// Star half-filled — half rating star.
    static let starHalfFill = "star.leadinghalf.filled"

    /// Generic image placeholder — shown when a shop photo is unavailable.
    static let shopPlaceholder = "photo"
}
