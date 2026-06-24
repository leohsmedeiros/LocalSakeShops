---
description: "Task list for Design System Foundation"
---

# Tasks: Design System Foundation

**Input**: Design documents from `specs/001-design-system-foundation/`

**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ ✅ | quickstart.md ✅

**Tests**: Included — constitution Principle VI mandates unit tests for all business logic and
UI/snapshot tests for all visual components. Unit tests are written before implementation
(TDD) for pure token types. UI snapshot tests follow implementation (components must exist
to compile).

**Organization**: Tasks are grouped by user story to enable independent implementation and
testing of each story.

## Format: `[ID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- All file paths are relative to the repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the canonical design system reference before any code is written.
All token values in subsequent tasks are sourced from this file.

- [X] T001 Create `docs/DESIGN.md` — document all token tables (10 colors with light/dark hex values, 11 typography levels with size/weight, 6 spacing values, 5 corner radii, 4 shadow levels, 15 icons) and component specs (DSPrimaryButton, DSSecondaryButton, DSCard, DSTextStyle) per `specs/001-design-system-foundation/data-model.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the Xcode folder group structure and Asset Catalog color sets that
all token Swift files depend on. No user story implementation can begin until T002 and T003
are complete.

**⚠️ CRITICAL**: Phases 3, 4, and 5 MUST NOT begin until this phase is complete.

- [X] T002 Create `LocalSakeShops/DesignSystem/` folder group in Xcode project with sub-groups `Tokens/`, `Components/`, and `Preview/` — use Xcode "New Group without Folder" then associate with physical directories `LocalSakeShops/DesignSystem/Tokens/`, `LocalSakeShops/DesignSystem/Components/`, `LocalSakeShops/DesignSystem/Preview/`
- [X] T003 [P] Add 10 named Color Sets to `LocalSakeShops/Assets.xcassets`: `DSPrimary`, `DSSecondary`, `DSBackground`, `DSSurface`, `DSOnPrimary`, `DSOnSurface`, `DSSubdued`, `DSError`, `DSSuccess`, `DSWarning` — set Light and Dark Appearance hex values per `docs/DESIGN.md` color token table

**Checkpoint**: Folder structure created, all 10 Asset Color Sets defined in xcassets — Phase 3+ can begin.

---

## Phase 3: User Story 1 — Consistent Visual Experience (Priority: P1) 🎯 MVP

**Goal**: Color tokens are the centralized source for all color decisions. Dark mode adapts
automatically via Asset Catalog. Changing one token propagates everywhere.

**Independent Test**: Run `DSColorTests` — all 10 tokens resolve to non-nil Color values.
Toggle simulator appearance to Dark and verify all tokens adapt without any manual override.

### Tests for User Story 1 ⚠️ Write First — Confirm Failure Before T005

- [X] T004 [P] [US1] Create `LocalSakeShopsTests/DesignSystem/DSColorTests.swift` (add to `LocalSakeShopsTests` target) — write `XCTestCase` with one test per token asserting `DSColor.<token>` is accessible and the asset name resolves; create an empty stub `enum DSColor {}` first so the project compiles, then confirm tests fail at runtime before T005 provides real values

### Implementation for User Story 1

- [X] T005 [P] [US1] Implement `LocalSakeShops/DesignSystem/Tokens/DSColor.swift` — caseless `enum DSColor` with 10 `static let` Color properties referencing Asset Catalog names (`Color("DSPrimary")` etc.); include `///` doc comment on the enum declaration and each token property; add file to `LocalSakeShops` target

**Checkpoint**: `DSColorTests` compile and pass. Simulator dark mode toggles all colors correctly. User Story 1 is independently functional.

---

## Phase 4: User Story 2 — Token-Driven Feature Development (Priority: P2)

**Goal**: All remaining token categories (typography, spacing, corner radius, shadow, icon)
are defined as typed Swift APIs. A feature screen can be fully built with no hardcoded values.
`ContentView` is updated as a living proof-of-concept.

**Independent Test**: Run all token unit tests (T006–T010 assertions pass). Open updated
`ContentView` — zero hardcoded visual literals appear in the file.

### Tests for User Story 2 ⚠️ Write First — Confirm Failure Before Implementations

