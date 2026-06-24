---
description: "Task list for Sake Shop List & Detail"
---

# Tasks: Sake Shop List & Detail

**Input**: Design documents from `specs/002-shop-list-detail/`

**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ ✅ | quickstart.md ✅

**Tests**: Included — constitution Principle VI mandates unit tests for all business logic
(ViewModels, use cases, repositories, mappers) and UI/snapshot tests for visual components.
Mock files must be in dedicated files (not inline). TDD order: write tests, confirm they
fail, then implement.

**Remediation applied** (2026-06-23 /speckit-analyze pass 1):
- C1: Added `MockBundledJSONDataSource` (T017) and `SakeShopRepositoryTests` (T020) — constitution Principle VI gap.
- C2: Added DSIcon star token extension (T009) and `StarRatingView` shared component (T010) — FR-011 / constitution Principle III gap.
- I1: T030 now specifies `#if DEBUG` explicitly.
- U1: T032 now includes manual performance check.
- U2: T031 now covers back-navigation scroll position.
- F1: T028 now names `DSIcon.shopPlaceholder` explicitly.
- B1: T031 now captures landscape orientation.

**Remediation applied** (2026-06-23 /speckit-analyze pass 2):
- F1: T011 `BundledJSONError` access modifier clarified — `internal` (Swift default), NOT `private`; prevents compile error in T013/T020.
- A1+I1: T010 misleading 44pt tap-target removed (stars are display-only); incorrect T002 dependency removed.
- A2: T027 force-unwraps replaced with `guard let` pattern in `openMaps()`/`openWebsite()`.
- A3: T018 annotated as integration test; bundle membership warning added.
- C1: T031 now runs on iPhone SE + iPhone 16 Pro Max to satisfy SC-005 device size range.
- C2: T032 added SC-003 manual check step (Maps open timing is OS-controlled).

**Organization**: Tasks are grouped by user story to enable independent implementation
and testing of each story.

## Format: `[ID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2)
- All file paths are relative to the repository root

---

## Phase 1: Setup

**Purpose**: Create the directory structure that all subsequent tasks populate.
`PBXFileSystemSynchronizedRootGroup` auto-includes files — no `.pbxproj` editing needed.

