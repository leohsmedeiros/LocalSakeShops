# Data Model: Sake Shop List & Detail

**Feature**: `specs/002-shop-list-detail`
**Date**: 2026-06-23

---

## Domain Entities

### SakeShop

The canonical domain entity used by ViewModels and Views. Uses Swift-idiomatic naming
and resolved types. No JSON concerns at this layer.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `UUID` | Generated at mapping time (JSON has no stable identifier) |
| `name` | `String` | Shop display name |
| `description` | `String` | Brief description (may be empty string) |
| `pictureURL` | `URL?` | Remote image URL; nil if JSON is null or unparseable |
| `rating` | `Double` | 0.0–5.0; clamped at mapper boundary |
| `address` | `String` | Full address string |
| `mapsURL` | `URL?` | Pre-built maps link; nil if absent/invalid |
| `websiteURL` | `URL?` | Shop website; nil if absent/invalid |

**Validation rules** (enforced in mapper):
- `rating` is clamped to `0.0...5.0`
- `pictureURL`, `mapsURL`, `websiteURL` are constructed via `URL(string:)` — nil on failure
- `name` and `address` trim leading/trailing whitespace
- `description` defaults to `""` if absent (not currently nullable in JSON, but defensive)

**Relationships**: None — `SakeShop` is a standalone value type (`struct`).

---

## Data Transfer Objects (DTOs)

### SakeShopDTO

Mirrors the JSON structure exactly. Lives in the Data layer only.

| JSON Key | Swift Property | Type | Notes |
|----------|---------------|------|-------|
| `name` | `name` | `String` | |
| `description` | `description` | `String` | |
| `picture` | `picture` | `String?` | Null in JSON for "Midori Nagano" |
| `rating` | `rating` | `Double` | |
| `address` | `address` | `String` | |
| `coordinates` | `coordinates` | `[Double]?` | [lat, lng]; not used in this feature |
| `google_maps_link` | `googleMapsLink` | `String?` | CodingKey maps `google_maps_link` → `googleMapsLink` |
| `website` | `website` | `String?` | |

---

## Mapper

### SakeShopMapper

Converts `SakeShopDTO` → `SakeShop`. Pure function; no side effects. Unit-testable.

```
SakeShopMapper.map(_ dto: SakeShopDTO) -> SakeShop
SakeShopMapper.map(_ dtos: [SakeShopDTO]) -> [SakeShop]
```

---

## State Model

### ViewState\<T\>

Shared across all feature ViewModels. Lives in `Shared/State/ViewState.swift`.

```
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case empty         // success but T is an empty collection
    case error(String) // user-facing message
}
```

---

## Protocol Interfaces

### SakeShopRepositoryProtocol (Domain layer)

```
protocol SakeShopRepositoryProtocol {
    func fetchShops() async throws -> [SakeShop]
}
```

### BundledJSONDataSourceProtocol (Data layer)

```
protocol BundledJSONDataSourceProtocol {
    func load<T: Decodable>(_ type: T.Type, from filename: String) async throws -> T
}
```

Both protocols enable test-time substitution via mock implementations without the
production code knowing the difference.

---

## Use Cases

### FetchSakeShopsUseCaseProtocol

```
protocol FetchSakeShopsUseCaseProtocol {
    func execute() async throws -> [SakeShop]
}
```

Single concrete implementation (`FetchSakeShopsUseCase`) that depends on
`SakeShopRepositoryProtocol`. At this feature's scale the use case is a thin
pass-through, but it is the correct layer boundary for future filtering, sorting,
or caching logic.

---

## JSON Source

File: `LocalSakeShops/sake_shops.json` (bundled in the app target)

Root structure: JSON array of shop objects.

Sample entry:
```json
{
  "name": "Endo Brewery",
  "description": "Historic brewery known for its Keiryu brand sake.",
  "picture": "https://www.keiryu.jp/img_201904/head_parts/shop_img.png",
  "rating": 4.5,
  "address": "〒382-0086 長野県須坂市大字須坂 29",
  "coordinates": [36.648273, 138.18724],
  "google_maps_link": "https://maps.app.goo.gl/f288RPXsgHRch3297",
  "website": "https://www.keiryu.jp/"
}
```

Edge cases observed in the actual file:
- `"Midori Nagano"` has `"picture": null` — mapper must handle null gracefully.
- All 10 entries have `google_maps_link` and `website` present as non-empty strings,
  but the mapper treats both as optional for defensive correctness.