- [X] T006 [P] [US2] Create `LocalSakeShopsTests/DesignSystem/DSTypographyTests.swift` (add to `LocalSakeShopsTests` target) — test each of the 11 `DSTypography` tokens returns a non-nil `Font` value; create empty stubs before writing tests
- [X] T007 [P] [US2] Create `LocalSakeShopsTests/DesignSystem/DSSpacingTests.swift` (add to `LocalSakeShopsTests` target) — test all 6 `DSSpacing` CGFloat constants match the values in `docs/DESIGN.md` (xs=4, sm=8, md=16, lg=24, xl=32, xxl=48)
- [X] T008 [P] [US2] Create `LocalSakeShopsTests/DesignSystem/DSCornerRadiusTests.swift` (add to `LocalSakeShopsTests` target) — test all 5 `DSCornerRadius` CGFloat constants match `docs/DESIGN.md` (none=0, small=4, medium=8, large=16, full=9999)
- [X] T009 [P] [US2] Create `LocalSakeShopsTests/DesignSystem/DSShadowTests.swift` (add to `LocalSakeShopsTests` target) — test `DSShadow.none` has zero radius and clear color; `DSShadow.low`, `.medium`, `.high` have increasing radius and y-offset per `docs/DESIGN.md`
- [X] T010 [P] [US2] Create `LocalSakeShopsTests/DesignSystem/DSIconTests.swift` (add to `LocalSakeShopsTests` target) — instantiate each of the 15 `DSIcon` tokens and assert they produce a valid `Image`

### Implementation for User Story 2

- [X] T011 [P] [US2] Implement `LocalSakeShops/DesignSystem/Tokens/DSTypography.swift` — caseless `enum DSTypography` with 11 `static let Font` constants using `Font.system(size:weight:)` per `docs/DESIGN.md` typography table; include `///` doc comments on enum and each token; add file to `LocalSakeShops` target
- [X] T012 [P] [US2] Implement `LocalSakeShops/DesignSystem/Tokens/DSSpacing.swift` — caseless `enum DSSpacing` with 6 `static let CGFloat` constants (xs, sm, md, lg, xl, xxl); include `///` doc comments on enum and each constant; add to `LocalSakeShops` target
- [X] T013 [P] [US2] Implement `LocalSakeShops/DesignSystem/Tokens/DSCornerRadius.swift` — caseless `enum DSCornerRadius` with 5 `static let CGFloat` constants (none, small, medium, large, full); include `///` doc comments on enum and each constant; add to `LocalSakeShops` target
- [X] T014 [P] [US2] Implement `LocalSakeShops/DesignSystem/Tokens/DSShadow.swift` — define `struct DSShadowStyle { let color: Color; let radius: CGFloat; let y: CGFloat }`, caseless `enum DSShadow` with 4 static `DSShadowStyle` constants, and `extension View { func dsShadow(_ style: DSShadowStyle) -> some View }` convenience modifier; include `///` doc comments on struct, enum, and extension; add to `LocalSakeShops` target
- [X] T015 [P] [US2] Implement `LocalSakeShops/DesignSystem/Tokens/DSIcon.swift` — caseless `enum DSIcon` with 15 `static let Image` properties wrapping `Image(systemName:)` with SF Symbol strings per `docs/DESIGN.md` icon table; include `///` doc comments on enum and each property; add to `LocalSakeShops` target
- [X] T016 [US2] Update `LocalSakeShops/ContentView.swift` to replace all hardcoded values with DS tokens — replace `.tint` with `DSColor.primary`, `.padding()` with `.padding(DSSpacing.md)`, add `Text("LocalSakeShops").font(DSTypography.title1).foregroundColor(DSColor.onSurface)`; serves as living validation that tokens are usable (depends on T011–T015)

**Checkpoint**: All 5 token unit test files compile and pass. `ContentView.swift` contains zero hardcoded color, spacing, or font literals. User Story 2 is independently functional.

---

## Phase 5: User Story 3 — Reusable Component Library (Priority: P3)

**Goal**: Four shared components (DSPrimaryButton, DSSecondaryButton, DSCard, DSTextStyle)
built exclusively from design tokens. A `DesignSystemPreview` screen renders all tokens and
components in all states. UI snapshot tests capture and validate their appearance.

**Independent Test**: Open `DesignSystemPreview` in simulator — all four components render
correctly in all supported states in both light and dark mode. UI snapshot tests produce
`XCTAttachment` screenshots (note: these are screenshot captures, not pixel-diff comparisons)
with no failures.

### Implementation for User Story 3

