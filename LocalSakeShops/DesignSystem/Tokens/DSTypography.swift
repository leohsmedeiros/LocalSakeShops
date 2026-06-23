import SwiftUI

/// A single typography style entry combining font, size, weight, and letter spacing.
struct DSTypographyStyle {
    /// The SwiftUI Font value.
    let font: Font
    /// The point size (used in tests to verify token values).
    let size: CGFloat
    /// The letter spacing in ems (relative to point size).
    let tracking: CGFloat
}

/// Centralized typography token namespace for the LocalSakeShops design system.
///
/// Typography is mapped from `docs/DESIGN.md`:
/// - Headlines use Manrope (falls back to system font if not bundled).
/// - Body copy uses Hanken Grotesk (falls back to system font if not bundled).
///
/// Feature screens MUST reference text styles through this namespace and MUST NOT
/// use raw `Font` literals or hardcoded point sizes.
enum DSTypography {

    /// Large display text — 40pt, weight 700, Manrope.
    static let display = DSTypographyStyle(
        font: .custom("Manrope-Bold", size: 40, relativeTo: .largeTitle),
        size: 40,
        tracking: -0.02 * 40
    )

    /// Large headline — 32pt, weight 600, Manrope.
    static let headlineLarge = DSTypographyStyle(
        font: .custom("Manrope-SemiBold", size: 32, relativeTo: .title),
        size: 32,
        tracking: 0
    )

    /// Medium headline — 24pt, weight 600, Manrope.
    static let headlineMedium = DSTypographyStyle(
        font: .custom("Manrope-SemiBold", size: 24, relativeTo: .title2),
        size: 24,
        tracking: 0
    )

    /// Small headline — 20pt, weight 600, Manrope.
    static let headlineSmall = DSTypographyStyle(
        font: .custom("Manrope-SemiBold", size: 20, relativeTo: .title3),
        size: 20,
        tracking: 0
    )

    /// Large body copy — 18pt, weight 400, Hanken Grotesk.
    static let bodyLarge = DSTypographyStyle(
        font: .custom("HankenGrotesk-Regular", size: 18, relativeTo: .body),
        size: 18,
        tracking: 0
    )

    /// Default body copy — 16pt, weight 400, Hanken Grotesk.
    static let bodyMedium = DSTypographyStyle(
        font: .custom("HankenGrotesk-Regular", size: 16, relativeTo: .body),
        size: 16,
        tracking: 0
    )

    /// Prominent label — 14pt, weight 600, Hanken Grotesk, wide tracking.
    static let labelLarge = DSTypographyStyle(
        font: .custom("HankenGrotesk-SemiBold", size: 14, relativeTo: .callout),
        size: 14,
        tracking: 0.05 * 14
    )

    /// Small label — 12pt, weight 500, Hanken Grotesk.
    static let labelSmall = DSTypographyStyle(
        font: .custom("HankenGrotesk-Medium", size: 12, relativeTo: .caption),
        size: 12,
        tracking: 0
    )
}
