import CoreFoundation

/// Centralized corner radius token namespace for the LocalSakeShops design system.
///
/// All rounded-corner values MUST reference these named constants. Raw numeric
/// radius values are forbidden in feature screens. Token values are defined in
/// `docs/DESIGN.md`.
enum DSCornerRadius {

    /// 0pt — sharp corners; used for full-bleed or flush elements.
    static let none: CGFloat = 0

    /// 4pt — subtle rounding; used for chips and tags.
    static let small: CGFloat = 4

    /// 8pt — default rounding; used for inputs and most UI surfaces.
    static let medium: CGFloat = 8

    /// 16pt — pronounced rounding; used for cards and sheets.
    static let large: CGFloat = 16

    /// 9999pt — pill shape; used for badges, pills, and full-round buttons.
    static let full: CGFloat = 9999
}
