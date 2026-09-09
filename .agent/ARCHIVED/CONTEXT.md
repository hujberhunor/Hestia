# Hestia Project Context

## Project

Hestia is a simple self-service development-container platform on k3s. Users authenticate, access an isolated project scope, create a development container, see its status, and connect over SSH.

Simplicity and smallest working MVP have priority. Do not add speculative architecture.

## Repository

- `app/` — user-facing CLI, web, and platform API code when implemented.
- `k3s-stack/` — Flux-managed static Kubernetes configuration when implemented.
- `ansible/` — node bootstrap and infrastructure playbooks.
- `scripts/` — local operational scripts and Git hook tooling.
- `.agent/` — agent bootstrap, durable context, architecture, sessions, prompts, and model instructions.
- `thesis/` — diploma thesis source when implemented.

## Architecture rules

- Flux manages static Kubernetes configuration.
- Platform API manages user-generated runtime resources through the Kubernetes API.
- Project namespace is the primary isolation boundary.
- Runtime project resources are not committed to GitOps.
- Users do not receive direct cluster administration access.
- Keep project permissions namespace-scoped unless a real requirement needs more.
- Never store secrets, private keys, kubeconfigs, or runtime secret values in Git or agent files.

Read `.agent/memory/ARCHITECTURE.md` for diagrams and detailed architecture invariants.

## Agent context model

- This file is durable project context.
- `.agent/memory/ARCHITECTURE.md` is the architecture source.
- `.agent/sessions/` contains task-specific continuation notes.
- `README.md` is human project documentation, not agent memory.
- Do not create separate ADR, lesson, or memory systems.
