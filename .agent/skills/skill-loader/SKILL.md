---
name: skill-loader
description: Decide which skills a task actually needs, and load only those. Use at the start of every task, before reading any other skill file, and again whenever the task changes materially mid-session.
---

# Skill Loader

## Purpose

Skills are loaded dynamically, not all at once. This skill is the procedure for deciding
*which* ones a given task needs — it's the answer to the open question in the system prompt
about how that decision gets made.

## Where skills live

`skills/<name>/SKILL.md`, one directory per skill.

Currently available:
- `session-memory` — creating, recording into, and compressing the session file
- `context-management` — deciding what to read, and compressing the live context window
- `asd-ste100` — Simplified Technical English writing/linting, installed as Claude Code
  hooks — see note below
- `skill-loader` — this skill

`undo` was considered and is **not implemented**. Don't load or reference it.

## Procedure

1. **Check the lookup table below first.** Most tasks match one of these directly — no need
   to scan every skill's description.
2. **If nothing matches, scan descriptions, not bodies.** Read only the `description` line in
   each skill's frontmatter (cheap) and judge relevance from that alone. Do not open a
   skill's full `SKILL.md` body speculatively just to check if it's relevant — the
   description exists precisely so you don't have to.
3. **Load every skill that applies, not just one.** A single task often needs more than one —
   e.g. writing a decision into the session file needs both `session-memory` (structure) and
   whatever writing-style rules apply.
4. **Don't carry skills forward out of habit.** When the task changes materially, re-run this
   procedure rather than assuming the skills loaded for the previous task still apply.
5. **When genuinely unsure**, ask the user rather than guessing — loading an irrelevant skill
   wastes context, and skipping a needed one produces work that doesn't follow the project's
   own rules.

## Lookup table

| Task involves… | Load |
|---|---|
| Creating, updating, or reading a session file | `session-memory` |
| Deciding what files/dirs to read, or context usage is getting high | `context-management` |
| Writing prose into a session file, `PLAN.md`, or similar project doc | `session-memory` + `asd-ste100` (see note) |
| Ordinary code editing, git inspection, or a one-off question with no session/doc writing | none of the above — just follow `SYSTEM_PROMPT.md` directly |

## Note on `asd-ste100`

`asd-ste100` is installed as Claude Code hooks (`UserPromptSubmit`, `PostToolUse`, `Stop`,
etc.), not as something this loader reads and applies manually — the hook system injects its
rule card automatically every turn once installed. Treat it as always-active infrastructure
rather than a skill you decide to load per task. It's listed above only so `session-memory`'s
reference to it resolves to something real.

## A note on the repo layout

The system prompt currently says skills live under `.agent/skills/`, but the actual directory
in this repo is `skills/` at the root. This document assumes the real, current layout
(`skills/`). Worth fixing the mismatch in `SYSTEM_PROMPT.md` at some point so the two don't
drift further apart.
