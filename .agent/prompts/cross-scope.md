# Cross-Scope Prompt

Load only when task requires more than one project scope.

## Loading procedure

1. Detect every required scope.
2. State why each scope is required.
3. Request explicit permission before writing across scopes.
4. Load only the scope prompts for detected scopes.
5. Keep edits grouped by scope.
6. Validate each scope separately.

Never load all scope prompts by default.

## Common cross-scope cases

- Application API plus Kubernetes manifests: `/app` and `/k3s-stack`.
- Architecture decision plus implementation: `/memory` and affected domain.
- Thesis update based on implementation: `/thesis` and affected domain.
