import SwiftUI

/// A filled primary action button built exclusively on design system tokens.
///
/// Use this component for the most prominent action on a screen (e.g., "Find Shops",
/// "Confirm"). Supports enabled and disabled states with automatic visual feedback.
/// Minimum tap target height is 48pt per accessibility guidelines.
///
/// ```swift
/// DSPrimaryButton(label: "Find Shops") {
///     viewModel.search()
/// }
/// ```
struct DSPrimaryButton: View {

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
                .foregroundColor(DSColor.onPrimary)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 48)
                .padding(.horizontal, DSSpacing.md)
        }
        .background(isEnabled ? DSColor.primary : DSColor.subdued)
        .cornerRadius(DSCornerRadius.large)
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.15), value: isEnabled)
    }
}

#Preview {
    VStack(spacing: DSSpacing.md) {
        DSPrimaryButton(label: "Find Shops") {}
        DSPrimaryButton(label: "Disabled", action: {}, isEnabled: false)
    }
    .padding(DSSpacing.md)
}

