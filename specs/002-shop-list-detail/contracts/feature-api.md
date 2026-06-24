# Feature API Contract: Sake Shop List & Detail

**Feature**: `specs/002-shop-list-detail`
**Date**: 2026-06-23

This document defines the public Swift API surface for the Sake Shop List & Detail feature.
All contracts here are the source of truth for what the feature exports to the rest of the
app and what the test layer must verify.

---

## Domain Layer Contracts

### SakeShop (entity)

```swift
struct SakeShop: Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let pictureURL: URL?
    let rating: Double          // 0.0...5.0 (clamped)
    let address: String
    let mapsURL: URL?
    let websiteURL: URL?
}
```

### FetchSakeShopsUseCaseProtocol

```swift
protocol FetchSakeShopsUseCaseProtocol {
    func execute() async throws -> [SakeShop]
}
```

**Behavior**:
- Returns shops in the order they appear in the data source.
- Throws `SakeShopError.dataNotFound` if the source file is missing.
- Throws `SakeShopError.decodingFailed(Error)` if parsing fails.
- Never returns a partially-decoded list — success or throw, no silent drops.

### SakeShopRepositoryProtocol

```swift
protocol SakeShopRepositoryProtocol {
    func fetchShops() async throws -> [SakeShop]
}
```

**Behavior**: Same error contract as `FetchSakeShopsUseCaseProtocol`.

---

## Data Layer Contracts

### BundledJSONDataSourceProtocol

```swift
protocol BundledJSONDataSourceProtocol {
    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T
}
```

**Behavior**:
- `filename` is a bare name without extension (e.g., `"sake_shops"`).
- Searches the main bundle for a `.json` file with that name.
- Throws `BundledJSONError.fileNotFound(String)` if file is absent.
- Throws `BundledJSONError.decodingFailed(Error)` on malformed JSON.

---

## ViewModel Contracts

### SakeShopListViewModel

```swift
@MainActor
final class SakeShopListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[SakeShop]>

    init(fetchShops: FetchSakeShopsUseCaseProtocol)
    func loadShops() async
}
```

**State transitions**:
```
idle → loading → success([SakeShop])   (≥1 shop)
idle → loading → empty                 (0 shops)
idle → loading → error(message)        (load/decode failure)
```

### SakeShopDetailViewModel

```swift
@MainActor
final class SakeShopDetailViewModel: ObservableObject {
    let shop: SakeShop
    var canOpenMaps: Bool     { shop.mapsURL != nil }
    var canOpenWebsite: Bool  { shop.websiteURL != nil }

    init(shop: SakeShop)
    func openMaps()
    func openWebsite()
}
```

**Behavior**:
- `openMaps()` calls `UIApplication.shared.open(shop.mapsURL!)` — only callable when
  `canOpenMaps == true`.
- `openWebsite()` calls `UIApplication.shared.open(shop.websiteURL!)` — only callable
  when `canOpenWebsite == true`.

---

## Error Types

```swift
enum SakeShopError: Error, LocalizedError {
    case dataNotFound
    case decodingFailed(Error)

    var errorDescription: String? { ... }  // user-facing messages
}

enum BundledJSONError: Error {
    case fileNotFound(String)
    case decodingFailed(Error)
}
```

---

## Test Mock Contracts

Both mocks MUST live in dedicated files (constitution Principle VI):

### MockSakeShopRepository

File: `LocalSakeShopsTests/Mocks/MockSakeShopRepository.swift`

```swift
final class MockSakeShopRepository: SakeShopRepositoryProtocol {
    var stubbedResult: Result<[SakeShop], Error> = .success([])
    private(set) var fetchCallCount = 0

    func fetchShops() async throws -> [SakeShop] {
        fetchCallCount += 1
        return try stubbedResult.get()
    }
}
```

### MockFetchSakeShopsUseCase

File: `LocalSakeShopsTests/Mocks/MockFetchSakeShopsUseCase.swift`

```swift
final class MockFetchSakeShopsUseCase: FetchSakeShopsUseCaseProtocol {
    var stubbedResult: Result<[SakeShop], Error> = .success([])
    private(set) var executeCallCount = 0

    func execute() async throws -> [SakeShop] {
        executeCallCount += 1
        return try stubbedResult.get()
    }
}
```

---

## Navigation Contract

The root entry point is `SakeShopListView` presented inside a `NavigationStack`.
Navigation to the detail screen uses `.navigationDestination(for: SakeShop.self)`.

```swift
// In SakeShopListView
NavigationLink(value: shop) { SakeShopRowView(shop: shop) }

// Parent (or the view itself)
.navigationDestination(for: SakeShop.self) { shop in
    SakeShopDetailView(viewModel: SakeShopDetailViewModel(shop: shop))
}
```

`SakeShop` MUST conform to `Hashable` for `NavigationStack` typed destinations.