- [X] T017 [P] [US3] Implement `LocalSakeShops/DesignSystem/Components/DSPrimaryButton.swift` — `struct DSPrimaryButton: View` with `init(title: String, isLoading: Bool = false, isDisabled: Bool = false, action: @escaping () -> Void)`; filled background `DSColor.primary`, text `DSColor.onPrimary`, font `DSTypography.callout`, corner radius `DSCornerRadius.medium`, padding `DSSpacing.md` vertical / `DSSpacing.xl` horizontal, min height 48pt, disabled opacity 0.4, loading state shows `ProgressView` in place of label; include `///` doc comments on struct declaration and `init`; include `#Preview`; add to `LocalSakeShops` target
- [X] T018 [P] [US3] Implement `LocalSakeShops/DesignSystem/Components/DSSecondaryButton.swift` — same API as `DSPrimaryButton`; outlined style: transparent background, 1.5pt `DSColor.primary` stroke overlay, `DSColor.primary` text; reuse `DSTypography.callout`, `DSCornerRadius.medium`, same padding and min height; disabled opacity 0.4, loading state; include `///` doc comments on struct declaration and `init`; include `#Preview`; add to `LocalSakeShops` target
- [X] T019 [P] [US3] Implement `LocalSakeShops/DesignSystem/Components/DSCard.swift` — `struct DSCard<Content: View>: View` with `@ViewBuilder content` init; `DSColor.surface` background, `DSCornerRadius.large` clip, `.dsShadow(DSShadow.low)` modifier, `.padding(DSSpacing.md)` inner padding; generic over `Content`; include `///` doc comments on struct declaration and `init`; include `#Preview` with sample content; add to `LocalSakeShops` target
- [X] T020 [P] [US3] Implement `LocalSakeShops/DesignSystem/Components/DSTextStyle.swift` — `struct DSTextStyle: ViewModifier` applying a `DSTypography` `Font` and a `DSColor` foreground color; expose `extension View { func dsTextStyle(_ font: Font, color: Color = DSColor.onSurface) -> some View }` as the call-site API; include `///` doc comments on the `ViewModifier`, its `body`, and the `View` extension method; include `#Preview` demonstrating each text hierarchy; add to `LocalSakeShops` target (covers FR-007 text style wrappers)
- [X] T021 [US3] Implement `LocalSakeShops/DesignSystem/Preview/DesignSystemPreview.swift` — `struct DesignSystemPreview: View` showing: color swatch grid (all 10 `DSColor` tokens with labels), typography scale (all 11 levels using `.dsTextStyle`), spacing ruler (all 6 values as horizontal bars), corner radius samples, shadow level samples, `DSPrimaryButton` in enabled/disabled/loading, `DSSecondaryButton` in enabled/disabled/loading, `DSCard` with sample content; use `ScrollView` to fit all sections; include `#Preview`; update `LocalSakeShops/ContentView.swift` to present `DesignSystemPreview` as the root view; add to `LocalSakeShops` target (depends on T017, T018, T019, T020)

### Tests for User Story 3

- [X] T022 [P] [US3] Create `LocalSakeShopsUITests/DesignSystem/DesignSystemSnapshotTests.swift` (add to `LocalSakeShopsUITests` target) — `XCTestCase` subclass using `XCUIApplication` that launches the app, navigates to `DesignSystemPreview`, captures `XCTAttachment` screenshots of: (a) full preview in light mode, (b) full preview in dark mode (via launch arguments), (c) `DSPrimaryButton` enabled state close-up, (d) `DSPrimaryButton` disabled state close-up; attach all screenshots to test results; note: these are screenshot captures for visual review, not automated pixel-diff snapshot tests (depends on T021)

**Checkpoint**: Simulator renders `DesignSystemPreview` correctly. All four components display in all defined states. UI snapshot test produces screenshot attachments with no failures. User Story 3 is independently functional.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final documentation audit and validation against the full quickstart checklist.

