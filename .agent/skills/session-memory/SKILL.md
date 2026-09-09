---
name: session-memory
description: Create, maintain, and compress the per-session memory file under sessions/. Use at the start of a session (create/resume), whenever a decision is made (record it), and when context usage is high (compress). This is the agent's only persistent memory across sessions and doubles as raw material for the thesis.
---

# Session Memory

## Purpose

A session file is the agent's memory of one working session — what was worked on, what was
decided and why, and what's needed to pick the work back up. It serves two audiences:

1. **You (agent), next session** — enough to resume without re-deriving context.
2. **The user, later** — a record of decisions and reasoning to draw on when writing the thesis.

Keep it short. A session file that's long enough to need its own summary has failed at its job.

## Writing style

All prose written into a session file — Task, Decisions, State, Open questions, Thesis
note — must be phrased using the `asd-ste100` skill (Simplified Technical English), with no
exceptions. Load that skill before writing or editing any content in this file, not just at
session start. This applies to everything written into the file, including decision
statements — rephrase into STE100 rather than copying the user's own wording verbatim.

## File location and naming

Path: `sessions/<date>-<focus>.md`

- `<date>` — `YYYY-MM-DD`
- `<focus>` — the main focus of the session, **max 3 words**, lowercase, hyphen-separated

Examples:
- `sessions/2026-09-09-approval-flow.md`
- `sessions/2026-09-10-undo-skill.md`
- `sessions/2026-09-12-thesis-outline.md`

One file per session. Do not append unrelated work from a later session into an old file —
start a new one. If a session continues the *same* task across multiple sittings on the same
day, append to the existing file rather than creating a near-duplicate.

## When to create vs. resume

- **New task, new day, or materially different focus** → create a new session file.
- **Continuing the same task from where a prior session left off** → read the most recent
  relevant session file first, then keep working in it (or reference it explicitly if
  starting a new file for a new sub-phase).

At the start of any task, check `sessions/` for a file whose focus matches the current work
before assuming there's no prior context.

## Structure

Use this template. Omit a section entirely if it's empty — don't leave placeholder headers
with nothing under them.

```markdown
# <date> — <focus>

## Task
<One or two sentences: what this session is trying to accomplish.>

## Decisions
- **<short decision statement>** — <reasoning: why this and not an alternative>
- **<short decision statement>** — <reasoning>

## State
<Where things stand right now — what's done, what's in progress, what's blocked.
A few bullets, not a narrative.>

## Open questions
- <anything unresolved that the next session (or the user) needs to address>

## Thesis note
<Only if this session involved a decision worth remembering for the thesis specifically —
architecture, methodology, or agent-design reasoning. One or two lines. Omit if nothing
qualifies — do not force every session to have one.>
```

## What goes in — and what doesn't

**Always record:**
- Every decision that was actually made, paired with the reason it was made this way and not
  another way. A decision without its reasoning is close to useless later — write the
  reasoning at the time, not from memory afterward.
- The current state needed to resume work correctly.
- Genuinely open/unresolved questions.

**Never record:**
- Blow-by-blow narration of exploration ("first I checked X, then Y, then realized Z") —
  keep only the conclusion and, if it matters, the reason the conclusion was non-obvious.
- Full file contents or diffs — the repo and git history already hold those; reference paths
  or commit-adjacent descriptions instead ("approval gate added to `SYSTEM_PROMPT.md` §4").
- Restated information that's already in `PLAN.md` or `SYSTEM_PROMPT.md`. Link to it by
  section instead of copying it in.
- Anything speculative that wasn't actually decided ("we might later want to...") — that
  belongs in Open questions, not Decisions, unless the user explicitly decided to defer it.

## Recording a decision

Write it the moment it's made, not at session end from memory. Format:

```markdown
- **Approval required per-file-write, not per-task** — a single "yes" at task start would
  let scope creep in silently; per-write keeps the user in the loop on each actual change.
```

One line for the decision, one clause for the reasoning. If the reasoning genuinely needs
more than a sentence, it's probably thesis-relevant — put the short version here and the
longer version in the Thesis note.

## Compression

Trigger: when context usage is high (per the system prompt's 60% threshold) or when a
session file itself has grown long enough that reading it back costs more than it saves.

Procedure, in order:
1. **Collapse resolved Open questions.** If a question was answered later in the same
   session, remove the question and fold the answer into Decisions or State — don't leave
   both the question and its resolution.
2. **Merge redundant State updates.** If State was updated three times over the session,
   keep only the current, final version — not the history of how it got there.
3. **Shorten decision reasoning to its essential clause.** Cut hedging and repetition, keep
   the actual reason. Never cut the reason down to nothing — a decision with no reasoning
   left is a violation of this skill, not a valid compression.
4. **Never touch:** decisions themselves, their (shortened) reasoning, unresolved open
   questions, or the Thesis note.

Compression produces a shorter version of the same file — same filename, rewritten content.
It is not a new file and not an archive. If you genuinely need the pre-compression detail
later (rare), that's what git history of the session file itself is for — the agent doesn't
need to keep a manual backup.

After compressing, re-read the result and confirm: could the next session resume correctly
from this alone? If no, restore whatever was cut too aggressively.

## Anti-patterns to avoid

- A session file that reads like a transcript. If you're tempted to write "the user then
  asked me to..." — stop and extract only the decision or fact that resulted.
- A "Decisions" section with vague entries like "discussed approach" — that's not a decision,
  it's a note that a discussion happened. Only record the actual outcome.
- Growing the template with new sections per session. Five sections is the ceiling; if
  something doesn't fit, it probably belongs in `PLAN.md` instead of session memory.
