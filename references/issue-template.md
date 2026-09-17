# Reusable implementation issue template

Use the repository's tracker syntax, but preserve this information.

```markdown
## Goal

One concrete vertical slice.

## Scope

- Observable behavior to add or change.
- Boundaries and interfaces affected.

## Non-goals

- Explicitly deferred behavior.
- Related ideas that must not be implemented here.

## Acceptance criteria

- [ ] Observable product behavior.
- [ ] Error, empty, loading, or recovery behavior where applicable.
- [ ] Accessibility and keyboard behavior where applicable.
- [ ] Deterministic focused tests.
- [ ] Documentation updated when public behavior or architecture changes.

## Verification

Focused command:

```text
<focused verification command>
```

Full gate:

```text
<repository full verification command>
```

## Dependencies

Blocked by <tracker references>, or `None`.

## Impact review

- Data/migrations:
- Permissions/native capabilities:
- Dependencies:
- Privacy/network:
- Recovery/rollback:
```

Keep acceptance criteria testable. If a criterion requires a product decision,
move that decision into an ADR or split the ticket.
