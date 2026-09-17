# Project Planning Skill

A project-agnostic agent skill for turning ambiguous product or engineering
work into an evidence-based implementation plan with scoped tickets,
dependency chains, acceptance criteria, and verification gates.

The skill is designed to be usable across repositories and planning systems. It
does not assume a particular language, tracker, agent, or workflow.

## Contents

- `SKILL.md` — the reusable agent instructions
- `references/issue-template.md` — a tracker-neutral implementation template
- `agents/openai.yaml` — Codex UI metadata

The skill does not grant permission to modify repositories, trackers, or remote
resources. Those actions still require the user's authorization in the active
project.
