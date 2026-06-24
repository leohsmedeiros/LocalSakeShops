# Implementation Plan: Design System Foundation

**Branch**: `001-design-system-foundation` | **Date**: 2026-06-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-design-system-foundation/spec.md`

## Summary

Establish the centralized design system layer for the LocalSakeShops iOS app. This delivers
typed Swift token APIs for colors, typography, spacing, corner radius, shadows, and icons —
all mapped from `docs/DESIGN.md` — plus three reusable SwiftUI components (`DSPrimaryButton`,
`DSSecondaryButton`, `DSCard`). All future feature screens will consume this layer exclusively;
no hardcoded visual values are permitted after this feature lands.

## Technical Context

**Language/Version**: Swift 5.9 / Swift 5.10 (Xcode 15+)

**Primary Dependencies**: SwiftUI (Apple-native, no third-party dependencies)

**Storage**: N/A — design tokens are compile-time constants; asset colors stored in
`Assets.xcassets` as named Color Sets

**Testing**: XCTest (unit tests for token values), XCUITest + XCTAttachment (UI/snapshot
tests for components), SwiftUI `#Preview` macros for visual documentation

**Target Platform**: iOS 16+

**Project Type**: iOS mobile app (single Xcode target, folder-group module strategy)

**Performance Goals**: Design system is compile-time; zero runtime overhead. Component
render performance: 60fps on all supported devices (baseline SwiftUI expectation).

**Constraints**: No third-party libraries. All tokens use Apple-native constructs.
Color tokens require Asset Catalog Color Sets for automatic dark mode adaptation.

**Scale/Scope**: ~6 token files, ~3 component files, ~1 preview file, ~6 test files.
Foundation for all future feature screens.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Notes |
|------|--------|-------|
| I. Swift & SwiftUI — all code in Swift, SwiftUI for views | ✅ PASS | No UIKit, no Objective-C |
| II. Clean MVVM Modular — feature-first folder, DI | ✅ PASS | `DesignSystem/` is a self-contained folder group; tokens are pure value types with no dependencies |
| III. Design System — `docs/DESIGN.md` as source of truth | ✅ PASS | `docs/DESIGN.md` is the first deliverable (T001); all tokens derived from it |
| IV. Code Quality — no duplication, one type per file, no hardcoded values | ✅ PASS | Each `DS*` enum is its own file; tokens replace all literals |
| V. Networking & Error Handling | ✅ N/A | Design system has no network calls |
| VI. Testing — unit tests + UI/snapshot tests, dedicated mock files | ✅ PASS | Planned: `DSColorTests`, snapshot via `XCTAttachment`; no mocks needed (tokens are value types) |
| VII. Simplicity — no premature abstractions | ✅ PASS | Folder group (not SPM package); enums (not protocols); no generics beyond `DSCard<Content>` |
| Architecture Constraint — no third-party deps without approval | ✅ PASS | SwiftUI + XCTest only |
| Architecture Constraint — one file per type | ✅ PASS | Each enum/struct in its own file |

**Post-design re-check**: All gates continue to pass. No violations to justify.

## Project Structure

### Documentation (this feature)

```text
specs/001-design-system-foundation/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 — module strategy, color palette, testing approach
├── data-model.md        # Phase 1 — all token values and component specs
├── quickstart.md        # Phase 1 — validation guide
├── contracts/
│   └── design-system-api.md   # Public Swift API surface contract
└── checklists/
    └── requirements.md  # Spec quality checklist (all passed)
```

### Source Code (repository root)

```text
LocalSakeShops/
├── DesignSystem/
│   ├── Tokens/
│   │   ├── DSColor.swift          # Color token namespace enum
│   │   ├── DSTypography.swift     # Typography token namespace enum
│   │   ├── DSSpacing.swift        # Spacing token namespace enum
│   │   ├── DSCornerRadius.swift   # Corner radius token namespace enum
│   │   ├── DSShadow.swift         # Shadow token struct + namespace enum + View extension
│   │   └── DSIcon.swift           # Icon token namespace enum
│   ├── Components/
│   │   ├── DSPrimaryButton.swift  # Filled primary action button
│   │   ├── DSSecondaryButton.swift# Outlined secondary action button
│   │   └── DSCard.swift           # Generic card container view
│   └── Preview/
│       └── DesignSystemPreview.swift # Full token + component preview (dev only)
├── Assets.xcassets/
│   └── Colors/                    # Named Color Sets for all DSColor tokens
│       ├── DSPrimary.colorset/
│       ├── DSSecondary.colorset/
│       ├── DSBackground.colorset/
│       ├── DSSurface.colorset/
│       ├── DSOnPrimary.colorset/
│       ├── DSOnSurface.colorset/
│       ├── DSSubdued.colorset/
│       ├── DSError.colorset/
│       ├── DSSuccess.colorset/
│       └── DSWarning.colorset/
├── LocalSakeShopsApp.swift        # Existing — unchanged
└── ContentView.swift              # Existing — updated to show DesignSystemPreview

docs/
└── DESIGN.md                     # First deliverable — canonical design system reference

LocalSakeShopsTests/
└── DesignSystem/
    ├── DSColorTests.swift
    ├── DSTypographyTests.swift
    ├── DSSpacingTests.swift
    ├── DSCornerRadiusTests.swift
    ├── DSShadowTests.swift
    └── DSIconTests.swift

LocalSakeShopsUITests/
└── DesignSystem/
    └── DesignSystemSnapshotTests.swift
```

**Structure Decision**: Single Xcode target with a `DesignSystem/` folder group. No SPM
package — justified by constitution Principle VII (simplicity) and the project's single-target
scope. Extraction to a package is a future option if a second target is added.

## Complexity Tracking

> No constitution violations. No complexity justification required.
