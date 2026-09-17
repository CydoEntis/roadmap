# Roadmap

A planning skill for Claude Code (`/roadmap`) and Codex (`$roadmap`), for anything
from one bug to a whole project. It decides what is in, what is out, and what order
the work happens in. It keeps that answer true against the code, and turns only the
next step into tickets an unattended agent can finish.

## Modes

**The rule: no plan yet → `init`. Want something built → name its type, or `add`
if you're not sure. Is the plan still true → `reconcile`.**

```
/roadmap bug <thing>       something broke
/roadmap feature <thing>   something new
/roadmap change <thing>    works as designed, want it different
/roadmap task <thing>      no user-visible change (refactor, deps, docs)
/roadmap add <thing>       not sure which: the type gets worked out
/roadmap init              once per project: create the plan
/roadmap reconcile         is the plan still true?
```

- **`init`**: once per project, when there is no plan yet.
  1. Build an evidence-backed baseline.
  2. Decide keep / merge / decline / defer with the user.
  3. Lay out a phase chain with exit conditions.
  4. Write tickets for the first phase.
- **`bug` / `feature` / `change` / `task` / `add` + `<thing>`**: anything to build,
  any size, from one bug to a feature big enough to become its own phase.
  1. Check it against the plan for overlap.
  2. Settle its type and size from evidence. A named type is checked, not trusted:
     a "bug" with no documented expected behaviour is really a feature or change.
  3. When it has open decisions, question it into an `intent.md` (plus a
     `spec.md` when design needs one). Small bugs and tasks with nothing undecided
     skip this.
  4. Place it in the plan.
  5. Draft, file and prove its tickets.
- **`reconcile`**: an existing plan.
  1. Check it against code, history and tracker.
  2. Resolve every mismatch.
  3. Review rework (follow-up fixes) and turn repeated causes into lessons.
  4. When the active phase is done, close it and ticket the next one.

With no mode named: something to build → `add`; otherwise, a plan exists →
`reconcile`; otherwise → `init`.

## Interactive by default

Every decision, confirmation and approval is a question.

- **Claude Code:** questions pop up through `AskUserQuestion`.
- **Codex:** they pop up through `request_user_input`. Codex offers it in **Plan
  mode**, and in Default mode only when its experimental switch is on (see below).
  Plan mode can't write files, so do the questioning there, then leave Plan mode to
  write and file what you approved.
- **Codex Default mode:** it asks one plain-text question at a time.

**Goal: pop-ups everywhere, including Codex Default mode.** Codex (0.154) has an
experimental switch for this, `default_mode_request_user_input`
(`codex features enable default_mode_request_user_input`). Codex's Default-mode
instructions still limit the tool to optional questions, so it may not pop up for
every decision. When the switch graduates, update `references/asking.md` and this
section.

## What it writes

- **One plan doc** (`docs/PLANNING.md` by default): the source of truth for scope and
  order.
- **Feature docs** (`docs/features/<slug>/`): `intent.md` in the requester's words,
  and `spec.md` when needed. The ordered tickets are the implementation plan.
- **ADRs**, only for decisions that are hard to reverse, surprising, and a real
  trade-off.
- **A glossary** (`CONTEXT.md`), created only when a term needs settling.
- **Tickets**, filed wherever and however this repo files them. They are always small. Each passes a size check (one thing, ships alone,
  about five criteria and five files at most, a quick review, a short agent run).
  They have pass/fail criteria, failing-test-first for bugs, a visual check for UI,
  and a Context section of pointers into the code. Work is grouped in the plan or
  the tracker, never by making one big ticket.

It borrows from Matt Pocock's grilling skills (question rounds with recommendations,
glossary discipline) and from Anthropic's *AI-native SDLC playbook* (the
intent → spec → plan chain, the self-checking loop, one declared source of truth).

## Contents

- `SKILL.md`: the router and the rules every mode shares
- `init.md`, `add.md`, `reconcile.md`: the method for each mode
- `references/`: `plan-doc.md`, `intent.md`, `spec.md`, `adr.md`, `ticket.md`,
  `asking.md`
- `agents/openai.yaml`: Codex UI metadata

## Boundaries

- It writes no code and runs no tickets.
- It creates or changes documents, tickets and tracker records only after showing
  them and getting approval. Tracker edits are approved one at a time.
- It never commits unless asked.
- It assumes no tracker and no way of working. It works out how this repo files
  tickets: from what you say, the skills, connectors and CLIs the session has, and
  the repo's docs, templates, commit history and ticket-pulling config. It confirms
  what it found with you, then follows it. When it can't tell, or can't do it from
  this session, it hands you the approved tickets to file yourself.
- It depends on no other skill. It names the question tools only to use them where
  a session has them.

## Install

```sh
ln -s ~/personal/roadmap ~/.claude/skills/roadmap
ln -s ~/personal/roadmap ~/.codex/skills/roadmap
```
