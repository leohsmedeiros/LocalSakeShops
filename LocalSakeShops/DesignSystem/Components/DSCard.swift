import SwiftUI

/// A generic card container view built exclusively on design system tokens.
///
/// Cards provide a surface background with 16pt corner radius and a low-elevation
/// shadow, matching the card specification in `docs/DESIGN.md`. The content is
/// padded with 20pt on all sides.
///
/// ```swift
/// DSCard {
///     VStack(alignment: .leading, spacing: DSSpacing.sm) {
///         Text("Kura Sake Shop").font(DSTypography.headlineSmall.font)
///         Text("Shinjuku, Tokyo").font(DSTypography.bodyMedium.font)
///     }
/// }
/// ```
struct DSCard<Content: View>: View {
    
    /// The content rendered inside the card.
    let content: Content
    let customBackgroundColor: Color?

    init(@ViewBuilder content: () -> Content, backgroundColor: Color? = nil) {
        self.content = content()
        self.customBackgroundColor = backgroundColor
    }

    var body: some View {
        content
            .padding(DSSpacing.margin)
            .background(customBackgroundColor ?? DSColor.surface)
            .cornerRadius(DSCornerRadius.large)
            .dsShadow(.low)
    }
}

#Preview {
    DSCard {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("Kura Sake Shop")
                .font(DSTypography.headlineSmall.font)
                .foregroundColor(DSColor.onSurface)
            Text("Shinjuku, Tokyo")
                .font(DSTypography.bodyMedium.font)
                .foregroundColor(DSColor.subdued)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(DSSpacing.md)
    .background(DSColor.background)
}
