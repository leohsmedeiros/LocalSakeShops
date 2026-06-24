<!--
Sync Impact Report
==================
Version change: [TEMPLATE] → 1.0.0
Status: Initial ratification — all placeholder tokens replaced.

Modified principles: N/A (first fill from template)
Added sections:
  - Core Principles (7 principles covering all 22 user-supplied rules)
  - Architecture Constraints
  - Development Workflow
  - Governance

Removed sections: N/A

Templates requiring updates:
  ✅ .specify/memory/constitution.md — updated (this file)
  ⚠ .specify/templates/plan-template.md — Constitution Check section uses generic gates;
    iOS-specific gates (layer separation, design system check, testing mandate) should be
    reflected when /speckit-plan fills the section per feature. No structural update needed.
  ⚠ .specify/templates/spec-template.md — Generic template is compatible; no iOS-specific
    mandatory sections required at template level.
  ⚠ .specify/templates/tasks-template.md — Path conventions list `ios/src/` as a mobile
    option, which is compatible. Feature-first structure (Features/<Name>/{Views,ViewModels,
    Domain,Data}/) should be documented per plan.md. No structural update needed.

Deferred TODOs: None — ratification date set to today (2026-06-23) as initial adoption.
-->

# LocalSakeShops Constitution

## Core Principles

### I. Swift & SwiftUI Platform (NON-NEGOTIABLE)

All production code MUST be written in Swift. SwiftUI MUST be used as the UI framework for
all new views and screens. UIKit is not permitted unless bridging to a third-party library
with no SwiftUI equivalent; any such exception MUST be explicitly approved and documented.

**Rationale**: Ensures a unified, modern, declarative UI codebase with full Apple ecosystem
support and long-term maintainability.

### II. Clean MVVM Modular Architecture (NON-NEGOTIABLE)

- The project MUST follow Clean Architecture with strict layer separation:
  `Views → ViewModel → Domain (Use Cases, Entities) → Data (Repositories, Network,
  Persistence)`.
- MVVM is the mandatory UI pattern: Views MUST NOT contain business logic.
- Architecture MUST be feature-first and modular: each feature lives in its own
  folder (`Features/<FeatureName>/{Views,ViewModels,Domain,Data}/`) and MUST be
  independently buildable, testable, and reviewable.
- SOLID principles MUST be applied at all layers.
- Dependency Injection MUST be used: ViewModels and Domain layer classes MUST receive
  their dependencies via constructor or property injection. Singleton access inside
  these layers is forbidden unless explicitly approved.
- Features MUST NOT import each other's internal types. Cross-feature communication
  MUST go through shared Domain entities or a Coordinator/Router layer.

**Rationale**: Prevents tightly coupled code, enables parallel feature development,
and makes each feature independently testable and demonstrable.

### III. Design System Adherence (NON-NEGOTIABLE)

- `docs/DESIGN.md` is the sole source of truth for the design system when it exists.
- All colors, typography, spacing, and UI components MUST be sourced from the design
  system defined in `docs/DESIGN.md`.
- Custom colors, typography, spacing values, or UI components outside `docs/DESIGN.md`
  are forbidden unless explicitly approved and documented with rationale.
- If `docs/DESIGN.md` does not yet exist, only system-provided SwiftUI styles (e.g.,
  `.primary`, `.title`, standard padding values) MUST be used until the design system
  is established.
- Custom views defined in the project MUST be reused across features; duplicating
  visual components is not permitted.

**Rationale**: Maintains visual consistency and prevents design drift as the project
grows across multiple features.

### IV. Code Quality & Standards

- No code duplication: shared logic MUST be extracted into reusable components,
  extensions, utilities, or services.
- Naming MUST be clear and idiomatic Swift (camelCase for properties/methods,
  PascalCase for types). Each class, struct, enum, or protocol MUST reside in its
  own dedicated file named after the type.
- Hardcoded values (magic strings, numbers, URLs, color literals, etc.) are forbidden;
  use constants, enums, or configuration files.
- Code MUST include inline documentation (`///` doc comments) for all public and
  internal APIs, ViewModels, Use Cases, and any non-trivial methods.
