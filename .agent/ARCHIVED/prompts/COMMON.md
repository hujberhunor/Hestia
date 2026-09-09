# Common Agent Prompt

Always load this file first.

## Project philosophy

- Keep Hestia simple.
- Prefer the smallest working MVP.
- Do not add speculative architecture.
- Preserve existing behavior unless task requires change.
- Keep one source of truth for each rule or decision.

## Language and response

- Write persistent project information in English.
- Use concise, direct English responses.
- State result, reason, and next required action.
- Use short sections and lists when they improve clarity.

## Scope discipline

- Identify active scope before editing.
- Load exactly one scope prompt after this file.
- Do not load prompts for unrelated domains.
- Write only inside active scope.
- Detect cross-scope work before editing.
- Load `cross-scope.md` only after explicit cross-scope permission.

## Context loading

- At session start, read `.agent/CONTEXT.md` and `.agent/memory/ARCHITECTURE.md`.
- Read the latest relevant note under `.agent/sessions/` when continuing work.
- Read only context relevant to the current task.
- Do not invent missing project facts.

## Architecture and decisions

- Prefer simple, reversible solutions.
- Record durable architecture changes in `.agent/memory/ARCHITECTURE.md`.
- Do not create separate ADR, lesson, or memory files.
- Separate Git-managed state from live runtime state.

## Git discipline

- Never run `git add`, `git commit`, `git push`, or branch-switching commands.
- Preserve user changes.
- Keep changes within one domain where possible.
- Use commit prefixes: `app:`, `infra:`, `memory:`, `thesis:`.

## Safety

- Never store secrets, private keys, kubeconfigs, or runtime secret values.
- Treat Kubernetes access as security-sensitive.
- Prefer narrow, read-only Kubernetes inspection.
- Ask before destructive or cross-scope changes.
