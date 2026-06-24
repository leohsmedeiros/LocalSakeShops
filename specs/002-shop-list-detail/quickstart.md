# Quickstart Validation Guide: Sake Shop List & Detail

**Feature**: `specs/002-shop-list-detail`
**Date**: 2026-06-23

---

## Prerequisites

- Xcode 15+ installed
- iOS 16+ Simulator available
- `sake_shops.json` present in `LocalSakeShops/sake_shops.json` and added to the
  `LocalSakeShops` target (already in place)
- Design System (feature 001) built — `DSColor`, `DSTypography`, etc. must compile

---

## 1. Build & Run

```
Product → Run (⌘R)
```

**Expected**: The app launches showing a `NavigationStack`-wrapped list screen titled
"Local Sake Shops" with 10 rows. Each row shows a shop name, a formatted address, and a
star rating display.

---

## 2. Validate List Screen

| Scenario | Action | Expected Result |
|----------|--------|----------------|
| All shops visible | Scroll from top to bottom | All 10 shops appear with name, address, stars |
| Star rating display | Inspect "Tamamura Honten" row | Shows 4.6 stars (filled + partial visual) |
| Null image (list) | Inspect "Midori Nagano" row | No crash; row layout intact |
| Empty state | (Covered by unit tests only — requires mock) | N/A in simulator |

---

## 3. Validate Navigation

| Scenario | Action | Expected Result |
|----------|--------|----------------|
| Tap to detail | Tap any row | Detail screen slides in with shop data |
| Back navigation | Swipe right or tap Back | Returns to list at same scroll position |
| Tap multiple shops | Tap three different shops in sequence | Each opens its correct detail screen |

---

## 4. Validate Detail Screen

| Scenario | Action | Expected Result |
|----------|--------|----------------|
| All fields | Tap "Endo Brewery" | Shows name, description, 4.5 stars, address, image |
| Remote image load | Tap any shop with a `picture` URL | AsyncImage loads; placeholder visible during load |
| Null picture | Tap "Midori Nagano" | Placeholder image shown; no crash |
| Address tap | Tap the address on any detail screen | Default Maps app (or browser) opens |
| Website button | Tap the website button | Default browser opens the correct URL |

---

## 5. Dark Mode

```
Simulator → Features → Toggle Appearance
```

**Expected**: Both list and detail screens use design system color tokens — all text,
backgrounds, and icons adapt correctly. No hardcoded colors remain visible.

---

## 6. Dynamic Type

```
Simulator → Settings → Accessibility → Display & Text Size → Larger Text → max size
```

**Expected**: Shop names and descriptions wrap or scale. No text is clipped or truncated
to invisible. Layout does not break.

---

## 7. Run Unit Tests

```
Product → Test (⌘U) → Select LocalSakeShopsTests target
```

**Expected results**:

| Test Suite | Expected |
|------------|----------|
| `SakeShopListViewModelTests` | All pass: loading, success, empty, error states |
| `SakeShopDetailViewModelTests` | All pass: canOpenMaps/Website logic, URL validity |
| `FetchSakeShopsUseCaseTests` | All pass: delegates to repository, propagates errors |
| `SakeShopMapperTests` | All pass: DTO → entity, null picture, rating clamp, URL parse |
| `BundledJSONDataSourceTests` | All pass: loads JSON, throws on missing file |

---

## 8. Run UI Snapshot Tests

```
Product → Test (⌘U) → Select LocalSakeShopsUITests target
```

**Expected**: `SakeShopSnapshotTests` captures `XCTAttachment` screenshots of:
- List screen (light mode)
- List screen (dark mode)
- Detail screen (light mode)
- Detail screen (dark mode)

All four tests pass (screenshot captures, not pixel-diff comparison).

---

## 9. Code Quality Check

```bash
# Verify no hardcoded color/font/spacing values in feature files
grep -rn "Color(" LocalSakeShops/Features/ | grep -v "DSColor"
grep -rn "\.font(" LocalSakeShops/Features/ | grep -v "DSTypography"
grep -rn "\.padding(" LocalSakeShops/Features/ | grep -v "DSSpacing"
```

**Expected**: Zero matches (all visual values route through design system tokens).

---

## Reference

- Data model: [`data-model.md`](data-model.md)
- API contracts: [`contracts/feature-api.md`](contracts/feature-api.md)
- Research decisions: [`research.md`](research.md)
