# Quickstart: Validate Design System Foundation

**Feature**: 001-design-system-foundation
**Date**: 2026-06-23

This guide describes how to validate that the design system is correctly implemented
and fully functional.

---

## Prerequisites

- Xcode 15+ installed
- iOS 16+ simulator available
- Project cloned and `LocalSakeShops.xcodeproj` opens without errors

---

## Step 1: Verify docs/DESIGN.md Exists

```bash
cat docs/DESIGN.md
```

**Expected**: File exists, contains all 10 color tokens, 11 typography tokens, 6 spacing
tokens, 5 corner radius tokens, 4 shadow tokens, and 15 icon tokens with their values.

---

## Step 2: Build the Project

Open `LocalSakeShops.xcodeproj` in Xcode, select an iOS 16+ simulator, press ⌘B.

**Expected**: Zero warnings, zero errors. All `DS*` token files compile successfully.

---

## Step 3: Run Unit Tests

In Xcode, press ⌘U or run:

```bash
xcodebuild test \
  -project LocalSakeShops.xcodeproj \
  -scheme LocalSakeShops \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  -testPlan LocalSakeShopsTests
```

**Expected tests pass**:
- `DSColorTests` — all 10 color tokens resolve to non-nil `Color` values
- `DSTypographyTests` — all 11 typography tokens return the correct font sizes and weights
- `DSSpacingTests` — all 6 spacing tokens match documented point values
- `DSCornerRadiusTests` — all 5 corner radius tokens match documented point values
- `DSShadowTests` — shadow styles have correct radius, y-offset, and color opacity
- `DSIconTests` — all 15 icon tokens return non-empty `Image` values

**Expected**: 0 failures, all test targets compile and run.

---

## Step 4: Preview the Design System

In Xcode, open `LocalSakeShops/DesignSystem/Preview/DesignSystemPreview.swift` and
click the Preview canvas (⌘+Option+Return).

**Expected visual output** (in light mode):
- Color swatch grid showing all 10 named tokens with their labels
- Type scale showing all 11 typography levels from `largeTitle` to `caption2`
- Spacing ruler showing all 6 spacing values as horizontal bars
- Corner radius samples at none, small, medium, large, and full
- Shadow samples for none, low, medium, and high
- Component row: `DSPrimaryButton` in enabled, disabled, and loading states
- Component row: `DSSecondaryButton` in enabled, disabled, and loading states
- Component row: `DSCard` with sample content

---

## Step 5: Validate Dark Mode

In the Xcode Preview canvas for `DesignSystemPreview.swift`, toggle the appearance to Dark.

**Expected**: All color tokens update correctly — primary changes from deep burgundy to
the lighter dark-mode value, background changes from warm parchment to near-black, etc.
No color remains fixed (appears identical in both modes) except `onPrimary` (white in both).

---

## Step 6: Verify No Hardcoded Values in Feature Files

Run a search across all Swift files for common hardcoded patterns:

```bash
# Should return zero results in DesignSystem/ and Features/ directories
grep -rn 'Color(#\|\.black\|\.white\|\.red\|\.blue\|\.gray' \
  LocalSakeShops/Features/ LocalSakeShops/DesignSystem/Components/ 2>/dev/null

grep -rn 'Image(systemName:' \
  LocalSakeShops/Features/ LocalSakeShops/DesignSystem/Components/ 2>/dev/null

grep -rn 'font(.system(size:' \
  LocalSakeShops/Features/ LocalSakeShops/DesignSystem/Components/ 2>/dev/null
```

**Expected**: Zero matches. All visual references go through `DS*` token namespaces.

---

## Step 7: Validate Component Behavior

Open `DesignSystemPreview.swift` in the simulator (or via Preview) and interact with:

1. **DSPrimaryButton (enabled)** — tap → action fires, button responds to press.
2. **DSPrimaryButton (disabled)** — appears at reduced opacity, tap is ignored.
3. **DSPrimaryButton (loading)** — shows spinner, tap is ignored.
4. **DSSecondaryButton** — same three state checks.
5. **DSCard** — content inside card is visible, padded, rounded, and slightly elevated.

---

## Done Criteria

| Check | Expected Result |
|-------|----------------|
| `docs/DESIGN.md` exists | Complete with all token tables |
| Project builds | 0 errors, 0 warnings |
| All unit tests pass | 0 failures |
| Design system preview renders | All tokens and components visible |
| Dark mode toggle works | All tokens adapt correctly |
| No hardcoded values (grep) | 0 matches |
| Component states work | Enabled / Disabled / Loading all correct |
