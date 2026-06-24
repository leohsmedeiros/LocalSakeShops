# Data Model: Design System Foundation

**Feature**: 001-design-system-foundation
**Date**: 2026-06-23

This document defines every design token and component in the system. It is the authoritative
source for `docs/DESIGN.md` and all Swift token files.

---

## Token Categories

### 1. Color Tokens — `DSColor`

All colors are defined as named Color Sets in `Assets.xcassets`. Each set has two slots:
Light appearance and Dark appearance.

| Token Name | Light (#hex) | Dark (#hex) | Role |
|------------|-------------|------------|------|
| `primary` | `#6B1C1C` | `#A84343` | Brand color; primary actions, key accents |
| `secondary` | `#8C6914` | `#C49A2A` | Supporting brand; secondary accents, highlights |
| `background` | `#F7F4EF` | `#131211` | Page / screen background |
| `surface` | `#FFFFFF` | `#242220` | Card, sheet, input field backgrounds |
| `onPrimary` | `#FFFFFF` | `#FFFFFF` | Text/icons placed on top of `primary` |
| `onSurface` | `#1A1714` | `#EDE8E3` | Body text / primary icons on surface/background |
| `subdued` | `#6B6560` | `#8A8480` | Secondary text, placeholders, metadata |
| `error` | `#C0392B` | `#E74C3C` | Error states, destructive actions |
| `success` | `#1E7B34` | `#27AE60` | Confirmation, success states |
| `warning` | `#C07A00` | `#F0A500` | Caution, warnings |

**Swift API**:
```swift
// Namespace enum — one file per token group
enum DSColor {
    static let primary    = Color("DSPrimary")
    static let secondary  = Color("DSSecondary")
    static let background = Color("DSBackground")
    static let surface    = Color("DSSurface")
    static let onPrimary  = Color("DSOnPrimary")
    static let onSurface  = Color("DSOnSurface")
    static let subdued    = Color("DSSubdued")
    static let error      = Color("DSError")
    static let success    = Color("DSSuccess")
    static let warning    = Color("DSWarning")
}
```

---

### 2. Typography Tokens — `DSTypography`

All type styles use iOS Dynamic Type system fonts. Each token maps to a `Font` value.

| Token Name | Size (pt) | Weight | Use Case |
|------------|-----------|--------|----------|
| `largeTitle` | 34 | Bold | Hero headings, app title areas |
| `title1` | 28 | Bold | Section headers, screen titles |
| `title2` | 22 | Bold | Sub-section headers |
| `title3` | 20 | Semibold | Card titles, list section headers |
| `headline` | 17 | Semibold | Emphasized body, primary list labels |
| `subheadline` | 15 | Regular | Supporting labels, secondary content |
| `body` | 17 | Regular | Main reading text |
| `callout` | 16 | Regular | Action labels, form fields |
| `footnote` | 13 | Regular | Metadata, timestamps, fine print |
| `caption1` | 12 | Regular | Image captions, badge labels |
| `caption2` | 11 | Regular | Legal copy, minimum-size labels |

**Swift API**:
```swift
enum DSTypography {
    static let largeTitle   = Font.system(size: 34, weight: .bold)
    static let title1       = Font.system(size: 28, weight: .bold)
    static let title2       = Font.system(size: 22, weight: .bold)
    static let title3       = Font.system(size: 20, weight: .semibold)
    static let headline     = Font.system(size: 17, weight: .semibold)
    static let subheadline  = Font.system(size: 15, weight: .regular)
    static let body         = Font.system(size: 17, weight: .regular)
    static let callout      = Font.system(size: 16, weight: .regular)
    static let footnote     = Font.system(size: 13, weight: .regular)
    static let caption1     = Font.system(size: 12, weight: .regular)
    static let caption2     = Font.system(size: 11, weight: .regular)
}
```

---

### 3. Spacing Tokens — `DSSpacing`

A named 8-point-grid scale covering all padding, margin, and layout gap needs.

| Token Name | Value (pt) | Typical Use |
|------------|-----------|-------------|
| `xs` | 4 | Icon padding, tight insets |
| `sm` | 8 | Between inline elements, small gaps |
| `md` | 16 | Standard content padding, card insets |
| `lg` | 24 | Section spacing, between cards |
| `xl` | 32 | Screen-level horizontal padding, large gaps |
| `xxl` | 48 | Hero section margins, top-of-screen offset |

**Swift API**:
```swift
enum DSSpacing {
    static let xs:  CGFloat = 4
    static let sm:  CGFloat = 8
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}
```

---

### 4. Corner Radius Tokens — `DSCornerRadius`

| Token Name | Value (pt) | Typical Use |
|------------|-----------|-------------|
| `none` | 0 | Full-width dividers, rule lines |
| `small` | 4 | Chips, tags, inline badges |
| `medium` | 8 | Buttons, input fields |
| `large` | 16 | Cards, sheets, modals |
| `full` | 9999 | Capsule pills, circular elements |

**Swift API**:
```swift
enum DSCornerRadius {
    static let none:   CGFloat = 0
    static let small:  CGFloat = 4
    static let medium: CGFloat = 8
    static let large:  CGFloat = 16
    static let full:   CGFloat = 9999
}
```

---

### 5. Shadow Tokens — `DSShadow`

| Token Name | Color Opacity | Blur (pt) | Y Offset (pt) | Typical Use |
|------------|--------------|-----------|--------------|-------------|
| `none` | 0 | 0 | 0 | Flat elements, items on colored backgrounds |
| `low` | 0.08 | 4 | 2 | Cards on same-colored background, subtle lift |
| `medium` | 0.12 | 8 | 4 | Floating cards, list rows with depth |
| `high` | 0.18 | 16 | 8 | Modals, bottom sheets, overlays |

Shadow color base: `#000000`.

**Swift API**:
```swift
struct DSShadowStyle {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
}

enum DSShadow {
    static let none   = DSShadowStyle(color: .clear, radius: 0,  y: 0)
    static let low    = DSShadowStyle(color: Color.black.opacity(0.08), radius: 4,  y: 2)
    static let medium = DSShadowStyle(color: Color.black.opacity(0.12), radius: 8,  y: 4)
    static let high   = DSShadowStyle(color: Color.black.opacity(0.18), radius: 16, y: 8)
}
```

---

### 6. Icon Tokens — `DSIcon`

All icons use SF Symbols unless noted. Semantic names decouple views from raw symbol strings.

| Token Name | SF Symbol | Use Case |
|------------|-----------|----------|
| `search` | `magnifyingglass` | Search bars, search actions |
| `back` | `chevron.left` | Navigation back button |
| `forward` | `chevron.right` | Disclosure indicators |
| `close` | `xmark` | Dismiss sheets, clear inputs |
| `favorite` | `heart` | Save / wishlist (inactive) |
| `favoriteFilled` | `heart.fill` | Save / wishlist (active) |
| `location` | `location` | Location / map context |
| `locationFilled` | `location.fill` | Active location |
| `shop` | `storefront` | Shop / store listings |
| `filter` | `line.3.horizontal.decrease` | Filter / sort controls |
| `share` | `square.and.arrow.up` | Share sheet |
| `star` | `star` | Rating (inactive) |
| `starFilled` | `star.fill` | Rating (active) |
| `info` | `info.circle` | Info / help |
| `checkmark` | `checkmark` | Confirmation, selection |

**Swift API**:
```swift
enum DSIcon {
    static let search          = Image(systemName: "magnifyingglass")
    static let back            = Image(systemName: "chevron.left")
    static let forward         = Image(systemName: "chevron.right")
    static let close           = Image(systemName: "xmark")
    static let favorite        = Image(systemName: "heart")
    static let favoriteFilled  = Image(systemName: "heart.fill")
    static let location        = Image(systemName: "location")
    static let locationFilled  = Image(systemName: "location.fill")
    static let shop            = Image(systemName: "storefront")
    static let filter          = Image(systemName: "line.3.horizontal.decrease")
    static let share           = Image(systemName: "square.and.arrow.up")
    static let star            = Image(systemName: "star")
    static let starFilled      = Image(systemName: "star.fill")
    static let info            = Image(systemName: "info.circle")
    static let checkmark       = Image(systemName: "checkmark")
}
```

---

## Reusable Components

### Component 1: `DSPrimaryButton`

A filled, prominent action button using the `primary` color token.

**Inputs**:
- `title: String` — button label
- `isLoading: Bool` (default: `false`) — shows activity indicator instead of label
- `isDisabled: Bool` (default: `false`) — reduces opacity, disables interaction
- `action: () -> Void` — tap handler

**Visual States**: enabled, disabled (opacity 0.4), loading (spinner replaces text)
**Corner radius**: `DSCornerRadius.medium`
**Background**: `DSColor.primary`
**Text color**: `DSColor.onPrimary`
**Font**: `DSTypography.callout`
**Padding**: `DSSpacing.md` vertical, `DSSpacing.xl` horizontal
**Min height**: 48pt

---

### Component 2: `DSSecondaryButton`

An outlined button for secondary or supporting actions.

**Inputs**: same as `DSPrimaryButton`

**Visual States**: enabled, disabled (opacity 0.4), loading
**Corner radius**: `DSCornerRadius.medium`
**Border**: 1.5pt stroke using `DSColor.primary`
**Background**: transparent
**Text color**: `DSColor.primary`
**Font**: `DSTypography.callout`
**Padding**: `DSSpacing.md` vertical, `DSSpacing.xl` horizontal
**Min height**: 48pt

---

### Component 3: `DSCard`

A surface container for grouping related content.

**Inputs**:
- `content: () -> Content` — any SwiftUI view

**Visual properties**:
- Background: `DSColor.surface`
- Corner radius: `DSCornerRadius.large`
- Shadow: `DSShadow.low`
- Inner padding: `DSSpacing.md`
- No border

---

## Token Naming Convention

All token namespaces use the `DS` prefix to signal membership in the design system:
`DSColor`, `DSTypography`, `DSSpacing`, `DSCornerRadius`, `DSShadow`, `DSIcon`.

All component names use the `DS` prefix: `DSPrimaryButton`, `DSSecondaryButton`, `DSCard`.

One Swift type per file. File name matches the type name exactly.
