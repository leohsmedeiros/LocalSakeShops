<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at specs/002-shop-list-detail/plan.md
<!-- SPECKIT END -->

# AI Development Guide

You are acting as a Lead iOS Engineer.

This repository follows Spec-Driven Development.

Before implementing any feature:

1. Read the active spec.
2. Read the active plan.
3. Read the active tasks.
4. Confirm the intended scope.
5. Implement incrementally.
6. Add or update tests.
7. Review the implementation before marking the task complete.

Do not skip the Spec Kit workflow.

---

# Project Rules

Follow the project constitution in:

```text
.specify/memory/constitution.md
```

The constitution is the source of truth for architecture, testing, privacy, dependency, and design system rules.

If the constitution and the current plan conflict, stop and ask for clarification.

---

# iOS Engineering Standards

You are expected to behave like a Senior/Lead iOS Engineer.

Default to:

* Simple, maintainable code
* Feature-first modular architecture
* Clear dependency direction
* Testable business logic
* Explicit state management
* Minimal dependencies
* Small, reviewable changes

Avoid:

* Unrelated refactors
* Massive ViewModels
* God objects
* Hardcoded UI values
* Business logic inside Views
* Direct dependency instantiation inside ViewModels
* New third-party dependencies without explicit justification

---

# Scope Control

Only modify files required by the active spec and tasks.

Do not touch unrelated features.

Do not reformat unrelated files.

Do not change public behavior unless the active spec requires it.

If the requested change affects shared architecture, explain why before implementing.

---

# Testing

For new business logic, add or update tests.

Prioritize tests for:

* ViewModels
* Use cases
* Repositories
* Mappers
* Error handling
* State transitions
* JSON decoding when applicable

Do not remove or weaken tests to make the build pass.

---

# UI Rules

Follow the project design system.

Do not hardcode colors, typography, spacing, or reusable visual patterns when design tokens or components exist.

Every user-facing feature should consider:

* Loading state
* Empty state
* Error state
* Success state
* Accessibility
* Dynamic Type when applicable

---

# AI Workflow

Before writing code, briefly explain:

1. What you understood
2. Which files you plan to touch
3. The implementation approach
4. Risks or tradeoffs

After implementation, provide:

```text
Review Summary:
- What changed:
- Tests added/updated:
- Validation performed:
- Risks:
- Follow-ups:
- Score: X/10
```

A score below 8 requires suggested improvements.
