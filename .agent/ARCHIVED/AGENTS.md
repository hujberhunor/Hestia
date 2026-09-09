# Hestia Agent Bootstrap

Read this file first when starting work with any agent or harness.

## Session start

1. Read `.agent/CONTEXT.md`.
2. Read `.agent/memory/ARCHITECTURE.md`.
3. Read the latest relevant note under `.agent/sessions/` when continuing work.
4. Read the applicable scope prompt under `.agent/prompts/` only when task needs scope-specific rules.

## During work

- Keep project facts in `.agent/CONTEXT.md`.
- Keep architecture diagrams and architecture invariants in `.agent/memory/ARCHITECTURE.md`.
- Do not create ADR, lesson, or other memory files for routine work.
- Keep temporary task state in the current session note.
- Ask before destructive or cross-scope changes.

## Session end

Create or update `.agent/sessions/YYYY-MM-DD-session.md`.

Record:

- task;
- important decisions and reasons;
- completed work;
- current state;
- next steps.

Do not rewrite the `My Notes` section. Update `.agent/CONTEXT.md` only when durable project context changed.
