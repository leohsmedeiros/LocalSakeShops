# LocalSakeShops

This project is a native iOS application built as part of a technical challenge. It showcases a clean, design-system-driven interface for discovering local sake shops in Nagano, Japan. Users can browse a curated list of breweries and specialty shops, view shop details, open locations in Maps, and access shop websites directly from the app.

---

## Features

- **Shop list** — scrollable list of local sake shops with name, address, and star rating
- **Shop detail** — full profile with photo, description, rating, tappable address (opens Maps), and website button
- **Graceful degradation** — placeholder image when no photo is available; website button hidden when URL is absent
- **State handling** — loading, empty, and error states on every data-loading screen
- **Dark mode** — all colors adapt automatically via the Kura & Craft design system
- **Dynamic Type** — all text scales with system accessibility settings

---

## Requirements

| Requirement | Version |
|-------------|---------|
| Xcode | 16+ |
| iOS Deployment Target | 26.5+ |
| Swift | 5.9+ |
| Device | iPhone (all sizes, portrait & landscape) |

---

## Setup

No package manager or dependency installation is required.

```bash
git clone <repo-url>
open LocalSakeShops.xcodeproj
```

Select an iPhone simulator (iOS 26.5+) and press **⌘R** to build and run.

> **Test target note**: To run `BundledJSONDataSourceTests`, ensure `sake_shops.json` is
> added to the `LocalSakeShopsTests` target membership in Xcode
> (File Inspector → Target Membership). Without it, the integration test will fail
> with a file-not-found error.

---

## Dependencies

**None.** The project uses only Apple-provided frameworks:

| Framework | Purpose |
|-----------|---------|
| SwiftUI | All views, navigation, and URL opening via `@Environment(\.openURL)` |
| Foundation | Data models, URL handling, JSON decoding |
| XCTest / Swift Testing | Unit and UI tests |

There are no third-party libraries, SPM packages, or CocoaPods.

---

## Architecture

The project follows **Clean Architecture** with a **layer-first Modular structure** inside a single Xcode target. Domain and Data are top-level layers independent of any feature; only the presentation layer (Views + ViewModels) is organised under `Features/`.

```
Views → ViewModels → Domain (Use Cases, Entities) → Data (Repositories, DTOs, Mappers)
```

The project intentionally uses a **layer-first modular structure** instead of a strict **feature-first modular structure** because, at this scale, Clean Architecture’s dependency rules are more important than folder-level feature isolation.

In a single Xcode target, shared business concepts such as `SakeShop`, repository protocols, domain errors, and use cases naturally belong to the application’s domain layer, not to one specific feature. Forcing a feature-first structure without package module boundaries would either duplicate shared domain types across features or require hoisting them back to a shared layer, which weakens the purpose of the structure.

The trade-off is that feature folders contain only the presentation concerns, while Domain and Data remain centralized and reusable. A true feature-first architecture would become more appropriate if the project evolved into separate Swift Package Manager modules, where each feature could own its own isolated Domain, Data, and Presentation layers at the compiler level.

### Folder structure

```
LocalSakeShops/
├── Features/
│   ├── SakeShopList/
│   │   ├── Views/          # SakeShopListView, SakeShopRowView
│   │   └── ViewModels/     # SakeShopListViewModel
│   └── SakeShopDetail/
│       ├── Views/          # SakeShopDetailView
│       └── ViewModels/     # SakeShopDetailViewModel
├── Domain/
│   ├── Entities/           # SakeShop (Identifiable, Equatable, Hashable)
│   ├── Repositories/       # SakeShopRepositoryProtocol
│   ├── UseCases/           # FetchSakeShopsUseCase + protocol
│   └── Errors/             # SakeShopError (LocalizedError)
├── Data/
│   ├── DataSources/        # BundledJSONDataSource (generic, reusable) + protocol
│   ├── Repositories/       # SakeShopRepository
│   ├── DTOs/               # SakeShopDTO (Decodable)
│   └── Mappers/            # SakeShopMapper (DTO → Entity)
├── Shared/
│   ├── State/              # ViewState<T> enum
│   └── Views/              # MapCardView, StarRatingView
├── DesignSystem/
│   ├── Tokens/             # DSColor, DSTypography, DSSpacing, DSIcon, …
│   ├── Components/         # DSPrimaryButton, DSSecondaryButton, DSCard, DSTextStyle
│   └── Preview/            # DesignSystemPreview (canvas preview target)
└── Resources/
    ├── Assets.xcassets     # Color assets backing DSColor tokens
    └── sake_shops.json     # Bundled data source

LocalSakeShopsTests/
├── Mocks/                  # MockSakeShopRepository, MockFetchSakeShopsUseCase,
│                           # MockBundledJSONDataSource
└── Features/
    ├── SakeShopList/       # SakeShopListViewModelTests
    ├── SakeShopDetail/     # SakeShopDetailViewModelTests
    ├── Domain/             # FetchSakeShopsUseCaseTests
    └── Data/               # BundledJSONDataSourceTests, SakeShopMapperTests,
                            # SakeShopRepositoryTests

LocalSakeShopsUITests/
└── Features/               # SakeShopSnapshotTests (XCTAttachment screenshots)
```

### Key design decisions

- **`BundledJSONDataSource<T: Decodable>`** is generic and reusable. Adding support for a new JSON-backed feature requires only a new DTO, mapper, and repository — the data source itself needs no changes.
- **`ViewState<T>`** is a single enum replacing multiple `@Published` booleans, eliminating impossible UI states.
- **`SakeShop: Hashable`** enables typed `NavigationStack` destinations without a router layer.
- **`SakeShopMapper.parseURL` validates `url.scheme != nil`** because iOS 26's Swift Foundation changed `URL(string:)` to return non-nil for relative-reference strings (e.g. `"no-scheme-here"`). Requiring a non-nil scheme ensures only absolute URLs reach the domain layer.
- All dependencies flow inward via constructor injection through protocols, keeping every layer independently testable.

