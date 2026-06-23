import SwiftUI

/// Full design system preview — tokens and components in one scrollable canvas.
///
/// This view acts as the live catalogue for all design decisions. It is wired
/// to `ContentView` as the root during development and is the target of the
/// snapshot tests in `DesignSystemSnapshotTests`.
struct DesignSystemPreview: View {

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DSSpacing.xl) {
                    colorSection
                    typographySection
                    spacingSection
                    cornerRadiusSection
                    shadowSection
                    iconSection
                    buttonSection
                    cardSection
                }
                .padding(.horizontal, DSSpacing.margin)
                .padding(.vertical, DSSpacing.lg)
            }
            .background(DSColor.background)
            .navigationTitle("Design System")
        }
    }

    // MARK: - Sections

    private var colorSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Colors")
            colorRow("primary", DSColor.primary)
            colorRow("secondary", DSColor.secondary)
            colorRow("background", DSColor.background)
            colorRow("surface", DSColor.surface)
            colorRow("onPrimary", DSColor.onPrimary)
            colorRow("onSurface", DSColor.onSurface)
            colorRow("subdued", DSColor.subdued)
            colorRow("error", DSColor.error)
            colorRow("success", DSColor.success)
            colorRow("warning", DSColor.warning)
        }
    }

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            sectionHeader("Typography")
            Text("Display — 40pt").dsTextStyle(DSTypography.display).lineLimit(1).minimumScaleFactor(0.5)
            Text("Headline Large — 32pt").dsTextStyle(DSTypography.headlineLarge)
            Text("Headline Medium — 24pt").dsTextStyle(DSTypography.headlineMedium)
            Text("Headline Small — 20pt").dsTextStyle(DSTypography.headlineSmall)
            Text("Body Large — 18pt").dsTextStyle(DSTypography.bodyLarge)
            Text("Body Medium — 16pt").dsTextStyle(DSTypography.bodyMedium)
            Text("Label Large — 14pt").dsTextStyle(DSTypography.labelLarge)
            Text("Label Small — 12pt").dsTextStyle(DSTypography.labelSmall)
        }
    }

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Spacing")
            spacingRow("xs", DSSpacing.xs)
            spacingRow("sm", DSSpacing.sm)
            spacingRow("md", DSSpacing.md)
            spacingRow("lg", DSSpacing.lg)
            spacingRow("xl", DSSpacing.xl)
            spacingRow("gutter", DSSpacing.gutter)
            spacingRow("margin", DSSpacing.margin)
        }
    }

    private var cornerRadiusSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Corner Radius")
            radiusRow("none", DSCornerRadius.none)
            radiusRow("small", DSCornerRadius.small)
            radiusRow("medium", DSCornerRadius.medium)
            radiusRow("large", DSCornerRadius.large)
            radiusRow("full (pill)", min(DSCornerRadius.full, 32))
        }
    }

    private var shadowSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            sectionHeader("Shadows")
            HStack(spacing: DSSpacing.md) {
                shadowSwatch("none", .none)
                shadowSwatch("low", .low)
                shadowSwatch("medium", .medium)
                shadowSwatch("high", .high)
            }
        }
    }

    private var iconSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Icons")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: DSSpacing.sm) {
                iconCell(DSIcon.search, "search")
                iconCell(DSIcon.back, "back")
                iconCell(DSIcon.favorite, "favorite")
                iconCell(DSIcon.favoriteFilled, "fav.filled")
                iconCell(DSIcon.map, "map")
                iconCell(DSIcon.location, "location")
                iconCell(DSIcon.filter, "filter")
                iconCell(DSIcon.share, "share")
                iconCell(DSIcon.info, "info")
                iconCell(DSIcon.close, "close")
                iconCell(DSIcon.menu, "menu")
                iconCell(DSIcon.calendar, "calendar")
                iconCell(DSIcon.phone, "phone")
                iconCell(DSIcon.website, "website")
                iconCell(DSIcon.chevronRight, "chevron.r")
            }
        }
    }

    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Buttons")
            DSPrimaryButton(label: "Primary Action") {}
            DSPrimaryButton(label: "Primary Disabled", action:  {}, isEnabled: false)
            DSSecondaryButton(label: "Secondary Action") {}
            DSSecondaryButton(label: "Secondary Disabled", action:  {}, isEnabled: false)
        }
    }

    private var cardSection: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            sectionHeader("Card")
            DSCard {
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text("Kura Sake Shop").dsTextStyle(DSTypography.headlineSmall)
                    Text("Shinjuku, Tokyo").dsTextStyle(DSTypography.bodyMedium, color: DSColor.subdued)
                    HStack(spacing: DSSpacing.xs) {
                        Image(systemName: DSIcon.location)
                        Text("0.4 km away").dsTextStyle(DSTypography.labelSmall, color: DSColor.subdued)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .dsTextStyle(DSTypography.labelLarge, color: DSColor.subdued)
            .padding(.top, DSSpacing.sm)
    }

    private func colorRow(_ name: String, _ color: Color) -> some View {
        HStack(spacing: DSSpacing.sm) {
            RoundedRectangle(cornerRadius: DSCornerRadius.small)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: DSCornerRadius.small)
                        .stroke(DSColor.subdued.opacity(0.3), lineWidth: 0.5)
                )
            Text(name).dsTextStyle(DSTypography.bodyMedium)
        }
    }

    private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
        HStack(spacing: DSSpacing.sm) {
            Rectangle()
                .fill(DSColor.secondary)
                .frame(width: value, height: 16)
                .cornerRadius(DSCornerRadius.small)
            Text("\(name) — \(Int(value))pt").dsTextStyle(DSTypography.bodyMedium)
        }
    }

    private func radiusRow(_ name: String, _ radius: CGFloat) -> some View {
        HStack(spacing: DSSpacing.sm) {
            RoundedRectangle(cornerRadius: radius)
                .stroke(DSColor.primary, lineWidth: 2)
                .frame(width: 48, height: 32)
            Text("\(name) — \(Int(radius))pt").dsTextStyle(DSTypography.bodyMedium)
        }
    }

    private func shadowSwatch(_ name: String, _ shadow: DSShadow) -> some View {
        VStack(spacing: DSSpacing.xs) {
            RoundedRectangle(cornerRadius: DSCornerRadius.medium)
                .fill(DSColor.surface)
                .frame(width: 60, height: 60)
                .dsShadow(shadow)
            Text(name).dsTextStyle(DSTypography.labelSmall, color: DSColor.subdued)
        }
    }

    private func iconCell(_ symbol: String, _ label: String) -> some View {
        VStack(spacing: DSSpacing.xs) {
            Image(systemName: symbol)
                .font(.system(size: 24))
                .foregroundColor(DSColor.onSurface)
                .frame(width: 40, height: 40)
            Text(label)
                .dsTextStyle(DSTypography.labelSmall, color: DSColor.subdued)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

#Preview {
    DesignSystemPreview()
}
