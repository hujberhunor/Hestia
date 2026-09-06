# Agent Workflow

`.agent/` contains files used to guide AI-assisted project work.

Start with `.agent/AGENTS.md`. It is the harness-independent bootstrap file.

## Layout

- `AGENTS.md` — bootstrap instructions;
- `CONTEXT.md` — durable project context;
- `memory/ARCHITECTURE.md` — architecture state and diagrams;
- `sessions/` — continuation notes;
- `PLAN.md` — long-term project plan;
- `prompts/` — common, scope, and cross-scope prompts;
- `instructions/` — system and model-specific agent instructions;
- `skills/` — Pi skills and extensions.

Durable project knowledge belongs in `.agent/CONTEXT.md` and `.agent/memory/`.

Use `/agent` for agent workflow files and `/memory` for context files.

## Git hook policy

- `app/` uses `app:`.
- `k3s-stack/`, `ansible/`, and `scripts/` use `infra:`.
- `.agent/`, `.githooks/`, and `.github/` use `memory:`.
- `thesis/` uses `thesis:`.
- Feature branches skip validation.
- `main` rejects unknown paths and invalid commit prefixes.
- Mixed domains warn and remain allowed.
- `main` rejects staged trailing whitespace, terminal empty lines, invalid
  YAML, and YAML tab indentation.

Install hooks with:

```sh
scripts/install-git-hooks
```

Temporarily override local hook rules with:

```sh
scripts/toggle-git-hooks off
```

Restore checks with:

```sh
scripts/toggle-git-hooks on
```

Override is stored in local Git config. It is not committed and does not affect
CI checks.

## Prompt loading

Always load:

1. `prompts/COMMON.md`;
2. exactly one scope prompt:
   `app.md`, `thesis.md`, `infra.md`, `memory.md`, or `agent.md`.

For cross-scope work, first request permission. Then load
`prompts/cross-scope.md` and only required scope prompts.

Do not load unrelated scope prompts.

## Prompt responsibilities

- `COMMON.md` — universal rules, safety, scope discipline, architecture
  principles, context loading, and Git discipline;
- `app.md` — application API, client, project, and container lifecycle rules;
- `infra.md` — Flux, GitOps, Kubernetes, and k3s rules;
- `thesis.md` — thesis writing and citation rules;
- `memory.md` — ADR, lesson, session, and durable memory rules;
- `agent.md` — `.agent/` workflow file rules;
- `cross-scope.md` — explicit multi-domain loading and permission procedure.

`instructions/` contains optional model-specific behavior. It must not replace
or duplicate prompt scope rules.

## Loading algorithm

1. Detect task scope.
2. Load `prompts/COMMON.md`.
3. Load exact scope prompt.
4. If task crosses domains, stop and request permission.
5. After permission, load `prompts/cross-scope.md` and required extra prompts.
6. Load only relevant project memory.

`instructions/SYSTEM_PROMPT.md` remains as a compatibility pointer. New sessions
must use `.agent/AGENTS.md` first.