- [X] T023 [P] Audit `///` inline documentation — verify all public and internal members carry doc comments in `DSColor.swift`, `DSTypography.swift`, `DSSpacing.swift`, `DSCornerRadius.swift`, `DSShadow.swift`, `DSIcon.swift`, `DSPrimaryButton.swift`, `DSSecondaryButton.swift`, `DSCard.swift`, `DSTextStyle.swift` per constitution Principle IV; add any missing comments
- [X] T024 Run full validation per `specs/001-design-system-foundation/quickstart.md` — (a) build project: 0 errors, 0 warnings; (b) run all unit tests: 0 failures; (c) grep for hardcoded values: zero matches in `LocalSakeShops/DesignSystem/Components/` and any `Features/`; (d) verify Dynamic Type scaling using Xcode Accessibility Inspector (enable largest accessibility size in simulator and confirm all text scales without truncation); (e) verify foreground/background token pairs meet WCAG AA contrast ratio (4.5:1 minimum for body text) using the Accessibility Inspector Color Contrast tool for `DSColor.onSurface` on `DSColor.background` and `DSColor.onPrimary` on `DSColor.primary`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately with T001
- **Foundational (Phase 2)**: Depends on T001 (docs/DESIGN.md must exist to source token values) — BLOCKS all user story phases
- **US1 (Phase 3)**: Depends on Foundational (T002, T003) — can start after Phase 2
- **US2 (Phase 4)**: Depends on Foundational (T002) — can start in parallel with US1; T016 depends on T011–T015
- **US3 (Phase 5)**: Depends on all token files from US2 (T011–T015) — components consume token namespaces; T021 depends on T017–T020; T022 depends on T021
- **Polish (Phase N)**: Depends on all user stories complete

### User Story Dependencies

- **US1 (P1)**: Requires T002, T003 complete (asset color sets exist for `DSColor` to reference)
- **US2 (P2)**: Requires T002 complete (folder structure); token files T011–T015 are independent of each other; T016 requires T011–T015
- **US3 (P3)**: Requires T011–T015 complete (components consume all token namespaces); T021 requires T017–T020; T022 requires T021

### Within Each Phase

- For token types: create an empty stub (e.g., `enum DSColor {}`) before writing the test file so the project compiles; test assertions then fail at runtime (true red) before the real implementation is written
- All [P] tasks within a phase can execute concurrently
- T016 (ContentView update) runs after T011–T015 complete
- T021 (DesignSystemPreview) runs after T017–T020 complete
- T022 (snapshot tests) runs after T021 complete

---

## Parallel Opportunities

### Phase 3 (US1) — can run concurrently:
```
Task: "Write DSColorTests.swift" (T004)
Task: "Implement DSColor.swift" (T005)
```
Write T004 first, confirm assertions fail at runtime, then implement T005.

### Phase 4 (US2) — all tests can run concurrently:
```
Task: "Write DSTypographyTests.swift" (T006)
Task: "Write DSSpacingTests.swift" (T007)
Task: "Write DSCornerRadiusTests.swift" (T008)
Task: "Write DSShadowTests.swift" (T009)
Task: "Write DSIconTests.swift" (T010)
```

Then all implementations can run concurrently:
```
Task: "Implement DSTypography.swift" (T011)
Task: "Implement DSSpacing.swift" (T012)
Task: "Implement DSCornerRadius.swift" (T013)
Task: "Implement DSShadow.swift" (T014)
Task: "Implement DSIcon.swift" (T015)
```

### Phase 5 (US3) — four components run concurrently:
```
Task: "Implement DSPrimaryButton.swift" (T017)
Task: "Implement DSSecondaryButton.swift" (T018)
Task: "Implement DSCard.swift" (T019)
Task: "Implement DSTextStyle.swift" (T020)
```

---

## Implementation Strategy

### MVP First (User Story 1 — Color Foundation Only)

1. Complete Phase 1: Create docs/DESIGN.md (T001)
2. Complete Phase 2: Folder structure + Asset Color Sets (T002, T003)
3. Complete Phase 3: DSColor + DSColorTests (T004, T005)
4. **STOP and VALIDATE**: Toggle dark mode in simulator — all 10 color tokens adapt
5. Verify DSColorTests pass: 0 failures

### Incremental Delivery

1. MVP complete (Phase 1–3) → Color foundation working
2. Add Phase 4 (US2) → All token types available; ContentView uses only DS tokens
3. Add Phase 5 (US3) → Reusable components; DesignSystemPreview renders full catalog
4. Each story adds value without breaking previous stories

---

## Notes

- [P] tasks = different files, no shared state, can run concurrently
- [Story] label maps task to its user story for traceability
- Each user story is independently completable and testable
- For token unit tests: create empty stubs before writing tests so `⌘B` succeeds; test assertions then fail at runtime before real implementations land
- UI snapshot tests (T022) are written after components exist (required to compile); these are `XCTAttachment` screenshot captures, not pixel-diff comparison tests
- All DS token enums are caseless (`enum DSToken { static let ... }`) — not `class`, not `struct`
- `DSShadow.swift` is the only token file containing a `struct` (`DSShadowStyle`) alongside its enum
- `DSCard` uses a generic `@ViewBuilder` — the only generics in the design system
- Commit after each checkpoint (end of Phase 3, 4, 5, N) or after each logical task group
