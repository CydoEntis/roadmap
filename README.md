# Roadmap

A planning skill for Claude Code (`/roadmap`) and Codex (`$roadmap`), for anything
from one bug to a whole project. It decides what is in, what is out, and what order
the work happens in, keeps that answer true against the code, and turns only the
next step into small tickets an unattended agent can finish.

It plans. It never writes code, and it never works a ticket.

- [Why](#why)
- [Install](#install)
- [Commands](#commands)
- [A session, start to finish](#a-session-start-to-finish)
- [What it writes](#what-it-writes)
- [How it files tickets](#how-it-files-tickets)
- [The rules it always follows](#the-rules-it-always-follows)
- [Interactive by default](#interactive-by-default)
- [More examples](#more-examples)
- [When something goes wrong](#when-something-goes-wrong)
- [Contents](#contents)
- [Credits](#credits)

## Why

One repository removed a feature's controls from its app. The next day its feature
list still marked the feature `done`, a new ticket asked an agent to "finish" it,
and an older ticket said it must never come back. Each document was right the day it
was written.

Plans rot because nothing re-reads them against the code, and work gets sliced
several ways because starting it costs nothing. So this skill keeps one plan per
project, makes every claim carry its evidence, and has a pass whose whole job is to
check the plan against reality.

## Install

```sh
git clone git@github.com:CydoEntis/roadmap.git ~/personal/roadmap
ln -s ~/personal/roadmap ~/.claude/skills/roadmap    # Claude Code
ln -s ~/personal/roadmap ~/.codex/skills/roadmap     # Codex
```

Nothing else to set up, and nothing to add to your repos. Claude Code sees
`/roadmap`; Codex sees `$roadmap`.

## Commands

```
/roadmap bug <thing>       something broke
/roadmap feature <thing>   something new
/roadmap change <thing>    works as designed, want it different
/roadmap task <thing>      no user-visible change (refactor, deps, docs)
/roadmap add <thing>       not sure which: the type gets worked out

/roadmap init              once per project: create the plan
/roadmap reconcile         is the plan still true? did a phase finish?
```

**The rule: no plan yet → `init`. Want something built → name its type, or `add` if
you're not sure. Is the plan still true → `reconcile`.**

Size doesn't pick the command. `/roadmap bug a paste drops the link text` is
probably three small tickets; `/roadmap feature sync across devices` becomes a new
phase in the plan. Both go through the same five steps:

| Step | What happens |
|---|---|
| **0 Overlap** | Is this already planned, ticketed, ruled out, or already working? |
| **1 Sort** | Type and size, from evidence, confirmed with you. |
| **2 Intent** | Questions until nothing is open → `intent.md`. Skipped for small work with nothing undecided. |
| **3 Spec** | Only when tickets can't hold the decisions → `spec.md`. |
| **4 Place** | Where the work sits in the plan. |
| **5 Ticket** | Confirm where tickets go, draft, show, file, prove. |

`init` does a whole-project version of the same thing: baseline → decisions →
phases → plan doc → tickets for the first phase. `reconcile` runs it backwards:
it re-reads the plan against the code, tracker and history, fixes what disagrees,
and opens the next phase when the current one is done.

## A session, start to finish

You report something broken. The skill's first move is to check, not to build.

> **You:** `/roadmap bug pasting a link into a note loses the link text`

**Step 0 — Overlap.** It searches the plan, the tracker and recent branches first:

> Two things already cover part of this:
> - **#147** "finish plain-text paste and link display" is open and approved for an
>   agent, blocked by #145.
> - **It works as designed today.** `plain-text-paste.ts:5-14` reads only
>   `text/plain`, and a test pins the behaviour (`plain-text-paste.test.tsx:84-100`).
>
> ❓ **Overlap** — #147 owns paste and requires plain text. Is this new work after it?
> → *New work after #147 (Recommended)* · Fold into #147 · Covered by #147

**Step 1 — Sort.** You said bug, so it checks that against the evidence:

> Nothing promised that links survive a paste, and three sources promised the
> opposite: `paste-normalization.ts:9-12`, ADR-0003 §7, and the README section from
> commit `3127c5d`.
>
> ❓ **Type & size** — Plan this as a change, several tickets?
> → *Change, several tickets (Recommended)* · Bug, one ticket · Feature: a
> paste-as-link command

**Step 2 — Intent.** Rounds of questions, each with a recommended answer, each
testing an edge: unsafe links, a label that is itself a URL, pasting into code,
a label the plain text doesn't contain. Then it writes
`docs/features/paste-keeps-links/intent.md` and asks you to accept it.

**Step 4 — Place.** It shows the line it would add to your scope file and where the
work sits in the order, and waits for approval.

**Step 5 — Ticket.** It confirms where tickets go ("GitHub issues in
`CydoEntis/knapkn`, labelled `enhancement` + `mule-ready`?"), then shows three small
tickets, in order, each with a `Blocked by` line. After you approve, it files them,
reads them back, checks that the ticket-pulling query would see them, and writes the
numbers into the plan and the intent.

**Handoff.** Finally: what state the plan is in, what was decided and where it's
recorded, what changed, the next unblocked ticket, and anything still open.

## What it writes

Files stay in the repo as the plan's record. They are never deleted as cleanup; they
change status instead. Only temporary things (a worktree used to run your tests, a
scratch file) are cleaned up.

### The plan doc — `docs/PLANNING.md`

One file: what's in, what's out, and the order. It links to tickets rather than
repeating them.

```markdown
# Plan: Harbor

Source of truth for scope and order. Tickets hold the detail.
Last reconciled: 2026-09-17 at `47b67dc` on `dev`.
Verify: `bash tests/run`

## Now

Active phase: **1 — A finished job's branch stays reviewable until its work lands**
Next unblocked: #12 — keep a finished job's branch in view

## Phases

### 1 — A finished job's branch stays reviewable until its work lands · active

Exit when:
- every ticket below is closed and its change is on `dev`;
- `bash tests/run` passes on `dev`;
- a finished job's branch shows in `hbr check` until its commits land.

1. #12 — keep a finished job's branch in view
2. #13 — leave it out once its pull request merged · after 12

### 2 — No more than three jobs work at once, even after `hbr msg`

Open decisions:
- Does `msg` refuse, or warn?

## In scope
- Overview, jobs, runs, check, review — shipped — `tests/*.test.sh`

## Out
- Kept in AGENTS.md "What Harbor does not do" (the repo's own list).

## Later
- Overnight watch — deferred 2026-09-17: nothing to build yet. Comes back when a
  night is left running.

## Decisions
- [ADR-0001](docs/adr/0001-harbor-starts-runs.md) — Harbor starts Tugboat runs

## Rework
- 2026-09-17 #31 → #35: planning gap, the empty case was never asked → AGENTS.md
```

### Feature docs — `docs/features/<slug>/`

`intent.md` says why the work exists, in your words. `spec.md` is added only when
the tickets can't hold the decisions (a new screen, a data change, an interface
others use, requirements spanning several tickets). Its concerns come first,
because that's what a reviewer reads first.

```markdown
# Intent: Paste keeps links

Type: change
Author: Cody · Status: accepted · Date: 2026-09-17
Plan: docs/PLANNING.md#phase-3

## Problem
Pasting a link into a note loses it. The words arrive, the URL is gone. This
overrides "HTML is never read" (ADR-0003 §7).

## Proposed outcome
Safe http(s) links arrive as `[label](url)`.

## Affected users and systems
The editor's paste path, link display, the smart-text evaluator.

## Constraints
Pasted HTML is parsed inert. `src/core` stays free of DOM code (AGENTS.md rule 3).

## Out of scope
Bold, italics, lists.

## Open questions
None.

## Tickets
#158, #159, #160
```

### ADRs, and a glossary

An ADR only when a decision is **hard to reverse**, **surprising without context**,
and **a real trade-off** — all three. A glossary (`CONTEXT.md`) only when a term
actually needs settling, and never empty.

### Tickets

Always small. Every ticket passes a size check: one thing, ships alone, about five
acceptance criteria and five files at most, a diff you can read in one sitting, and
short enough for an agent to finish in one run.

```markdown
## Goal

In the note browser, Ctrl/Cmd+Shift+P pins the highlighted note and the list
re-sorts pinned-first.

Intent: [Pin from the note browser](docs/features/pin-from-browser/intent.md) · Covers: R1–R4

## Acceptance criteria

- [ ] The shortcut pins the highlighted note, which joins the pinned group —
      new test in `src/App.test.tsx`
- [ ] The highlight and focus stay put — same test file
- [ ] A failed pin announces "The note could not be pinned" and the order is unchanged
- [ ] `pnpm test` passes

## Visual check

All notes at 1280×800 with 3 notes: a pinned row shows the existing badge, and the
footer shows the shortcut hint.

## Non-goals

- No per-row buttons, no reordering of pinned notes, no sidebar changes.

## Context

- Change: `src/features/notes/note-browser.tsx` — `handleInputKeyDown`; add an
  `onTogglePin` prop
- Copy the pattern in: `src/App.tsx` — the `changeNoteOrder` calls (~1987)
- Watch out: `pinnedFirst` and `notes-repository.ts:92` already sort — don't add a
  second sort
- Test: add beside "browses pinned notes first" in `src/App.test.tsx`

## Impact

- Docs: the README's keyboard shortcuts

Blocked by #146
```

Bugs get a **Reproduction** section and must be proven by a test that fails first
and isn't edited by the fix. Tasks (refactors, dependencies, docs) must prove that
users see no difference. Work only a person can do is marked as such and kept out of
any agent's queue.

## How it files tickets

The skill knows nothing about GitHub, Linear, Plane or Jira, and requires no setup
in your repo. Each time, it works out how *this* project files tickets:

1. **What you said.**
2. **What the repo shows** — its docs, its issue templates, how commits and branches
   name tickets (`#123` vs `APP-123`), and the config of anything that pulls tickets
   to work on. This decides *where* tickets go.
3. **What the session can reach** — a skill or command for that tracker, a connector,
   or its CLI. This decides *how* to get them there.

Then it confirms with you before drafting:

> ❓ **Filing** — File these in Linear team APP through the connector: assigned to
> you, Todo, labelled `repo:platform-dashboard` + `triage:ready-for-agent`, blockers
> as relations?
> → *Linear APP via connector (Recommended)* · Without `ready-for-agent` · Just give
> me the tickets

It follows what it finds, including the repo's own ticket template and labels, which
override this skill's defaults. **If it can't tell, or the session can't reach the
tracker, it hands you the tickets ready to paste.** After filing, it reads each
ticket back and checks that a ticket-pulling query would actually see it.

## The rules it always follows

- **Facts are its job, decisions are yours.** It never asks what it can look up, and
  never settles a product decision for you.
- **Every claim carries evidence** — a file and line, a command's output, a commit,
  a ticket. Anything unverified is labelled an assumption.
- **It shows before it writes.** Documents and tickets are approved first; changes to
  existing tickets are approved one at a time.
- **It stays on the path.** Whatever else it notices, it doesn't propose refactors or
  clean-ups you didn't ask for. The one exception is something that would break the
  planned work or risk your data, which gets a single line at the end.
- **Only the active phase gets tickets**, unless your repo's own rules say otherwise.
- **No open question reaches a ticket.** It gets answered, deferred, or split off.
- **Your repo's rules win**, whether that's the ticket template, the labels, or how
  far ahead you ticket.
- **It never commits** unless you say so.

## Interactive by default

Every decision, confirmation and approval is a question.

- **Claude Code:** questions pop up through `AskUserQuestion`, up to four at a time,
  with the recommended option first and "Other" always available.
- **Codex:** they pop up through `request_user_input`. Codex offers it in **Plan
  mode**, and in Default mode only when its experimental switch is on (below). Plan
  mode can't write files, so the questioning happens there, and you leave Plan mode
  for it to write and file.
- **No question tool:** it falls back to numbered questions in plain text, each with
  a recommended answer.

Say **"one at a time"** for one question per turn, or **"just ticket it"** to skip
the questioning for something obvious.

**Goal: pop-ups everywhere, including Codex Default mode.** Codex (0.154) has an
experimental switch, `default_mode_request_user_input`
(`codex features enable default_mode_request_user_input`). Codex's Default-mode
instructions still limit the tool to optional questions, so it may not pop up for
every decision. When the switch graduates, update `references/asking.md` and this
section.

## More examples

**A new project with no plan**

```
/roadmap init plan out harbor so I know what to build next
```

It reads the repo, runs your tests, and shows what exists with evidence, plus every
contradiction it found. It asks you to dispose of each one (keep / merge / decline /
defer), proposes a phase chain where each phase ends in something observable, writes
the plan, and tickets the first phase only.

**A cleanup**

```
/roadmap task consolidate the duplicated date-formatting helpers
```

If most of the duplication is already gone, it says so, with the commit that did it,
and asks whether the leftovers are the work. If the leftovers change what users see,
it tells you it isn't a task after all.

**Checking a plan**

```
/roadmap reconcile
```

It compares the plan with the code, tracker and history, and lists mismatches worst
first: work marked done that was removed, tickets open whose change already merged,
tickets that contradict a decision, blockers an agent will never see. Mechanical
fixes need only your approval; the rest become questions. When the active phase's
exit condition holds, it closes the phase and tickets the next one.

## When something goes wrong

| What you see | What it means |
|---|---|
| It asks how tickets are filed | It found no evidence in the repo. Answer once, and it offers to note it for next time. |
| It says "just give me the tickets" is the only option | The session can't reach your tracker (no connector, no CLI, no key). Paste them yourself. |
| It calls your bug a change | Nothing in the repo promised the behaviour you expected. Say so, and it plans it as a bug. |
| It refuses to run `init` | The repo already has a plan. Use `reconcile`, or `add` for new work. |
| It stops before writing | Something changed under it, or the approval hasn't happened yet. |
| Questions arrive as plain text in Codex | You're in Default mode without the experimental switch. Use Plan mode for pop-ups. |

## Contents

| File | What it holds |
|---|---|
| `SKILL.md` | The commands and the rules every mode shares |
| `init.md`, `add.md`, `reconcile.md` | The method for each mode |
| `references/plan-doc.md` | The plan doc's shape and its upkeep rules |
| `references/intent.md`, `spec.md` | Feature docs |
| `references/adr.md` | ADR shape and supersession |
| `references/ticket.md` | The ticket checklist, the size check, and the body |
| `references/asking.md` | Which question tool a session has, and its limits |
| `agents/openai.yaml` | Codex UI metadata |

## Credits

It borrows from Matt Pocock's [grilling skills](https://github.com/mattpocock/skills)
(question rounds with recommendations, glossary discipline) and from Anthropic's
*AI-native SDLC playbook* (the intent → spec → plan chain, work that checks itself,
one declared source of truth).
