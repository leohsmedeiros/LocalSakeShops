# Feature Specification: Sake Shop List & Detail

**Feature Branch**: `002-shop-list-detail`

**Created**: 2026-06-23

**Status**: Draft

**Input**: User description: "Create a screen with a list of local sake shops and a details screen for a specific sake shop. The data is going to be supplied in LocalSakeShops/sake_shops.json. The list page should contain items with sake shop names, address and star rating. Whenever a sake shop from the list is tapped, the user should be directed to the details page of that shop. The details page should contain details about the sake shops, including shop name, shop picture, a brief description, a rating in stars, address (clickable, should open address in a Maps app or browser), and a button or link to visit the shop's website in the default web browser or in a custom tab."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Browse Local Sake Shops (Priority: P1)

A sake enthusiast opens the app and immediately sees a scrollable list of local sake shops.
Each item shows enough information — name, address, and star rating — to identify and
compare shops at a glance without having to open each one.

**Why this priority**: The list is the entry point to all other content. Without it, no
other part of the feature delivers value. It is the minimum viable screen that unblocks
exploration.

**Independent Test**: Launch the app, verify the list screen appears with at least one shop
entry showing a name, an address, and a star rating. The screen delivers standalone value
as a directory of local shops.

**Acceptance Scenarios**:

1. **Given** the app has been launched, **When** the list screen appears, **Then** every
   shop entry shows the shop name, its address, and a star rating between 0 and 5.

2. **Given** the list is displayed, **When** the user scrolls down, **Then** all shops in
   the data source are shown with no entries missing.

3. **Given** the data source contains no shops, **When** the list screen appears, **Then**
   an empty state message is shown explaining there are no shops to display.

4. **Given** the data source cannot be read or is malformed, **When** the list screen
   appears, **Then** an error state is shown with a human-readable message — the app does
   not crash.

---

### User Story 2 - View Sake Shop Details (Priority: P2)

A user taps on a sake shop in the list and is taken to a details screen that provides the
full profile of that shop: a photo, a description, a star rating, a tappable address that
opens in a mapping application, and a link to the shop's website.

**Why this priority**: The list alone satisfies browsing; the detail screen satisfies
decision-making. A user who wants to visit a shop needs the address link and website —
these are the actions that convert browsing into a real-world visit.

**Independent Test**: Tap any shop in the list. Verify the detail screen shows all six
elements (name, image, description, rating, address link, website link). Tap the address —
confirm the device's default Maps app opens. Tap the website link — confirm a browser opens
with the correct URL.

**Acceptance Scenarios**:

1. **Given** the user taps a shop in the list, **When** the detail screen appears, **Then**
   the shop name, a photo, a brief description, and a star rating (0–5) are all visible.

2. **Given** the detail screen is open, **When** the user taps the address, **Then** the
   device's default Maps application (or a browser-based maps service) opens and shows
   directions to or a pin at that address.

3. **Given** the detail screen is open, **When** the user taps the website button or link,
   **Then** the shop's website opens in the device's default web browser.

4. **Given** the shop has no image available, **When** the detail screen appears, **Then**
   a placeholder image is shown instead — the layout does not break.

5. **Given** the user has navigated to the detail screen, **When** they tap the back
   control, **Then** they are returned to the list screen at the same scroll position.

---

### Edge Cases

- What if `sake_shops.json` is missing from the app bundle? → Show an error state on the
  list screen with a user-friendly message; do not crash.
- What if `sake_shops.json` contains malformed JSON? → Parse defensively; show an error
  state if the file cannot be decoded.
- What if a shop entry is missing a field (image, website, description)? → Each field MUST
  degrade gracefully: use a placeholder image, hide the website button if the URL is absent,
  show an empty description string.
- What if the address string cannot be geocoded by the Maps app? → The Maps app handles
  this; the app only needs to open the Maps app with the raw address string — no geocoding
  is performed in-app.
- What if the website URL is malformed? → The website button MUST be hidden or disabled
  for entries with an invalid or absent URL.
- What if a shop name or description is very long? → Text MUST truncate or wrap gracefully
  without breaking the layout or overflowing off-screen.
- What if the star rating in the data is outside the 0–5 range? → Clamp displayed rating
  to the 0–5 range; do not crash.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST load the list of sake shops from the bundled `sake_shops.json`
  file at app launch without any network request.

- **FR-002**: The list screen MUST display each shop with its name, address, and star
  rating (displayed as filled/empty star icons representing a 0–5 scale).

- **FR-003**: The list screen MUST show an empty state when the data source contains zero
  entries.

- **FR-004**: The list screen MUST show an error state when the data source cannot be
  loaded or parsed, with a human-readable message. The app MUST NOT crash.

- **FR-005**: Tapping a shop entry in the list MUST navigate the user to the detail screen
  for that specific shop.

- **FR-006**: The detail screen MUST display the shop name, a photo, a brief description,
  and the star rating.

- **FR-007**: The detail screen MUST display the shop's address as a tappable element that
  opens the address in the device's default Maps application (or a browser-based maps
  fallback).

- **FR-008**: The detail screen MUST display a button or link labelled to indicate visiting
  the shop's website, which opens the URL in the device's default web browser when tapped.

- **FR-009**: If a shop has no image, the detail screen MUST display a placeholder image
  so the layout remains intact.

- **FR-010**: If a shop has no website URL (or the URL is invalid), the website button
  MUST be hidden or visually disabled — it MUST NOT be tappable.

- **FR-011**: All visual elements on both screens MUST use the design system tokens defined
  in `docs/DESIGN.md` — no hardcoded colors, fonts, spacing, or corner radius values.

### Key Entities

- **SakeShop**: Represents one sake shop entry in the data source. Key attributes: unique
  identifier, name (string), address (string), rating (decimal 0–5), image reference
  (string — file name or URL), description (string), website URL (string, optional).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The shop list is fully visible and scrollable within 1 second of launching
  the app on a supported device.

- **SC-002**: Tapping a shop in the list navigates to its detail screen in under 500
  milliseconds, with all content visible without a secondary loading state.

- **SC-003**: Tapping the address on the detail screen opens the Maps app in under 1
  second with no intermediate loading indicator required from the app.

- **SC-004**: 100% of shops in the data source are represented in the list — no entries
  are silently dropped due to parsing issues for well-formed records.

- **SC-005**: The list and detail screens render without layout breakage across all
  supported device sizes (iPhone SE through iPhone Pro Max) in both portrait and landscape
  orientations.

- **SC-006**: The list screen displays a meaningful empty or error state for every failure
  mode — users are never presented with a blank screen.

## Assumptions

- The `sake_shops.json` file is bundled inside the app and does not require a network
  connection to load.
- Shop images are either bundled as local assets referenced by file name, or hosted at
  HTTP(S) URLs that the app loads asynchronously; the spec supports both but the initial
  implementation will use whichever the JSON file references.
- The app does not need to support adding, editing, or removing shops in this feature —
  the data is read-only.
- Dark mode support is required from launch; all design tokens resolve correctly in both
  light and dark appearance.
- The star rating is a decimal value (e.g., 4.5) displayed to one decimal place or as a
  filled/half-filled/empty star representation — the exact visual is a design decision
  for the plan phase.
- Navigation between list and detail uses the platform's standard back gesture and button;
  no custom navigation chrome is required.
- Accessibility (VoiceOver, Dynamic Type) is in scope at a baseline level — star ratings
  must have accessible labels, and all tappable elements must meet minimum touch target sizes.
