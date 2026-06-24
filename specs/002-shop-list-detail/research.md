# Research: Sake Shop List & Detail

**Feature**: `specs/002-shop-list-detail`
**Date**: 2026-06-23

---

## Decision 1: Remote Image Loading Strategy

**Decision**: Use SwiftUI's built-in `AsyncImage` with a placeholder.

**Rationale**: The JSON's `picture` field contains HTTP(S) URLs (including one `null`).
`AsyncImage` (iOS 15+) handles async URL loading, error states, and placeholder rendering
natively with zero third-party dependencies, fully satisfying Constitution Principle VII
(simplicity) and the architecture constraint against unapproved external libraries.

**Alternatives considered**:
- **Kingfisher / SDWebImageSwiftUI**: Excellent caching but adds a third-party dependency
  without explicit approval. Rejected per constitution.
- **URLSession + custom image cache**: More control but significantly more code for minimal
  gain at this feature's scale. Rejected per Principle VII.

---

## Decision 2: JSON Data Source Architecture (Re-usability)

**Decision**: Implement a generic `BundledJSONDataSource<T: Decodable>` that reads any
`Decodable` type from any bundled filename. The `SakeShopRepository` depends on this
via a `BundledJSONDataSourceProtocol` interface.

**Rationale**: The acceptance criteria explicitly requires re-usability: "could someone
re-implement this solution easily for a different type of data/different API?" A generic
data source parameterised on `T: Decodable` means switching from `sake_shops.json` to
any other bundled JSON file requires only a new DTO and a new Repository implementation
— no data source changes. The protocol interface means a remote `APIDataSource<T>`
can be dropped in as a replacement with zero changes to the use case or ViewModel layers.

**Alternatives considered**:
- **Hardcoded `SakeShopJSONLoader`**: Simple but not re-usable. Rejected.
- **SPM package for the generic layer**: Over-engineering for a single target. Rejected
  per Principle VII.

---

## Decision 3: Maps Integration

**Decision**: Use the `google_maps_link` field (a pre-built `maps.app.goo.gl` URL) and
open it via `UIApplication.shared.open(_:)`. No in-app geocoding or MapKit rendering.

**Rationale**: The JSON already provides `google_maps_link` (e.g.,
`https://maps.app.goo.gl/4fYMDSfNd6ocsDwt6`) which universal-links to the Google Maps
app or falls back to a browser — exactly the spec requirement. This avoids MapKit
complexity and location permissions. The `coordinates` field is present but not needed
for this feature scope.

**Alternatives considered**:
- **MapKit + CLLocationCoordinate2D**: Opens Apple Maps at the exact coordinate. Would
  require dropping the `google_maps_link` and constructing an Apple Maps URL from
  coordinates. Adds complexity and ignores the provided field. Rejected.
- **Apple Maps URL from address string**: `https://maps.apple.com/?q=<encoded address>`.
  Simpler than MapKit but loses the curated Maps link. Could be a fallback if
  `google_maps_link` is absent. Noted as an edge case handler.

---

## Decision 4: Navigation Pattern

**Decision**: `NavigationStack` + `.navigationDestination(for: SakeShop.self)` (iOS 16+
navigation path style).

**Rationale**: The project targets iOS 16+ (established in the design system plan).
`NavigationStack` with typed destinations is the modern SwiftUI navigation primitive —
it supports deep linking, state restoration, and programmatic navigation cleanly.
`NavigationLink` with a destination closure (the iOS 15 style) is deprecated for new
code in iOS 16+.

**Alternatives considered**:
- **Coordinator pattern (UINavigationController wrapper)**: More testable programmatic
  navigation but significantly more code. Justified only when features need to route
  across each other. Rejected per Principle VII for this single-flow feature.
- **`NavigationLink` with destination closure**: Deprecated in iOS 16. Rejected.

---

## Decision 5: ViewModel State Management

**Decision**: A `ViewState<T>` enum (`idle | loading | success(T) | empty | error(String)`)
published as a single `@Published var state` on each ViewModel. Async loading via
`async/await` with `Task { await vm.load() }` from `.task {}` view modifier.

**Rationale**: A single state enum eliminates impossible UI states (e.g.,
`isLoading = true` + `items.count > 0`). `async/await` is the modern Swift concurrency
primitive — no Combine needed, satisfying Principle VII. `@MainActor` on ViewModels
ensures UI updates happen on the main thread without explicit `DispatchQueue.main` calls.

**Alternatives considered**:
- **Separate `@Published var isLoading`, `@Published var items`, `@Published var error`**:
  Three independent properties can produce inconsistent states. Rejected.
- **Combine `PassthroughSubject` chains**: More reactive but higher complexity for
  straightforward load-once use cases. Rejected per Principle VII.

---

## Decision 6: Unit Testing Framework

**Decision**: Swift Testing (`import Testing`, `@Test`, `#expect`) for all unit tests;
`XCTest` / `XCUITest` for UI/snapshot tests (consistent with the existing test suite).

**Rationale**: The existing `LocalSakeShopsTests.swift` already uses Swift Testing.
Consistency requires new unit tests to match. UI tests remain `XCTestCase` as
`XCUITest` does not yet have a Swift Testing equivalent.

---

## Decision 7: DTO ↔ Domain Mapping

**Decision**: A dedicated `SakeShopMapper` (static method or enum) that converts
`SakeShopDTO` → `SakeShop`. The DTO mirrors JSON keys exactly; the domain entity
uses Swift-idiomatic naming and proper types (e.g., `URL?` instead of `String?`).

**Rationale**: Separating DTO and domain entity means JSON shape changes are isolated
to the DTO and mapper — no impact on ViewModels, Views, or Use Cases. The mapper is
independently unit-testable. This is a Clean Architecture data-layer concern.

**Alternatives considered**:
- **Make `SakeShop` directly `Decodable`**: Simpler but couples the domain entity to the
  JSON schema. Rejected: violates Clean Architecture layer separation.

---

## Decision 8: Website URL Handling

**Decision**: Parse `website` strings to `URL` at mapping time. If `URL(string:)` returns
nil, store `nil` in the domain entity. The detail ViewModel exposes `var canOpenWebsite: Bool`
derived from whether the URL is non-nil, which drives the website button's enabled state.

**Rationale**: Validation at the data layer boundary keeps ViewModels free of string
manipulation. Consistent with FR-010 (invalid/absent URLs must disable the button).
