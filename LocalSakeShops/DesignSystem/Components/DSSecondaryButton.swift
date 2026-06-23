import SwiftUI

/// An outlined secondary action button built exclusively on design system tokens.
///
/// Use this component for supporting actions that accompany a primary action
/// (e.g., "View on Map", "Cancel"). The stroke weight is 1.5pt using the secondary
/// brand color per `docs/DESIGN.md`.
///
/// ```swift
/// DSSecondaryButton(label: "View on Map") {
///     viewModel.openMap()
/// }
/// ```
struct DSSecondaryButton: View {

    /// The text displayed inside the button.
    let label: String
    /// The action invoked when the button is tapped.
    let action: () -> Void
    /// Controls whether the button accepts user interaction.
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(DSTypography.labelLarge.font)
                .tracking(DSTypography.labelLarge.tracking)
                .foregroundColor(isEnabled ? DSColor.secondary : DSColor.subdued)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
                .padding(.horizontal, DSSpacing.md)
                .overlay(
                    RoundedRectangle(cornerRadius: DSCornerRadius.large)
                        .stroke(
                            isEnabled ? DSColor.secondary : DSColor.subdued,
                            lineWidth: 1.5
                        )
                )
        }
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
}

#Preview {
    VStack(spacing: DSSpacing.md) {
        DSSecondaryButton(label: "View on Map") {}
        DSSecondaryButton(label: "Disabled", action: {}, isEnabled: false)
    }
    .padding(DSSpacing.md)
}