- [X] T001 Create all required directories: `LocalSakeShops/Features/SakeShopList/{Views,ViewModels}/`, `LocalSakeShops/Features/SakeShopDetail/{Views,ViewModels}/`, `LocalSakeShops/Domain/{Entities,Repositories,UseCases,Errors}/`, `LocalSakeShops/Data/{DataSources,Repositories,DTOs,Mappers}/`, `LocalSakeShops/Shared/{State,Views}/`, `LocalSakeShopsTests/Mocks/`, `LocalSakeShopsTests/Features/{SakeShopList,SakeShopDetail,Domain,Data}/`, `LocalSakeShopsUITests/Features/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared types, design system extensions, protocols, data layer, and mocks
that all user story phases depend on. US1 and US2 CANNOT begin until this phase is complete.

**⚠️ CRITICAL**: Phases 3 and 4 MUST NOT begin until this phase is complete.

### Shared Types & Design System Extensions (all parallelizable)

- [X] T002 [P] Implement `LocalSakeShops/Shared/State/ViewState.swift` — `enum ViewState<T> { case idle, loading, success(T), empty, error(String) }` with no imports beyond Foundation; include `///` doc comment on enum and each case
- [X] T003 [P] Implement `LocalSakeShops/Domain/Entities/SakeShop.swift` — `struct SakeShop: Identifiable, Equatable, Hashable` with fields: `id: UUID`, `name: String`, `description: String`, `pictureURL: URL?`, `rating: Double`, `address: String`, `mapsURL: URL?`, `websiteURL: URL?`; include `///` doc comments
- [X] T004 [P] Implement `LocalSakeShops/Domain/Errors/SakeShopError.swift` — `enum SakeShopError: Error, LocalizedError` with cases `dataNotFound` and `decodingFailed(Error)`, providing user-facing `errorDescription` strings; include `///` doc comments
- [X] T005 [P] Implement `LocalSakeShops/Domain/Repositories/SakeShopRepositoryProtocol.swift` — `protocol SakeShopRepositoryProtocol` with `func fetchShops() async throws -> [SakeShop]`; include `///` doc comment
- [X] T006 [P] Implement `LocalSakeShops/Domain/UseCases/FetchSakeShopsUseCaseProtocol.swift` — `protocol FetchSakeShopsUseCaseProtocol` with `func execute() async throws -> [SakeShop]`; include `///` doc comment
- [X] T007 [P] Implement `LocalSakeShops/Data/DataSources/BundledJSONDataSourceProtocol.swift` — `protocol BundledJSONDataSourceProtocol` with `func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T`; include `///` doc comment
- [X] T008 [P] Implement `LocalSakeShops/Data/DTOs/SakeShopDTO.swift` — `struct SakeShopDTO: Decodable` mirroring the JSON shape: `name: String`, `description: String`, `picture: String?`, `rating: Double`, `address: String`, `coordinates: [Double]?`, `googleMapsLink: String?`, `website: String?` with `CodingKeys` mapping `google_maps_link` → `googleMapsLink`; include `///` doc comments
- [X] T009 [P] Extend `LocalSakeShops/DesignSystem/Tokens/DSIcon.swift` — add four new `static let` tokens after the existing 15: `star = "star"`, `starFill = "star.fill"`, `starHalfFill = "star.leadinghalf.filled"`, `shopPlaceholder = "photo"`; add `///` doc comment on each; also add corresponding `@Test` cases to `LocalSakeShopsTests/DesignSystem/DSIconTests.swift` *(already applied to both files as part of /speckit-analyze remediation — verify by building)*
- [X] T010 [P] Implement `LocalSakeShops/Shared/Views/StarRatingView.swift` — `struct StarRatingView: View` accepting `rating: Double` and `maxStars: Int = 5`; renders filled/half/empty stars using `DSIcon.starFill`, `DSIcon.starHalfFill`, `DSIcon.star` via `Image(systemName:)`; star color uses `DSColor.secondary`; accessible label `"\(rating) out of \(maxStars) stars"`; stars are display-only (not interactive) — no tap-target padding needed (the containing `SakeShopRowView` row is already 72pt tall); include `///` doc comments and `#Preview`. Depends on T009. *(A1 + I1 remediation — removed misleading 44pt tap-target constraint; T002 dependency was incorrect)*

### Data Layer (sequential — each depends on protocols above)

- [X] T011 Implement `LocalSakeShops/Data/DataSources/BundledJSONDataSource.swift` — `final class BundledJSONDataSource: BundledJSONDataSourceProtocol`; reads any `Decodable` type from a `.json` file in the main bundle by filename (no extension); throws `BundledJSONError.fileNotFound` or `BundledJSONError.decodingFailed`; include `///` doc comments; define `enum BundledJSONError: Error` in the same file with **internal** (Swift default) access — NOT `private`, because `SakeShopRepository` (T013) and `SakeShopRepositoryTests` (T020) must pattern-match this type from different files; `private` would cause a compile error. Depends on T007. *(F1 remediation)*
- [X] T012 Implement `LocalSakeShops/Data/Mappers/SakeShopMapper.swift` — `enum SakeShopMapper` with `static func map(_ dto: SakeShopDTO) -> SakeShop` and `static func map(_ dtos: [SakeShopDTO]) -> [SakeShop]`; clamps rating to `0.0...5.0`; parses `picture`, `googleMapsLink`, `website` strings to `URL?`; generates a `UUID` for `id`; include `///` doc comments. Depends on T003, T008.
- [X] T013 Implement `LocalSakeShops/Data/Repositories/SakeShopRepository.swift` — `final class SakeShopRepository: SakeShopRepositoryProtocol`; `init(dataSource: BundledJSONDataSourceProtocol, filename: String = "sake_shops")`; calls `dataSource.load([SakeShopDTO].self, from: filename)` then maps via `SakeShopMapper`; maps `BundledJSONError.fileNotFound` → `SakeShopError.dataNotFound` and `BundledJSONError.decodingFailed` → `SakeShopError.decodingFailed`; include `///` doc comments. Depends on T005, T007, T011, T012.
- [X] T014 Implement `LocalSakeShops/Domain/UseCases/FetchSakeShopsUseCase.swift` — `final class FetchSakeShopsUseCase: FetchSakeShopsUseCaseProtocol`; `init(repository: SakeShopRepositoryProtocol)`; `execute()` delegates to `repository.fetchShops()`; include `///` doc comments. Depends on T005, T006.

