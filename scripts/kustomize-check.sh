#!/usr/bin/env bash
# Build every kustomization in the repo. Fail the commit on a build error.
# Prefer the kustomize binary. Fall back to kubectl kustomize.
# Output shows errors only. Exit 1 if any build fails, 0 if all pass.
set -uo pipefail

# Pick the build command.
if command -v kustomize >/dev/null 2>&1; then
  build() { kustomize build "$1"; }
elif command -v kubectl >/dev/null 2>&1; then
  build() { kubectl kustomize "$1"; }
else
  echo "kustomize-check: no kustomize and no kubectl on PATH. Install one, then commit again." >&2
  exit 1
fi

# Repo root, so the hook works from any subdirectory.
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Find every kustomization file, build its directory.
failed=0
while IFS= read -r -d '' file; do
  dir="$(dirname "$file")"
  if ! err="$(build "$dir" 2>&1 >/dev/null)"; then
    echo "kustomize-check: build failed in ${dir}" >&2
    echo "$err" >&2
    echo "" >&2
    failed=1
  fi
done < <(find "$root" \
  -type d \( -name .git -o -name node_modules \) -prune -o \
  -type f \( -name kustomization.yaml -o -name kustomization.yml \) -print0)

if [ "$failed" -ne 0 ]; then
  echo "kustomize-check: one or more kustomizations did not build. Fix the errors above." >&2
  exit 1
fi
exit 0
