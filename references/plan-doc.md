# Plan doc

The single source of truth for **what is in, what is out, and what order it happens
in.** Keep it short enough to reread in one sitting. A plan nobody rereads stops
being true without anyone noticing.

It links to tickets and ADRs; it never repeats their bodies. If the repo already
keeps part of this elsewhere (a declines list in the agent instructions, a decision
log), link that file instead of copying it.

````markdown
# Plan: <project>

Source of truth for scope and order. Tickets hold the detail.
Last reconciled: <YYYY-MM-DD> at `<short sha>` on `<base branch>`.
Verify: `<the repo's verify command>`

## Now

Active phase: **<n> — <outcome>**
Next unblocked: <ticket ref> — <title>

## Phases

### 1 — <outcome, one sentence> · complete <YYYY-MM-DD> at `<sha>`

<ticket ref>, <ticket ref>, <ticket ref>

### 2 — <outcome, one sentence> · active

Exit when:
- every ticket below is closed and its change is on `<base branch>`;
- `<verify command>` passes on `<base branch>`;
- <this phase's own outcome check: a named test, command or manual step>.

1. <ticket ref> — <title>
2. [<feature>](docs/features/<slug>/intent.md): <ticket ref>, <ticket ref> · after 1
3. <ticket ref> — <title> · after 1 · can run alongside 2

### 3 — <outcome, one sentence>

Work: [<feature>](docs/features/<slug>/intent.md), <one-line item>
Open decisions:
- <decision that must be settled before this phase gets tickets>

## In scope

- <capability> — <shipped | active | planned> — <evidence or ticket ref>

## Out

- <thing> — declined <YYYY-MM-DD>: <reason>. Bringing it back needs a new decision.

## Later

- <thing> — deferred <YYYY-MM-DD>: <reason>. Comes back when <condition>.

## Decisions

- [ADR-<nnnn>](<path>) — <decision as a sentence>

Superseded ADRs are not listed here; they link forward to what replaced them.

## Rework

- <YYYY-MM-DD> <ticket ref> → <follow-up ref>: <cause> <→ where the lesson went, once it has gone somewhere>
````

## Rules for keeping it

- **Items come before tickets.** When a phase is first written, its items are
  listed by name. Ticket references are added once the tickets are filed.
- **Only the active phase lists tickets.** Future phases carry an outcome and their
  open decisions. Complete phases shrink to a line of ticket refs.
- **Order lines say "after", not "blocked by".** A line starting "blocked by" can
  be read as a real blocker by tools that parse text. The tracker holds the real
  blockers.
- **Out and Later are not the same.** Out records a *no* so it does not quietly
  return. Later records a *not yet* and what would change that.
- **Every In-scope line points at something**: a file, a test, a ticket. A line
  with nothing behind it is a wish, and belongs under Later.
- **The stamp moves only after a full check against the code**: the baseline that
  created the plan, or a reconcile. Editing the plan without that check does not
  earn a new stamp.
- **The Rework log is how the plan learns.** Reconcile adds a line for each ticket
  that needed a follow-up fix. A cause that appears twice becomes a proposed line in
  the repo's agent instructions or the ticket checklist, and the log says where it
  went.
- **Other planning files point here.** A feature list, phase list or README section
  that describes scope either links to this file or is kept in agreement with it
  on every reconcile. Which of those it is was the user's call.
