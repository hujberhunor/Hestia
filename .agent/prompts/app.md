# Application Scope Prompt

Scope: `/app`

Write only under `app/`.

## Application boundaries

- CLI and web UI are user-facing clients.
- Platform API is the control plane.
- API manages runtime project resources through Kubernetes API.
- Users do not receive direct cluster administration access.

## MVP behavior

- Authenticate user.
- Resolve user project scope.
- Create and manage development containers.
- Report starting, running, and failed states.
- Provide SSH connection details for running containers.

## Project model

- Project namespace is primary isolation boundary.
- Runtime project resources are not committed to GitOps.
- User container specification contains only required image, resources,
  runtime configuration, and connection settings.
- Prefer images that already contain tools and dependencies.
- Never store private SSH keys.