- The folder structure MUST be well-organized and feature-first. Shared utilities,
  extensions, and components live in a `Shared/` or `Core/` module.

**Rationale**: Readable, predictable code with consistent structure reduces onboarding
time, prevents regressions, and makes code reviews faster.

### V. Networking & Error Handling (NON-NEGOTIABLE)

- The project MUST have a dedicated networking layer (e.g., `NetworkService` /
  `APIClient`) with clear request/response abstractions behind a protocol interface.
  Direct URLSession calls from ViewModels or Views are forbidden.
- All network errors and domain errors MUST be propagated to the UI layer and presented
  as user-facing feedback (alerts, inline error states, or empty states). Silent
  failures are not permitted.

**Rationale**: A centralized network layer enables consistent error handling,
testability via mocking, and future transport-layer changes with minimal blast radius.

### VI. Testing Discipline (NON-NEGOTIABLE)

- All new features MUST include:
  - **Unit tests** for all business logic (Use Cases, ViewModels, Repositories).
  - **UI / Snapshot tests** for Views and visual components.
- Test mocks MUST live in dedicated mock files (e.g., `MockNetworkService.swift`,
  `MockSakeRepository.swift`), not inline inside test files.
- Each feature MUST be independently testable without requiring other features to be
  complete or running.

**Rationale**: Prevents regressions, ensures each feature can be validated in isolation,
and keeps the test suite maintainable as the project scales.

### VII. Simplicity Over Abstraction

- Prefer simple, direct implementations. An abstraction (protocol, base class, generic
  wrapper, design pattern) MUST have at least two concrete use cases or a documented
  future requirement before being introduced.
- YAGNI: do not build for hypothetical future requirements not present in the current
  spec.

**Rationale**: Premature abstractions add complexity and maintenance burden without
delivering immediate value. Simpler code is easier to test, review, and change.

## Architecture Constraints

- **Strict layer boundaries**: Views MUST NOT import Data layer types directly.
  ViewModels MUST NOT import persistence frameworks (CoreData, SwiftData) directly —
  only through Repository protocol abstractions.
- **Third-party dependencies**: Any new external dependency requires explicit approval.
  Prefer Apple-native solutions (Combine, Swift Concurrency, SwiftData, MapKit, etc.)
  over third-party equivalents when functionally adequate.
- **Design system gate**: Before implementing any new UI, verify whether `docs/DESIGN.md`
  exists. If it does, all design decisions MUST reference it. If it does not, document
  this gap in the feature spec and use only system SwiftUI styles.
- **One file per type**: No type definitions in files that also define other types,
  except for closely coupled private nested types.

## Development Workflow

- Every new feature MUST have a spec (`spec.md`) and implementation plan (`plan.md`)
  before coding begins.
- Pull requests MUST be scoped to a single feature or concern.
- Code review MUST verify:
  1. Constitution compliance (architecture layers, testing mandate, naming, design system).
  2. No hardcoded values or magic numbers.
  3. All error paths have user-facing feedback.
  4. Mock files are in dedicated files, not inside test files.
  5. Inline documentation present on all public/internal APIs.
- CI MUST run unit tests and snapshot tests on every PR. PRs with failing tests MUST NOT
  be merged.

## Governance

This constitution supersedes all other coding guidelines and prior conventions for the
LocalSakeShops project. Any amendment requires:

1. A written proposal describing the change and its rationale.
2. Review and explicit approval before the amendment takes effect.
3. A version bump following semantic versioning:
   - **MAJOR**: Backward-incompatible removal or redefinition of a principle.
   - **MINOR**: New principle or materially expanded guidance added.
   - **PATCH**: Clarification, wording fix, or non-semantic refinement.
4. All affected templates and guidance docs updated in the same change.

All code contributions MUST be reviewed against this constitution. Violations MUST be
resolved before merging; exceptions require explicit approval and inline documentation
of the rationale in the code.

**Version**: 1.0.0 | **Ratified**: 2026-06-23 | **Last Amended**: 2026-06-23