### Test Infrastructure (parallelizable once their target types exist)

- [X] T015 [P] Implement `LocalSakeShopsTests/Mocks/MockSakeShopRepository.swift` — `final class MockSakeShopRepository: SakeShopRepositoryProtocol`; `var stubbedResult: Result<[SakeShop], Error> = .success([])`; `private(set) var fetchCallCount = 0`; thread-safe via `@MainActor`. Depends on T003, T005.
- [X] T016 [P] Implement `LocalSakeShopsTests/Mocks/MockFetchSakeShopsUseCase.swift` — `final class MockFetchSakeShopsUseCase: FetchSakeShopsUseCaseProtocol`; same stubbing pattern as `MockSakeShopRepository` with `executeCallCount`. Depends on T003, T006.
- [X] T017 [P] Implement `LocalSakeShopsTests/Mocks/MockBundledJSONDataSource.swift` — `final class MockBundledJSONDataSource: BundledJSONDataSourceProtocol`; `var stubbedResult: Result<Data, Error>`; `func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T` decodes the stubbed `Data` or throws the stubbed error; `private(set) var loadCallCount = 0`; `private(set) var lastFilename: String?`. Depends on T007. *(C1 remediation — needed by T020)*
- [X] T018 [P] Create `LocalSakeShopsTests/Features/Data/BundledJSONDataSourceTests.swift` — Swift Testing `@Suite`; test: (a) loads `sake_shops.json` from bundle producing 10 items of type `[SakeShopDTO]`, (b) throws when filename is nonexistent, (c) thrown error is `BundledJSONError.fileNotFound`. **Note**: this is an integration test (it loads the real bundle file) — verify that `sake_shops.json` is added to the `LocalSakeShopsTests` target membership in Xcode before running; without it, test (a) will fail with `fileNotFound` for the wrong reason. Depends on T011. *(A3 remediation)*
- [X] T019 [P] Create `LocalSakeShopsTests/Features/Data/SakeShopMapperTests.swift` — Swift Testing `@Suite`; test: (a) full DTO maps to entity with correct field values, (b) `null` picture maps to `nil` URL, (c) rating below 0 clamps to 0, (d) rating above 5 clamps to 5, (e) invalid URL string maps to `nil`, (f) batch mapping preserves order. Depends on T012.
- [X] T020 [P] Create `LocalSakeShopsTests/Features/Data/SakeShopRepositoryTests.swift` — Swift Testing `@Suite`; uses `MockBundledJSONDataSource`; test: (a) success path: stubbed valid `[SakeShopDTO]` JSON returns mapped `[SakeShop]`; (b) `BundledJSONError.fileNotFound` thrown by data source → repository throws `SakeShopError.dataNotFound`; (c) `BundledJSONError.decodingFailed` → repository throws `SakeShopError.decodingFailed`; (d) `loadCallCount == 1` after `fetchShops()`. Depends on T013, T017. *(C1 remediation)*
- [X] T021 Create `LocalSakeShopsTests/Features/Domain/FetchSakeShopsUseCaseTests.swift` — Swift Testing `@Suite`; uses `MockSakeShopRepository`; test: (a) delegates to repository and returns shops, (b) propagates repository errors unchanged, (c) `fetchCallCount == 1` per `execute()` call. Depends on T014, T015.

