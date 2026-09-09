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

`.agent/skills/<name>/SKILL.md`, one directory per skill. Kiro also discovers them through
`.kiro/skills`, a symlink to this directory.

Currently available:
- `session-memory` — creating, recording into, and compressing the session file
- `context-management` — deciding what to read, and compressing the live context window
- `asd-ste100` — Simplified Technical English writing/linting, loaded as a Kiro skill with a
  session-start rule card — see note below
- `skill-loader` — this skill

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
| Any chat reply to a person | `asd-ste100` (Layer 2 governs the reply shape) |
| Creating, updating, or reading a session file | `session-memory` |
| Deciding what files/dirs to read, or context usage is getting high | `context-management` |
| Writing prose into a session file, `PLAN.md`, or similar project doc | `session-memory` + `asd-ste100` (see note) |
| Ordinary code editing, git inspection, or a one-off question with no session/doc writing | none extra — the asd-ste100 card already loaded at session start; follow `SYSTEM_PROMPT.md` |

## Note on `asd-ste100`

`asd-ste100` loads two ways in Kiro. The `ste` agent runs an `agentSpawn` hook that prints a
short rule card into context at session start, so the core Layer 1 and Layer 2 rules are
always present. The full ruleset loads on demand when you open the skill for writing or
review. There is no per-turn hook and no reply gate in Kiro — the Claude Code hooks
(`UserPromptSubmit`, `PostToolUse`, `Stop`) do not fire here. Lint prose by hand:
`python3 .agent/skills/asd-ste100/scripts/ste-lint.py --fail-over 2.5 FILE`.

## How Kiro discovery relates to this procedure

Kiro surfaces every skill under `.kiro/skills/*/SKILL.md` as a `/name` slash command
automatically. That is discovery only — it makes a skill available. This procedure still
decides which skills to actually apply to a task. Use the lookup table to choose; use the
slash command or the skill body to load the detail.
