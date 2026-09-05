# Project Memory

`memory/` is the canonical location for durable project knowledge.

- `architecture/` — current architecture and project state;
- `adr/` — durable architecture decisions;
- `lesson/` — reusable lessons and known pitfalls;
- `session/` — compact continuation state.

Write persistent information in English. Do not store secrets, private keys,
kubeconfig data, or runtime secret values.