**Checkpoint**: All foundational types compile, all data layer tests pass. US1 and US2 can now proceed.

---

## Phase 3: User Story 1 — Browse Local Sake Shops (Priority: P1) 🎯 MVP

**Goal**: A scrollable list of all sake shops showing name, address, and star rating.
Handles loading, empty, and error states. Tapping a row navigates to the detail screen
(navigation link wired; detail content comes in US2).

**Independent Test**: Launch app, verify list shows 10 shops with name, address, and stars.
Confirm empty and error states render via `SakeShopListViewModelTests`.

### Tests for User Story 1

- [X] T022 [P] [US1] Create `LocalSakeShopsTests/Features/SakeShopList/SakeShopListViewModelTests.swift` — Swift Testing `@Suite`; uses `MockFetchSakeShopsUseCase`; test state transitions: (a) starts in `.idle`, (b) transitions to `.loading` then `.success([SakeShop])` when shops load, (c) transitions to `.empty` when result is empty array, (d) transitions to `.error(message)` on thrown error; confirm `executeCallCount == 1` after `loadShops()`. Depends on T016.

### Implementation for User Story 1

- [X] T023 [US1] Implement `LocalSakeShops/Features/SakeShopList/ViewModels/SakeShopListViewModel.swift` — `@MainActor final class SakeShopListViewModel: ObservableObject`; `@Published private(set) var state: ViewState<[SakeShop]> = .idle`; `init(fetchShops: FetchSakeShopsUseCaseProtocol)`; `func loadShops() async` sets `.loading`, then `.success`/`.empty`/`.error`; include `///` doc comments. Depends on T002, T003, T006.
- [X] T024 [P] [US1] Implement `LocalSakeShops/Features/SakeShopList/Views/SakeShopRowView.swift` — `struct SakeShopRowView: View`; displays `SakeShop.name` using `.dsTextStyle(.headlineSmall)`, `SakeShop.address` using `.dsTextStyle(.bodyMedium, color: DSColor.subdued)`, and `StarRatingView(rating: shop.rating)` for the star display; minimum row height 72pt; include `///` doc comments and `#Preview`. Depends on T003, T010. *(C2 remediation — uses StarRatingView, no raw SF Symbol strings)*
- [X] T025 [US1] Implement `LocalSakeShops/Features/SakeShopList/Views/SakeShopListView.swift` — `struct SakeShopListView: View`; wraps content in `NavigationStack`; uses `.task { await viewModel.loadShops() }` to trigger load; renders `ViewState` cases: `.loading` → `ProgressView`, `.success` → `List` of `NavigationLink(value: shop) { SakeShopRowView(shop: shop) }`, `.empty` → `ContentUnavailableView`-style empty state, `.error` → error message with `DSColor.error` text; includes `.navigationDestination(for: SakeShop.self)` pointing to a placeholder `Text("Detail coming soon")` (replaced in US2); all spacing, colors, and typography use DS tokens; include `///` doc comments and `#Preview`. Depends on T023, T024.

**Checkpoint**: App shows list, all state transitions work in tests. US1 is independently functional.

---

## Phase 4: User Story 2 — View Sake Shop Details (Priority: P2)

**Goal**: A full detail screen reachable by tapping any list row. Shows shop photo
(`AsyncImage`), name, description, star rating, tappable address (opens Maps), and a
website button (opens browser). Degrades gracefully for missing image or website.

**Independent Test**: Tap any shop in the list. Verify all six elements appear. Tap the
address — Maps opens. Tap the website button — browser opens. Tap "Midori Nagano" — no
crash, `DSIcon.shopPlaceholder` shown instead of image.

### Tests for User Story 2

- [X] T026 [P] [US2] Create `LocalSakeShopsTests/Features/SakeShopDetail/SakeShopDetailViewModelTests.swift` — Swift Testing `@Suite`; constructs `SakeShopDetailViewModel` with shop fixtures (valid URLs, nil URLs); test: (a) `canOpenMaps == true` when `mapsURL != nil`, (b) `canOpenMaps == false` when `mapsURL == nil`, (c) `canOpenWebsite == true` / `false` analogously, (d) `shop.rating` exposed correctly. Depends on T003.

