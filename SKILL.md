---
name: project-planning
description: Create and maintain an evidence-based project plan with scoped implementation tickets, explicit dependencies, acceptance criteria, and verification gates. Use when a repository has unclear scope, duplicate systems, stale roadmap items, or multi-agent implementation work.
---

# Project planning

Use this skill to turn an ambiguous product or engineering effort into a
maintainable implementation plan. The skill is project-agnostic: adapt to the
repository's conventions, tracker, branch model, and queue rather than
assuming GitHub, Tugboat, a particular language, or a particular product
shape.

## Operating boundary

Planning is not authorization to create remote issues, change milestones,
commit code, or start unattended work. Prepare those changes and ask for
direction when the user has not explicitly authorized the relevant mutation.
Preserve existing user work and distinguish verified facts from proposals.

Do not turn every idea into a ticket. Active tickets should describe approved,
bounded work. Keep speculative or post-MVP ideas in the roadmap until the
current phase is complete and the user promotes them.

## Workflow

### 1. Establish the baseline

Read the repository's agent instructions, README, design/product contract,
roadmap, architecture decisions, package scripts, and applicable nested
instructions. Inspect:

- working-tree status and recent relevant history;
- the current source tree and tests;
- the lockfile and verification scripts;
- the configured issue tracker and local task queue, if present;
- active issues and their labels/statuses, if external access is authorized.

Report the current baseline before proposing changes. Do not treat stale plans,
closed issues, generated files, or historical ADRs as active requirements.

### 2. Map the product and contradictions

Inventory current user-facing capabilities and the implementation paths behind
them. Look specifically for:

- duplicate concepts with different names or syntax;
- competing UI or state models for the same workflow;
- code that exists but is not wired into production;
- roadmap items that are already implemented or obsolete;
- documentation that conflicts with current behavior;
- security, persistence, migration, or permission consequences.

Separate four outcomes:

- keep: coherent and in scope;
- merge: overlapping systems that need one owner/model;
- decline: intentionally removed or rejected;
- defer: useful but outside the active phase.

### 3. Record decisions

Use an ADR for an architectural or product decision that is expensive to
reverse. An ADR should include context, decision, alternatives considered,
consequences, status, and supersession links where applicable.

Keep the active ADR set small. Superseded ADRs remain as history, but the
current source of truth must be unambiguous.

### 4. Build the phase chain

Organize approved work as a dependency graph, then serialize shared boundaries
such as parsers, editors, schemas, migrations, capabilities, or generated
artifacts. Prefer a short chain of vertical slices over large phase-wide
batches.

Every active ticket must contain:

- one concrete goal;
- explicit non-goals;
- observable acceptance criteria;
- focused verification and the repository's full verification gate;
- dependencies written in tracker-native form;
- migration, permission, dependency, privacy, and documentation impact;
- a clear completion condition.

An issue is not ready when it says only “finish,” “clean up,” or “refactor.”
Split it until an agent can implement and verify it without deciding unrelated
product policy.

The normal chain is:

```text
decision/contract → core boundary → feature behavior → integration → cleanup →
workflow/accessibility → full verification → next phase
```

Parallel work is appropriate only when the branches do not share files,
contracts, migrations, capabilities, or unresolved product decisions.

### 5. Synchronize planning surfaces

Keep each layer purposeful:

```text
product roadmap       → what is in or out
ADR                    → why a costly decision was made
implementation plan   → phase order and gates
tracker issues         → approved executable slices
local task queue       → agent-specific execution details
```

Do not duplicate full issue bodies in every document. Link from the roadmap and
implementation plan to tracker issues, and mirror only the local fields needed
by the execution queue.

### 6. Gate execution

Before starting a ticket, verify:

- all blockers are merged and verified;
- the working tree and branch assumptions are understood;
- the ticket scope matches the current ADRs and roadmap;
- the required test command exists;
- no destructive migration, permission expansion, external write, or new
  dependency is being smuggled in as an implementation detail.

After completion, run the focused checks, then the broader required suite when
the phase gate calls for it. Update the tracker and roadmap only from verified
results. Never claim a phase is complete while a required gate is pending.

## Handoff format

End a planning or implementation handoff with:

1. current product/engineering state;
2. decisions made and their source documents;
3. the next unblocked ticket and its blockers;
4. files or tracker records changed;
5. verification commands and actual results;
6. migrations, permissions, dependencies, and privacy effects;
7. unresolved risks and the next phase boundary.

For tracker-specific schemas and a reusable issue template, read
[references/issue-template.md](references/issue-template.md).
