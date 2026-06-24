# LocalSakeShops

A native iOS app for discovering local sake shops in Nagano, Japan. Browse a curated list of breweries and specialty shops, view shop details, open addresses in Maps, and visit shop websites — all from a clean, design-system-driven interface.

---

## Features

- **Shop list** — scrollable list of 10 local sake shops with name, address, and star rating
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
| SwiftUI | All views and navigation |
| Foundation | Data models, URL handling, JSON decoding |
| UIKit | `UIApplication.shared.open(_:)` for Maps and browser URLs |
| XCTest / Swift Testing | Unit and UI tests |

There are no third-party libraries, SPM packages, or CocoaPods.

---

## Architecture

The project follows **Clean Architecture** with a **feature-first modular layout** inside a single Xcode target.

```
Views → ViewModels → Domain (Use Cases, Entities) → Data (Repositories, DTOs, Mappers)
```

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
│   ├── DataSources/        # BundledJSONDataSource (generic, reusable)
│   ├── Repositories/       # SakeShopRepository
│   ├── DTOs/               # SakeShopDTO (Decodable)
│   └── Mappers/            # SakeShopMapper (DTO → Entity)
├── Shared/
│   ├── State/              # ViewState<T> enum
│   └── Views/              # StarRatingView
├── DesignSystem/
│   ├── Tokens/             # DSColor, DSTypography, DSSpacing, DSIcon, …
│   └── Components/         # DSPrimaryButton, DSSecondaryButton, DSCard, DSTextStyle
└── sake_shops.json         # Bundled data source

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
| `SakeShopMapperTests` | Unit | 6 | DTO → entity mapping, rating clamping, URL parsing |
| `SakeShopRepositoryTests` | Unit | 4 | Error remapping, mock data source call count |
| `FetchSakeShopsUseCaseTests` | Unit | 3 | Delegation, error propagation, call count |
| `SakeShopListViewModelTests` | Unit | 5 | ViewState transitions (idle/loading/success/empty/error) |
| `SakeShopDetailViewModelTests` | Unit | 5 | canOpenMaps, canOpenWebsite, rating exposure |
| `SakeShopSnapshotTests` (UITest) | UI | 6 | XCTAttachment screenshots (light/dark, portrait/landscape, back navigation) |
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

### Transparency note

All AI interactions are recorded in `.claude/` session files in the repository. The Spec Kit artifacts (`specs/002-shop-list-detail/`) provide a complete audit trail from requirement to implementation.
