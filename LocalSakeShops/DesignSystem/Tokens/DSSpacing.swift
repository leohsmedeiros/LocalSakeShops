import CoreFoundation

/// Centralized spacing token namespace for the LocalSakeShops design system.
///
/// All padding, margin, and layout gap values MUST reference these named constants.
/// Raw numeric values are forbidden in feature screens. Token values are defined in
/// `docs/DESIGN.md`.
enum DSSpacing {

    /// 4pt — micro spacing for tight element grouping.
    static let xs: CGFloat = 4

    /// 8pt — small spacing for related items within a component.
    static let sm: CGFloat = 8

    /// 16pt — default spacing for intra-section padding and gaps.
    static let md: CGFloat = 16

    /// 24pt — large spacing for section separation.
    static let lg: CGFloat = 24

    /// 40pt — extra-large spacing for major layout sections.
    static let xl: CGFloat = 40

    /// 16pt — horizontal content gutter (alias of `md` for semantic clarity).
    static let gutter: CGFloat = 16

    /// 20pt — screen edge margin.
    static let margin: CGFloat = 20

    /// 60pt — large system image icon size (e.g. AsyncImage placeholder).
    static let iconLarge: CGFloat = 60
}
