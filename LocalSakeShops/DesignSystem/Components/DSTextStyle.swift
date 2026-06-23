import SwiftUI

/// A ViewModifier that applies a design system typography style and color to a Text view.
///
/// Use `dsTextStyle(_:color:)` instead of setting `.font()` and `.foregroundColor()`
/// directly, which would require hardcoding values.
///
/// ```swift
/// Text("Discover Local Sake")
///     .dsTextStyle(.headlineLarge)
///
/// Text("Secondary note")
///     .dsTextStyle(.bodyMedium, color: DSColor.subdued)
/// ```
struct DSTextStyleModifier: ViewModifier {

    /// The typography style to apply.
    let style: DSTypographyStyle
    /// The foreground color; defaults to `DSColor.onSurface`.
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.tracking)
            .foregroundColor(color)
    }
}

extension View {
    /// Applies a design system typography token and optional color to the view.
    func dsTextStyle(_ style: DSTypographyStyle, color: Color = DSColor.onSurface) -> some View {
        modifier(DSTextStyleModifier(style: style, color: color))
    }
}

#Preview {
    VStack(alignment: .leading, spacing: DSSpacing.sm) {
        Text("Display — 40pt")
            .dsTextStyle(DSTypography.display)
        Text("Headline Large — 32pt")
            .dsTextStyle(DSTypography.headlineLarge)
        Text("Headline Medium — 24pt")
            .dsTextStyle(DSTypography.headlineMedium)
        Text("Headline Small — 20pt")
            .dsTextStyle(DSTypography.headlineSmall)
        Text("Body Large — 18pt")
            .dsTextStyle(DSTypography.bodyLarge)
        Text("Body Medium — 16pt")
            .dsTextStyle(DSTypography.bodyMedium)
        Text("Label Large — 14pt")
            .dsTextStyle(DSTypography.labelLarge)
        Text("Label Small — 12pt")
            .dsTextStyle(DSTypography.labelSmall)
    }
    .padding(DSSpacing.md)
    .background(DSColor.background)
}
