# Phase 1 Todo — Repository and AI Workflow Foundation

## Current state

- The repository contains the project plan, agent instructions, and basic
  Ansible files.
- `app/`, `k3s-stack/`, `scripts/`, `thesis/`, and the top-level `memory/`
  directories do not contain implementation files yet.
- `.agent/instructions/` contains agent instructions.
- `.agent/skills/` contains Pi skills.
- `memory/` is the canonical location for durable project memory.
- No versioned Git hook or hook installation script exists yet.
- No application or Kubernetes deployment has been started.

## Goal

Prepare a clean and portable repository workflow before implementing the
platform API, Kubernetes resources, or user-facing clients.

## Todo

### Repository structure

- [x] Reconcile agent workflow files with durable project memory.
- [x] Choose `memory/` as the canonical location for architecture state, ADRs,
      lessons, and session state.
- [ ] Document the purpose and boundary of `app/`, `k3s-stack/`, `scripts/`,
      `ansible/`, `thesis/`, and the memory directories.
- [ ] Keep empty future directories explicit only when the repository workflow
      requires them.

### Git workflow

- [ ] Add a portable, versioned Git hook under `.githooks/`.
- [ ] Add a hook installation script that works from any checkout path.
- [ ] Reject staged changes that span multiple project domains.
- [ ] Map `k3s-stack/` changes to the `infra:` commit prefix.
- [ ] Enforce the documented prefixes: `app:`, `infra:`, `memory:`, and
      `thesis:`.
- [ ] Ensure the hook does not depend on a username, absolute path, or local
      machine configuration.

### AI workflow

- [ ] Make scope selection and write boundaries clear for the current layout.
- [ ] Define how the agent loads architecture, ADR, lesson, and session
      context.
- [ ] Define the required session-compaction format.
- [ ] Create the initial project-state memory with the current baseline,
      constraints, known gaps, and next phase.
- [ ] Verify that the local and API agent instructions use the same memory
      workflow.

### Documentation and verification

- [ ] Document clean-clone setup for the repository workflow.
- [ ] Document Git hook installation.
- [ ] Document the boundary between Git-managed state and live Kubernetes
      state.
- [ ] Test the hook with valid single-domain changes.
- [ ] Test the hook with invalid mixed-domain changes.
- [ ] Verify the workflow from a clean checkout without credentials or
      machine-specific paths.

## Completion criteria

Phase 1 is complete when a new machine can clone the repository, install the
Git hook, identify the active scope, and continue work using one canonical
memory location. Invalid mixed-domain staged changes are rejected clearly, and
valid domain commits follow the documented prefix rules.
