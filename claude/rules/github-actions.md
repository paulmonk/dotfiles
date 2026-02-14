# GitHub Actions

## Security

- **Pin actions to SHA hashes** with a version comment:

  ```yaml
  - uses: actions/checkout@2541b1294d2704b0964813337f33b291d3f8596b  # v3.0.2
    with:
      persist-credentials: false
  ```

  Never pin to tags (`@v3`) or branches (`@main`).

- **persist-credentials: false** on all `actions/checkout`
  steps. This prevents the token from persisting in the
  git config where subsequent steps could extract it.
- **Least privilege tokens**. Use `permissions` at the job
  level (not workflow level) and grant only what's needed.
  Start with `permissions: {}` and add back selectively.

  ```yaml
  jobs:
    build:
      permissions:
        contents: read
  ```

- **No secrets in plain text**. Use `${{ secrets.NAME }}`
  for credentials. Never echo secrets or pass them as
  command-line arguments (visible in process listings).
- **Avoid `pull_request_target`** unless you understand the
  security implications. Prefer `pull_request` for untrusted
  code.
- **Scan workflows** with `zizmor` before committing to
  catch common security issues.

## Structure

- **One concern per workflow file**. Separate CI, release,
  and deployment into distinct files.
- **Descriptive names**. Name workflows and jobs clearly:

  ```yaml
  name: CI
  jobs:
    lint:
      name: Lint and format
  ```

- **Reusable workflows** for shared logic across repos.
  Use `workflow_call` trigger with explicit inputs and
  secrets.
- **Concurrency control**. Cancel in-progress runs for the
  same branch to save resources:

  ```yaml
  concurrency:
    group: ${{ github.workflow }}-${{ github.ref }}
    cancel-in-progress: true
  ```

- **Timeouts**. Set `timeout-minutes` on jobs to prevent
  stuck workflows. Default is 360 minutes which is far
  too generous for most jobs.

## Best Practices

- **Cache dependencies**. Use `actions/cache` or built-in
  caching (e.g. `setup-node` with `cache: pnpm`) to speed
  up builds.
- **Matrix strategies** for testing across versions. Use
  `fail-fast: false` to see all failures:

  ```yaml
  strategy:
    fail-fast: false
    matrix:
      os: [ubuntu-latest, macos-latest]
      node: [20, 22]
  ```

- **Expressions over scripts**. Prefer `if:` conditions
  over shell conditionals for job/step control.
- **Outputs over artefacts** for small values passed
  between jobs. Use artefacts for files.

## Dependabot

Configure Dependabot with cooldowns and grouped updates
to reduce noise:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    groups:
      actions:
        patterns: ["*"]
```
