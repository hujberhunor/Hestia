# Current Project State

## Goal

Build a simple self-service development-container platform on k3s.

The platform will provide authentication, project isolation, development
container creation, status reporting, and SSH access to running containers.

## Repository state

- The repository is at its initial implementation baseline.
- `app/`, `k3s-stack/`, `scripts/`, and `thesis/` contain no implementation
  files yet.
- `ansible/` contains initial node bootstrap, disk resize, and registry
  configuration playbooks.
- `.agent/` contains agent workflow files.
- `memory/` is the canonical location for durable project memory.

## Constraints

- Flux manages static Kubernetes configuration under `k3s-stack/`.
- The platform API manages runtime project resources through the Kubernetes API.
- A project namespace is the primary isolation boundary.
- Users must not need direct cluster administration access.
- Do not add speculative architecture.
- Never store secrets or credentials in Git or project memory.

## Next work

Complete the repository and AI workflow foundation before implementing the
platform API or Kubernetes application resources.
