# Contract: Design System Public API

**Feature**: 001-design-system-foundation
**Date**: 2026-06-23

This document defines the public API surface that all feature screens MUST use to access
design tokens and components. No feature may bypass this contract by using hardcoded values.

---

## Token API Contract

### `DSColor` — Color Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSColor.swift
enum DSColor {
    static let primary:    Color  // Brand primary (deep sake-red)
    static let secondary:  Color  // Brand secondary (aged gold)
    static let background: Color  // Screen/page background
    static let surface:    Color  // Card, sheet, field background
    static let onPrimary:  Color  // Text/icons on primary color
    static let onSurface:  Color  // Body text on surface/background
    static let subdued:    Color  // Secondary text, metadata
    static let error:      Color  // Error states
    static let success:    Color  // Success states
    static let warning:    Color  // Warning states
}
```

**Usage**: `Text("Label").foregroundColor(DSColor.onSurface)`
**Forbidden**: `Text("Label").foregroundColor(Color(hex: "#1A1714"))`

---

### `DSTypography` — Typography Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSTypography.swift
enum DSTypography {
    static let largeTitle:  Font
    static let title1:      Font
    static let title2:      Font
    static let title3:      Font
    static let headline:    Font
    static let subheadline: Font
    static let body:        Font
    static let callout:     Font
    static let footnote:    Font
    static let caption1:    Font
    static let caption2:    Font
}
```

**Usage**: `Text("Title").font(DSTypography.title1)`
**Forbidden**: `Text("Title").font(.system(size: 28, weight: .bold))`

---

### `DSSpacing` — Spacing Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSSpacing.swift
enum DSSpacing {
    static let xs:  CGFloat   // 4pt
    static let sm:  CGFloat   // 8pt
    static let md:  CGFloat   // 16pt
    static let lg:  CGFloat   // 24pt
    static let xl:  CGFloat   // 32pt
    static let xxl: CGFloat   // 48pt
}
```

**Usage**: `.padding(.horizontal, DSSpacing.md)`
**Forbidden**: `.padding(.horizontal, 16)`

---

### `DSCornerRadius` — Corner Radius Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSCornerRadius.swift
enum DSCornerRadius {
    static let none:   CGFloat  // 0pt
    static let small:  CGFloat  // 4pt
    static let medium: CGFloat  // 8pt
    static let large:  CGFloat  // 16pt
    static let full:   CGFloat  // 9999pt (capsule)
}
```

**Usage**: `.cornerRadius(DSCornerRadius.large)`
**Forbidden**: `.cornerRadius(16)`

---

### `DSShadowStyle` & `DSShadow` — Shadow Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSShadow.swift
struct DSShadowStyle {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
}

enum DSShadow {
    static let none:   DSShadowStyle
    static let low:    DSShadowStyle
    static let medium: DSShadowStyle
    static let high:   DSShadowStyle
}

// Convenience View extension
extension View {
    func dsShadow(_ style: DSShadowStyle) -> some View
}
```

**Usage**: `CardView().dsShadow(DSShadow.low)`
**Forbidden**: `.shadow(color: .black.opacity(0.08), radius: 4, y: 2)`

---

### `DSIcon` — Icon Tokens

```swift
// File: LocalSakeShops/DesignSystem/Tokens/DSIcon.swift
enum DSIcon {
    static let search:         Image
    static let back:           Image
    static let forward:        Image
    static let close:          Image
    static let favorite:       Image
    static let favoriteFilled: Image
    static let location:       Image
    static let locationFilled: Image
    static let shop:           Image
    static let filter:         Image
    static let share:          Image
    static let star:           Image
    static let starFilled:     Image
    static let info:           Image
    static let checkmark:      Image
}
```

**Usage**: `DSIcon.search.resizable()`
**Forbidden**: `Image(systemName: "magnifyingglass")`

---

## Component API Contract

### `DSPrimaryButton`

```swift
// File: LocalSakeShops/DesignSystem/Components/DSPrimaryButton.swift
struct DSPrimaryButton: View {
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    )
}
```

**Usage**:
```swift
DSPrimaryButton(title: "Find Sake Shops") {
    viewModel.searchShops()
}
```

**Forbidden**: Reimplementing a filled button with `DSColor.primary` background in a feature view.

---

### `DSSecondaryButton`

```swift
// File: LocalSakeShops/DesignSystem/Components/DSSecondaryButton.swift
struct DSSecondaryButton: View {
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    )
}
```

---

### `DSCard`

```swift
// File: LocalSakeShops/DesignSystem/Components/DSCard.swift
struct DSCard<Content: View>: View {
    init(@ViewBuilder content: () -> Content)
}
```

**Usage**:
```swift
DSCard {
    VStack(alignment: .leading) {
        Text(shop.name).font(DSTypography.headline)
        Text(shop.address).font(DSTypography.subheadline)
    }
}
```

---

## Design System Preview

A single `DesignSystemPreview` view (not a feature screen) renders all tokens and components
for visual validation.

```swift
// File: LocalSakeShops/DesignSystem/Preview/DesignSystemPreview.swift
struct DesignSystemPreview: View {
    // Renders all color swatches, type scale, spacing scale,
    // shadow levels, and all components in enabled/disabled/loading states.
}
```

This view is accessible from `ContentView` during development and is never part of
the production navigation flow for end users.

---

## Enforcement Rules

1. Any `Color(...)` literal in a feature file → **constitution violation**
2. Any `.system(size:weight:)` font in a feature file → **constitution violation**
3. Any raw `CGFloat` for padding/spacing in a feature file → **constitution violation**
4. Any `Image(systemName:)` call in a feature file → **constitution violation**
5. Any `shadow(...)` modifier with raw values in a feature file → **constitution violation**

All violations are caught during code review per the Development Workflow in the constitution.
