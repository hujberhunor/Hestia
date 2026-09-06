# Infrastructure Scope Prompt

Scope: `/k3s-stack`

Write only under `k3s-stack/`.

## GitOps boundary

- Flux manages static Kubernetes configuration.
- Platform API manages user-generated runtime resources through Kubernetes API.
- Do not commit normal user runtime resources to GitOps.
- Keep Flux structure simple.

## Kubernetes standards

- Use project namespaces as primary isolation boundaries.
- Keep permissions namespace-scoped unless a real requirement needs more.
- Define resource limits for development workloads.
- Keep secrets out of Git.
- Prefer declarative, readable manifests.
- Validate YAML and Kubernetes structure with available repository tools.

## Cluster assumptions

- Initial target is k3s.
- Initial infrastructure is small.
- Do not add SSO, operators, GPU support, advanced monitoring, or multi-environment
  structure without a concrete requirement.
