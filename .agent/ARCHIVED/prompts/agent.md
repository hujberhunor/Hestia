# Agent Workflow Scope Prompt

Scope: `/agent`

Write only under `.agent/`.

Use `.agent/AGENTS.md` as bootstrap. Keep durable context in `.agent/CONTEXT.md`, architecture in `.agent/memory/ARCHITECTURE.md`, and continuation notes in `.agent/sessions/`.

## Workflow files

- Keep universal rules in `prompts/COMMON.md`.
- Keep domain rules in one scope prompt.
- Keep model-specific behavior in `instructions/`.
- Keep Pi behavior in `skills/`.
- Keep plans and task checklists in the `.agent/` root.

Do not duplicate project rules between prompt layers.
Update loading references when moving prompt files.
