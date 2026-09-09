---
name: context-management
description: Decide what to read before reading it, and manage the live context window as it fills up. Use before touching any file, directory, skill, or session log, and continuously during long sessions to watch context usage and compress when it gets high.
---

# Context Management

## Purpose

Context is limited and every token read has a cost. This skill governs two related things:

1. **What gets read in the first place** — the minimal-read discipline.
2. **What happens when the live context window fills up** — the compression trigger.

This is separate from the `session-memory` skill, which governs the *persisted* session file
on disk. That file should already be short by construction; this skill is about the agent's
in-conversation working context, which grows during a single long session regardless of how
tidy the session file is.

## Before reading anything

Ask, for every file, directory, skill, or session log:

> Do I need this to perform the current task correctly?

If no, don't read it. This applies uniformly to files, directories, skills, session files,
documentation, and command output — there's no category that gets a free pass.

Concretely:
- Don't read an entire repository by default — go to the specific file(s) the task touches.
- Don't load every skill by default — only the ones the current task actually needs (see
  `skill-loader` for how that decision gets made).
- Don't read every session file by default — only the one matching the current focus, found
  via its filename.
- Don't inspect unrelated documentation "just in case."
- Never read anything inside an `ARCHIVED`-named folder, under any circumstance.

## Read priority order

When several sources could inform the task, read in this order and stop as soon as you have
enough to proceed:

1. Files directly relevant to the task.
2. Files directly referenced by those files (an import, a linked doc, a config it reads).
3. Skills relevant to the task.
4. Session memory relevant to the task (the matching file in `sessions/`).
5. Broader repository information — only if the above didn't answer the question.

Don't jump to step 5 to save a round of asking the user; if steps 1-4 leave a real ambiguity,
ask instead of reading further afield to guess.

## Search discipline

When searching the repo (`grep`, `rg`, or any file-finding tool):
- Use the strictest filter that could plausibly match — a narrow pattern over a broad one.
- Assume the user's own queries are not case-sensitive; don't let that assumption loosen your
  own search patterns when you construct them.
- Prefer searching a specific directory or file type over a repo-wide sweep when the task
  gives you enough information to narrow it.

## Monitoring live context usage

During a session, keep a rough sense of how much of the context window is filled with
exploration history, tool output, and past turns (as opposed to the actual task at hand).

**Trigger: once usage reaches roughly 60%, start compression before continuing the task.**

Don't wait until the window is nearly full — by then there's no room left to compress safely.

## Compression procedure

1. **Checkpoint first.** Before compressing anything, make sure everything essential is
   already written to the current session file (see `session-memory`). If a decision was
   made but not yet recorded, record it now — compression must never be the reason something
   gets lost.
2. **Identify what must survive**, unchanged, in the live context:
   - the current task and objective
   - relevant constraints
   - decisions made so far, and the reasoning behind each
   - current implementation state
   - unresolved questions
   - important facts discovered during the session
   - anything needed to continue the work correctly
   - user preferences or requirements specific to this task
3. **Identify what can be cut or shrunk:**
   - redundant discussion that repeats a point already settled
   - repeated explanations of the same thing
   - obsolete intermediate reasoning that led nowhere
   - exploration that turned out to be irrelevant
   - anything that can be said in fewer words without losing meaning
4. **Produce a smaller representation, not a deletion.** Rewrite the surviving information
   more densely; don't just truncate history and hope nothing needed was in the cut part.
5. **Verify before continuing.** Confirm the compressed context still lets you correctly
   answer: what's the task, what's been decided and why, and what's next. If it doesn't,
   restore whatever was cut too aggressively.

## What this skill does not do

- It does not decide *whether* a skill should be loaded for a task — that's `skill-loader`.
- It does not define the structure of the persisted session file — that's `session-memory`.
- It does not compress or rewrite files already committed to the repo or to `sessions/` — it
  only manages what the agent is actively holding in its working context during the session.
