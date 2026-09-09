# hestia

A self-service development-container platform on k3s. See `.agent/PLAN.md` for the project plan.

## Pre-commit hooks

The repo uses the `pre-commit` framework for commit-time checks. The hooks do three things:

1. Format Python in `app/` with `ruff format`.
2. Format YAML in `k3s-stack/` with `prettier`.
3. Build every `kustomization.yaml` in the repo. A build error blocks the commit.

The formatters change only their own scope. A file outside `app/` or `k3s-stack/` stays untouched.

### Prerequisites

- `pre-commit` — the hook runner.
- `kustomize` or `kubectl` — the build check needs one of these. The script prefers `kustomize`
  and falls back to `kubectl kustomize`.

`ruff` and `prettier` need no manual install. The framework builds them from the pinned
versions in `.pre-commit-config.yaml`.

### Install

Run these commands one time on each machine:

```bash
pip install pre-commit    # or: pipx install pre-commit
pre-commit install
```

`pre-commit install` writes the git hook into `.git/hooks/`. The checks then run on each commit.

### Use

The hooks run automatically on `git commit`. To run them by hand on every file:

```bash
pre-commit run --all-files
```

If a formatter changes a file, the commit stops one time. Stage the change and commit again:

```bash
git add -u
git commit
```
