# Memory Scope Prompt

Scope: `/memory`

Write only under `.agent/CONTEXT.md`, `.agent/memory/`, and `.agent/sessions/`.

## Memory layout

- `CONTEXT.md` — durable project context;
- `memory/ARCHITECTURE.md` — architecture state and diagrams;
- `sessions/` — task-specific continuation notes.

## Memory rules

- Store durable project knowledge only.
- Write current state, not conversation history.
- Keep one fact in one appropriate file.
- Keep session state short and actionable.
- Never store secrets or credentials.

Do not create ADR, lesson, or other memory files.

## Session compaction

Preserve only:

- objective;
- current state;
- completed work;
- decisions;
- failures;
- next actions;
- relevant paths.
