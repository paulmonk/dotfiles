---
name: changelog
description: Create engaging changelogs for recent merges. Use when asked for a changelog, release notes, or summary of recent changes.
argument-hint: "[optional: daily|weekly, or time period in days]"
allowed-tools: Bash, Read, Glob, Grep
disable-model-invocation: true
---

# Changelog

Create a fun, engaging changelog for an internal development team
by summarising recent merges to the main/master branch, highlighting
new features, bug fixes, and crediting contributors.

## When to Use

- User asks for a changelog, release notes, or "what changed"
- Summarising recent merges for a team update
- Generating release notes for a deployment

## When NOT to Use

- Comparing two specific commits or branches (use `git log` directly)
- Writing a CHANGELOG.md file for a library release (different format)

## Arguments

`$ARGUMENTS`: optional time period. `daily` (last 24h), `weekly`
(last 7 days), or a number for last N days. Defaults to daily.

## Usage

```text
/changelog
/changelog daily
/changelog weekly
/changelog 14
```

## Workflow

Execute every step sequentially.

### 1. Determine Time Period

| Input     | Period                |
| --------- | --------------------- |
| `daily`   | Last 24 hours         |
| `weekly`  | Last 7 days           |
| `<number>`| Last N days           |
| (none)    | Default: last 24 hours|

### 2. Gather PR Data

Run these commands in parallel:

| Command                                          | Purpose                      |
| ------------------------------------------------ | ---------------------------- |
| `gh pr list --state merged --base main -L 50`    | List merged PRs              |
| `gh pr list --state merged --base master -L 50`  | Fallback for master branch   |

For each relevant PR, fetch details:

```bash
gh pr view <number> --json title,body,author,labels,mergedAt,number
```

### 3. Analyse Changes

Look for the following in each PR:

- New features added
- Bug fixes implemented
- Breaking changes (highlight prominently)
- Performance improvements
- Developer experience improvements
- Documentation updates
- Linked issues and their context
- PR labels to identify type (feature, bug, chore)

### 4. Prioritise Content

Order sections by importance:

1. Breaking changes (MUST be at top)
2. User-facing features
3. Critical bug fixes
4. Performance improvements
5. Developer experience improvements
6. Documentation updates

### 5. Generate Output

Use this format:

```markdown
# [Daily/Weekly] Changelog: [Current Date]

## Breaking Changes (if any)

[List any breaking changes requiring immediate attention]

## New Features

[List new features with PR numbers]

## Bug Fixes

[List bug fixes with PR numbers]

## Other Improvements

[List other significant changes]

## Shoutouts

[Credit contributors for their work]
```

## Formatting Guidelines

- Keep concise and to the point
- Group similar changes together
- Include issue references where applicable
- Add a touch of humour or playfulness
- Use emojis sparingly for visual interest
- Format code/technical terms in backticks
- Include PR numbers (e.g., "Fixed login bug (#123)")

## Deployment Notes

Include only when explicitly mentioned in PR descriptions:

- Database migrations required
- Environment variable updates needed
- Manual intervention steps post-deploy
- Dependencies that need updating

## Notes

- If no changes in the time period, report: "Quiet day! No new changes merged."
- If unable to fetch PR details, list PR numbers for manual review
- Match the repository's existing changelog style if one exists
