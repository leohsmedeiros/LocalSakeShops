import SwiftUI

/// Centralized color token namespace for the LocalSakeShops design system.
///
/// All feature screens MUST reference colors through this namespace.
/// Direct `Color(...)` literals are forbidden in feature code.
///
/// Colors are backed by named Color Sets in `Assets.xcassets` which provide
/// automatic light / dark mode adaptation. Token values are defined in `docs/DESIGN.md`.
enum DSColor {

    /// Brand primary — Deep Indigo. Used for primary actions and key accents.
    static let primary = Color("DSPrimary")

    /// Brand secondary — Warm Cedar. Used for supporting accents and highlights.
    static let secondary = Color("DSSecondary")

    /// Page and screen background — Washi Paper off-white / near-black.
    static let background = Color("DSBackground")

    /// Card, sheet, and input field background — pure white / dark surface.
    static let surface = Color("DSSurface")

    /// Text and icons placed on top of the primary color.
    static let onPrimary = Color("DSOnPrimary")

    /// Body text and primary icons on surface or background.
    static let onSurface = Color("DSOnSurface")

    /// Secondary text, placeholders, and metadata labels.
    static let subdued = Color("DSSubdued")

    /// Error states and destructive actions.
    static let error = Color("DSError")

    /// Confirmation and success states.
    /// Note: pending official addition to docs/DESIGN.md.
    static let success = Color("DSSuccess")

    /// Caution and warning states.
    /// Note: pending official addition to docs/DESIGN.md.
    static let warning = Color("DSWarning")
}