### Implementation for User Story 2

- [X] T027 [US2] Implement `LocalSakeShops/Features/SakeShopDetail/ViewModels/SakeShopDetailViewModel.swift` — `@MainActor final class SakeShopDetailViewModel: ObservableObject`; `let shop: SakeShop`; computed `var canOpenMaps: Bool { shop.mapsURL != nil }` and `var canOpenWebsite: Bool { shop.websiteURL != nil }`; `func openMaps()` uses `guard let url = shop.mapsURL else { return }; UIApplication.shared.open(url)` — **no force-unwrap**; same pattern for `func openWebsite()` guarding on `shop.websiteURL`; include `///` doc comments. Depends on T003. *(A2 remediation — guard let replaces force-unwrap)*
- [X] T028 [US2] Implement `LocalSakeShops/Features/SakeShopDetail/Views/SakeShopDetailView.swift` — `struct SakeShopDetailView: View`; scrollable layout: (1) `AsyncImage(url: viewModel.shop.pictureURL)` with `.placeholder { Image(systemName: DSIcon.shopPlaceholder).font(.system(size: 60)).foregroundColor(DSColor.subdued) }` in a 200pt-tall frame *(F1 remediation — placeholder symbol named explicitly)*; (2) shop name `.dsTextStyle(.headlineMedium)`; (3) `StarRatingView(rating: viewModel.shop.rating)`; (4) description `.dsTextStyle(.bodyMedium)`; (5) `Button` for address, visible only when `viewModel.canOpenMaps`, calls `viewModel.openMaps()`, styled with `DSColor.secondary`; (6) `DSSecondaryButton` for website, visible only when `viewModel.canOpenWebsite`, calls `viewModel.openWebsite()`; all spacing/colors/typography via DS tokens; include `///` doc comments and `#Preview`. Depends on T010, T027. *(C2 remediation — uses StarRatingView and DSIcon.shopPlaceholder)*
- [X] T029 [US2] Update `LocalSakeShops/Features/SakeShopList/Views/SakeShopListView.swift` — replace the placeholder `.navigationDestination` body with `SakeShopDetailView(viewModel: SakeShopDetailViewModel(shop: shop))`; confirm navigation compiles and works end-to-end. Depends on T025, T028.

**Checkpoint**: Tapping any row opens the correct detail screen. All ViewModel tests pass. US2 is independently functional.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: App entry-point wiring, snapshot tests, and full quickstart validation.

- [X] T030 Update `LocalSakeShops/ContentView.swift` — replace root body with `SakeShopListView(viewModel: SakeShopListViewModel(fetchShops: FetchSakeShopsUseCase(repository: SakeShopRepository(dataSource: BundledJSONDataSource()))))`. Wrap `DesignSystemPreview()` in a `#if DEBUG` block accessible via a hidden debug gesture (e.g., long-press on a corner) or remove entirely — document the chosen approach in a code comment. *(I1 remediation — no vague "or remove if not needed")*
- [X] T031 [P] Create `LocalSakeShopsUITests/Features/SakeShopSnapshotTests.swift` — `XCTestCase` using `XCUIApplication`; capture `XCTAttachment` screenshots (`.keepAlways`): (a) list screen light mode portrait, (b) list screen dark mode portrait, (c) detail screen light mode portrait (tap first row), (d) detail screen dark mode portrait, (e) list screen light mode landscape (rotate simulator), (f) after tapping first row and pressing Back — capture list to confirm scroll position is preserved. Run screenshots (a)–(e) on **both iPhone SE (3rd gen) and iPhone 16 Pro Max** simulators to cover SC-005's full device size range. *(B1 + U2 + C1 remediation — landscape, back-navigation, multi-device)* Depends on T029, T030.
- [X] T032 Run full validation per `specs/002-shop-list-detail/quickstart.md` — (a) build: 0 errors 0 warnings; (b) all unit tests pass; (c) `grep -rn "Color(" LocalSakeShops/Features/` returns zero matches without `DSColor`; (d) Dynamic Type at max size renders without clipped text; (e) snapshot tests produce screenshots on both SE and Pro Max simulators; (f) **performance spot-check**: on iPhone SE simulator, cold-launch the app and verify the list is visible in under 1 second; tap a row and verify the detail screen appears in under 500ms; (g) **SC-003 manual check**: on any device or simulator, tap an address on the detail screen and confirm the Maps app (or browser-based maps) opens — timing is OS-controlled and not enforced by app code. *(U1 + C1 + C2 remediation)*

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately with T001
- **Foundational (Phase 2)**: Depends on T001 — BLOCKS US1 and US2
- **US1 (Phase 3)**: Depends on T002–T021 complete — can proceed after Phase 2
- **US2 (Phase 4)**: Depends on Phase 2 + T025 (navigation destination must exist in list view)
- **Polish (Phase N)**: Depends on T028 and T029 complete

