# Pi Skills

## Purpose

This is the initial Pi skill and extension set.

Skills are partly automatic and partly deliberately invoked by the user.

Keep the set small.

## Scope Guard

Enforce the active `/thesis`, `/app`, `/k3s-stack`, `/memory`, or `/agent`
scope.

The skill:

- identifies the active scope;
- loads relevant context;
- prevents unrelated writes;
- identifies cross-scope work before editing.

## Context Loader

Load the minimum useful project state:

1. current task;
2. relevant architecture state;
3. relevant ADRs;
4. recent lessons;
5. recent session state.

Do not load unrelated files.

## Context Compaction

When the context window becomes too large:

1. identify durable state;
2. write a compact session state;
3. continue using the compact state;
4. do not reload discarded conversation unnecessarily.

Keep:

- objective;
- current state;
- completed work;
- decisions;
- failures;
- next actions;
- relevant paths.

There is no automatic monthly rotation.

## Concise Response

Use:

- English only;
- short sentences;
- direct wording;
- one idea per sentence;
- no unnecessary introduction;
- no repeated conclusion;
- lists where useful;
- diagrams where useful.

Avoid marketing language and AI filler.

## Git Domain Check

Detect staged changes across:

- `app/`
- `k3s-stack/`
- `memory/`
- `.agent/`
- `thesis/`

If more than one domain is staged, stop and require separate commits.

Commit prefixes:

- `app:`
- `infra:`
- `memory:`
- `thesis:`

The check must work on every development machine.

## Project-State Inspection

Distinguish repository state from live cluster state.

```text
Git
 |
 v
Flux
 |
 v
Static Kubernetes resources

User
 |
 v
Platform API
 |
 v
Runtime project resources
```

Inspect the live cluster when the task depends on actual runtime state.