---

## Design System

The app uses the **Kura & Craft** design system, documented in `docs/DESIGN.md`.

| Token namespace | Purpose |
|-----------------|---------|
| `DSColor` | Colors (primary, surface, error, subdued, …) with automatic dark mode |
| `DSTypography` | Type styles (display, headline, body, label) using Manrope & Hanken Grotesk |
| `DSSpacing` | Spacing scale (xs=4 → xl=40) + named tokens (margin, gutter, iconLarge) |
| `DSCornerRadius` | Corner radius scale (small=4 → full=9999) |
| `DSShadow` | Elevation levels (none, low, medium, high) |
| `DSIcon` | SF Symbols aliases — feature code never uses raw symbol strings |

Raw color literals, font names, spacing values, and SF Symbol strings are forbidden in feature code. The T032 validation step (`grep -rn "Color(" LocalSakeShops/Features/`) enforces this.

---

## Testing

Run all tests with **⌘U** in Xcode.

| Suite | Type | Count | What it covers |
|-------|------|-------|----------------|
| `BundledJSONDataSourceTests` | Integration | 3 | Bundle JSON loading, missing file error |
| `SakeShopMapperTests` | Unit | 6 | DTO → entity mapping, rating clamping, URL scheme validation (iOS 26 compat) |
| `SakeShopRepositoryTests` | Unit | 4 | Error remapping, mock data source call count |
| `FetchSakeShopsUseCaseTests` | Unit | 3 | Delegation, error propagation, call count |
| `SakeShopListViewModelTests` | Unit | 5 | ViewState transitions (idle/loading/success/empty/error) |
| `SakeShopDetailViewModelTests` | Unit | 5 | canOpenMaps, canOpenWebsite, rating exposure |
| `SakeShopSnapshotTests` (UITest) | UI | 6 | XCTAttachment screenshots (light/dark, portrait/landscape, back navigation); queries use `scrollViews`/`buttons` to match `ScrollView + LazyVStack` list layout |
| `DesignSystemSnapshotTests` (UITest) | UI | — | Design system token visual audit |
| `DSIcon/Color/Spacing/…Tests` | Unit | — | Token non-empty / value correctness |

All mocks live in dedicated files under `LocalSakeShopsTests/Mocks/` — none are defined inline in test files.

---

## AI Use

This project was developed using **Claude Code** (Anthropic) as the primary engineering assistant, following a **Spec-Driven Development** workflow powered by the [Spec Kit](https://github.com/speckit) toolchain.
The design system specification (`docs/DESIGN.md`) was generated using **Google Stitch**.

### Workflow

1. `/speckit-specify` — generated `spec.md` from a natural-language feature description
2. `/speckit-plan` — produced architecture plan, data model, API contracts, and quickstart guide
3. `/speckit-tasks` — broke the plan into 32 ordered, dependency-aware implementation tasks
4. `/speckit-analyze` — ran three static analysis passes over spec/plan/tasks to catch inconsistencies before any code was written (found and fixed 9 issues across two remediation rounds)
5. `/speckit-implement` — implemented all 32 tasks in dependency order, respecting TDD sequencing

### What AI generated

- All specification, planning, and task documents under `specs/`
- All Swift source files (domain entities, data layer, ViewModels, views, tests)
- The design system token suite (`DesignSystem/Tokens/`, `DesignSystem/Components/`)
- The `docs/DESIGN.md` Kura & Craft design system was already present in the repository; the AI read and applied it

### What AI did not do

- The repository and Xcode project skeleton were created manually
- `sake_shops.json` was provided as part of the challenge brief
- Final layout adjustments (AsyncImage in list rows, `MapCardView` integration, `@Observable` migration) were applied by a linter/post-processing step after the AI-generated implementation

### Post-implementation fixes

Several bugs surfaced after the initial implementation and were corrected in follow-up sessions:

- **iOS 26 URL parsing** (`SakeShopMapper`): Swift Foundation's `URL(string:)` changed in iOS 26 to accept relative-reference strings as valid URLs. `parseURL` was updated to require `url.scheme != nil`, and `SakeShopMapperTests` was updated with scheme-less test strings that expose the regression.
- **UI test element queries** (`SakeShopSnapshotTests`): The linter's `List → ScrollView + LazyVStack` change meant XCUITest's `collectionViews`/`cells` queries found nothing. Tests were restructured to call `launchApp()` per-test (setting `-UIUserInterfaceStyle` before launch), and element queries were updated to `scrollViews`/`buttons` to match the new layout.
- **UIKit removed** (`SakeShopDetailViewModel`): `UIApplication.shared.open(_:)` was replaced with a `urlToOpen: URL?` published property. `SakeShopDetailView` now consumes it via `@Environment(\.openURL)` and `.onChange(of:)`, eliminating the UIKit import entirely.
- **Design system snapshot test** (`DesignSystemSnapshotTests`): The dark-mode launch argument was malformed — `["-UIUserInterfaceStyle", "dark", "2"]` passed three elements where only two are valid. The spurious `"dark"` string caused the app to hang on launch and the screenshot call to time out. Fixed to `["-UIUserInterfaceStyle", "2"]`.

### Transparency note

All AI interactions are recorded in `.claude/` session files in the repository. The Spec Kit artifacts (`specs/002-shop-list-detail/`) provide a complete audit trail from requirement to implementation.