### User Story Dependencies

- **US1 (P1)**: Requires foundational layer (T002–T021); T022 test before T023–T025
- **US2 (P2)**: Requires foundational layer + T025; T026 test before T027–T028; T029 wires detail into list

### Within Each Phase

- All [P] tasks within a phase can execute concurrently
- For TDD: write test → confirm failure → implement → confirm pass
- `StarRatingView` (T010) is introduced in Phase 2 and reused by T024 and T028 — no duplication

---

## Parallel Opportunities

### Phase 2 — shared types + DS extension (T002–T010) all parallel:
```
Task: "ViewState.swift" (T002)
Task: "SakeShop.swift" (T003)
Task: "SakeShopError.swift" (T004)
Task: "SakeShopRepositoryProtocol.swift" (T005)
Task: "FetchSakeShopsUseCaseProtocol.swift" (T006)
Task: "BundledJSONDataSourceProtocol.swift" (T007)
Task: "SakeShopDTO.swift" (T008)
Task: "Extend DSIcon.swift" (T009)
Task: "StarRatingView.swift" (T010) — depends on T009
```

Then sequential data layer (T011 → T012 → T013, T014 parallel after T011), then mocks + tests (T015–T021, many parallel).

### Phase 3 — after T023:
```
Task: "SakeShopListViewModelTests.swift" (T022) — before T023
Task: "SakeShopRowView.swift" (T024) — parallel with T023 progress
```

---

## Implementation Strategy

### MVP First (US1 — List screen only)

1. Complete Phase 1: directories (T001)
2. Complete Phase 2: foundational layer (T002–T021)
3. Complete Phase 3 US1: ViewModel test + list views (T022–T025)
4. **STOP and VALIDATE**: Launch app, see list of 10 shops, test loading/empty/error states
5. All unit tests pass for foundational + US1

### Incremental Delivery

1. Phase 1 + 2 → shared infrastructure compiles and tests pass
2. US1 (Phase 3) → working list screen, independently demoable
3. US2 (Phase 4) → full detail screen, end-to-end tap-through working
4. Polish (Phase N) → ContentView wired, 6 snapshot screenshots, performance spot-check

---

## Notes

- [P] tasks = different files, no shared state, can run concurrently
- `BundledJSONDataSource` is generic — the only abstraction with a justified re-usability rationale (from plan.md)
- `SakeShop` MUST conform to `Hashable` (required by `NavigationStack` typed destinations)
- `AsyncImage` handles its own loading/error/placeholder; no extra ViewModel state needed for images
- `StarRatingView` (T010) is the single source of truth for star rendering — used in list rows (T024) and detail view (T028); no duplication
- `DSIcon.shopPlaceholder = "photo"` and `DSIcon.star/starFill/starHalfFill` are already added to `DSIcon.swift` as part of /speckit-analyze remediation — T009 task should verify they compile
- UI snapshot tests (T031) are `XCTAttachment` screenshot captures, not pixel-diff comparison tests
- Commit after each phase checkpoint or logical group
