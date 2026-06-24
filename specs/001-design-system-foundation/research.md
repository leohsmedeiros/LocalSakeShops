# Research: Design System Foundation

**Feature**: 001-design-system-foundation
**Date**: 2026-06-23

## Decision Log

### Decision 1: DesignSystem Module Strategy — Folder Group vs. Swift Package

**Decision**: Folder group inside the main Xcode target (no separate Swift Package Manager module).

**Rationale**: The project is a single Xcode target at an early stage. Creating a local
SPM package adds build system complexity, a separate `Package.swift`, and cross-target
dependency wiring that is not yet justified. A well-organized `DesignSystem/` folder group
inside `LocalSakeShops/` delivers the same logical isolation (one folder, one concern) with
zero overhead. If the project grows to multiple targets or apps, extraction to a package is
a clean, low-risk refactor.

**Alternatives considered**:
- Local Swift Package: Clean module isolation but premature; violates constitution Principle VII.
- Framework target: Heavyweight, not needed at single-app scale.

---

### Decision 2: Color Token Implementation — Asset Catalog vs. Programmatic

**Decision**: Named Color Sets in `Assets.xcassets` with a typed `DSColor` namespace enum
that references them by name.

**Rationale**: Asset catalog Color Sets natively support light/dark mode via Appearance
slots, require zero runtime logic, and integrate with SwiftUI's `Color(named:)` initializer.
The `DSColor` Swift enum provides a strongly-typed, autocomplete-friendly API that shields
callers from raw string asset names. This is the Apple-recommended pattern.

**Alternatives considered**:
- Programmatic `UIColor(dynamicProvider:)`: More verbose, harder to preview in Xcode.
- Single hardcoded `Color` extension with fixed hex: No dark mode support.

---

### Decision 3: Typography Token Implementation — System Fonts vs. Custom Fonts

**Decision**: iOS Dynamic Type system fonts mapped to a typed `DSTypography` namespace that
returns `Font` values and `ViewModifier` convenience wrappers.

**Rationale**: The project has no custom font assets. System fonts respect Dynamic Type,
accessibility settings, and require no font embedding or licensing. The `DSTypography` enum
provides named hierarchy levels that map to system font descriptors, keeping options open to
swap in a custom font later by changing one file.

**Alternatives considered**:
- Custom font files: No assets provided; premature to embed placeholder fonts.
- Direct `.font(.title)` usage in views: Bypasses the design system and hardcodes hierarchy.

---

### Decision 4: Snapshot Testing Approach — Third-Party vs. Native XCTest

**Decision**: Unit tests for token correctness using XCTest; UI snapshot tests using
`XCTAttachment`-based screenshot capture in `XCUITest`. No third-party snapshot library.

**Rationale**: The constitution requires explicit approval for third-party dependencies.
`swift-snapshot-testing` (PointFree) is the de-facto iOS snapshot library but has not
been approved. `XCTAttachment` screenshots integrated into UI tests provide a baseline
snapshot capability using only Apple tooling. Component previews via `#Preview` macros
serve as visual documentation and manual validation during development.

**Alternatives considered**:
- `swift-snapshot-testing`: Best-in-class but requires third-party approval.
- No snapshot tests: Violates constitution Principle VI (UI/snapshot tests mandatory).

---

### Decision 5: Icon Token Implementation — Asset Bundle vs. SF Symbols

**Decision**: SF Symbols as the primary icon source, referenced via a typed `DSIcon` enum
that wraps `Image(systemName:)` calls.

**Rationale**: SF Symbols are built into iOS, automatically adapt to Dynamic Type weight
and accessibility sizes, support multicolor rendering, and require no asset export workflow.
The `DSIcon` enum provides semantic names (`.search`, `.favorite`) decoupled from SF Symbol
string identifiers. Custom SVG icons can be added to `Assets.xcassets` and handled through
the same enum as the app grows.

**Alternatives considered**:
- Asset catalog SVG icons: Requires design export workflow not yet established.
- Raw `Image(systemName:)` calls in views: Couples views to symbol string identifiers.

---

### Decision 6: Color Palette for a Sake Shop App

**Decision**: Warm, understated Japanese aesthetic — deep burgundy primary, muted gold
secondary, warm off-white backgrounds.

**Rationale**: A sake shop app benefits from colors that evoke warmth, craft, and
authenticity. The palette was chosen to feel premium and culturally resonant without
being overly decorative.

| Token | Light Mode | Dark Mode |
|-------|-----------|-----------|
| primary | `#6B1C1C` (deep sake-red) | `#A84343` |
| secondary | `#8C6914` (aged gold) | `#C49A2A` |
| background | `#F7F4EF` (warm parchment) | `#131211` |
| surface | `#FFFFFF` | `#242220` |
| onPrimary | `#FFFFFF` | `#FFFFFF` |
| onSurface | `#1A1714` | `#EDE8E3` |
| subdued | `#6B6560` | `#8A8480` |
| error | `#C0392B` | `#E74C3C` |
| success | `#1E7B34` | `#27AE60` |
| warning | `#C07A00` | `#F0A500` |

---

### Decision 7: docs/DESIGN.md Creation Timing

**Decision**: `docs/DESIGN.md` is the first implementation artifact — created before any
Swift token files. This fulfills the spec requirement that it serve as the source of truth.

**Rationale**: The spec and constitution both mandate `docs/DESIGN.md` as the canonical
design system reference. Creating it first (T001) means every subsequent token file has
a documented source to validate against.
