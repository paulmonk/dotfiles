---
name: retro
description: >-
  Use when asked for an engineering retro, shipping summary, or
  git-history comparison on the origin default branch.
argument-hint: "[optional: <Nd|Nh|Nw> or compare [window]]"
allowed-tools: Bash, Read, Write, Glob, Grep
disable-model-invocation: true
---

# Engineering Retro

Generate a retrospective from recent commit history, work
patterns, and code-quality signals. This is a user-invocable
command, so run it when the user asks for `/retro`.

## When to Use

- User asks for a weekly engineering retrospective
- User wants a shipping or velocity summary from git history
- User wants commit/session pattern analysis over a time window
- User wants to compare the current window with the previous one

## When NOT to Use

- User wants a changelog for merged PRs only (use `/changelog`)
- User wants a code review rather than a delivery summary
- The repository has no meaningful git history on `origin`

## Arguments

`$ARGUMENTS`: optional window specifier or compare mode.

## Usage

```text
/retro
/retro 24h
/retro 14d
/retro 30d
/retro compare
/retro compare 14d
```

## Instructions

Parse the argument to determine the time window. Default to 7
days if no argument is given. Accept number-plus-unit values
using `d`, `h`, or `w`. Report all times in London, UK time by
using `TZ=Europe/London` when converting timestamps.

If the argument does not match a supported form, show this usage
and stop:

```text
Usage: /retro [window|compare [window]]
  /retro              — last 7 days (default)
  /retro 24h          — last 24 hours
  /retro 14d          — last 14 days
  /retro 30d          — last 30 days
  /retro compare      — compare this period vs prior period
  /retro compare 14d  — compare with explicit window
```

## Workflow

Execute the workflow sequentially. Run grouped git commands in
parallel when the step says they are independent.

### 1. Resolve the Remote Default Branch

Fetch from `origin`, then detect its default branch. Prefer the
remote HEAD target so the command works on repositories using
either `main` or `master`.

```bash
git fetch origin --quiet
default_branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
if [[ -z "${default_branch}" ]]; then
  for candidate in origin/main origin/master; do
    if git show-ref --verify --quiet "refs/remotes/${candidate}"; then
      default_branch="${candidate}"
      break
    fi
  done
fi
if [[ -z "${default_branch}" ]]; then
  echo "Could not determine the default branch for origin" >&2
  exit 1
fi
```

Use `${default_branch}` for all git queries. Never rely on the
local branch tip for retro data.

### 2. Gather Raw Data

Run all of these git commands in parallel.

```bash
# 1. All commits in window with parent hashes, timestamps,
#    subject, files changed, insertions, deletions.
git log "${default_branch}" --since="<window>" --format="%H|%P|%ai|%s" --shortstat

# 2. Per-commit test vs total LOC breakdown. Each commit block
#    starts with COMMIT:<hash>, followed by numstat lines.
#    Treat these as test files:
#    - directories: test/, tests/, spec/, specs/, __tests__/
#    - filenames: *_test.go, *.test.*, *.spec.*
git log "${default_branch}" --since="<window>" --format="COMMIT:%H" --numstat

# 3. Commit timestamps for session detection and hourly
#    distribution in London, UK time.
TZ=Europe/London git log "${default_branch}" --since="<window>" --format="%at|%ai|%s" | sort -n

# 4. Files changed most often.
git log "${default_branch}" --since="<window>" --format="" --name-only | grep -v '^$' | sort | uniq -c | sort -rn

# 5. Candidate forge references from commit subjects.
#    Capture GitHub-style #123 and GitLab-style !123 refs.
git log "${default_branch}" --since="<window>" --format="%s" \
  | grep -oE '[#!][0-9]+' \
  | sort -V \
  | uniq \
```

### 3. Compute Metrics

Calculate and present these metrics in a summary table.

| Metric | Value |
|--------|-------|
| Commits to default branch | N |
| Estimated change units | N |
| Total insertions | N |
| Total deletions | N |
| Net LOC added | N |
| Test LOC (insertions) | N |
| Test LOC ratio | N% |
| Release markers (optional) | vX.Y.Z → vX.Y.Z or n/a |
| Active days | N |
| Detected sessions | N |
| Avg LOC/session-hour | N |

Only fill `Release markers` when the window includes explicit
tags, version bumps, or release commits. Otherwise show `n/a`.

### 4. Commit Time Distribution

Show an hourly histogram in London, UK time using a bar chart.

```text
Hour  Commits  ████████████████
 00:    4      ████
 07:    5      █████
```

Identify and call out:

- Peak hours
- Dead zones
- Whether the pattern is bimodal or continuous
- Late-night coding clusters after 10pm local time

### 5. Work Session Detection

Detect sessions using a 45-minute gap threshold between
consecutive commits. For each session report:

- Start time and end time in London, UK time
- Number of commits
- Duration in minutes

Classify sessions:

- Deep sessions: 50 minutes or more
- Medium sessions: 20 to 50 minutes
- Micro sessions: under 20 minutes

Calculate:

- Total active coding time
- Average session length
- LOC per hour of active time

### 6. Commit Type Breakdown

Categorise by conventional-commit prefix:
`feat`, `fix`, `refactor`, `test`, `chore`, `docs`.

Show percentage bars, for example:

```text
feat:     20  (40%)  ████████████████████
fix:      27  (54%)  ███████████████████████████
refactor:  2  ( 4%)  ██
```

Flag a fix ratio above 50%. That usually signals a
"ship fast, fix fast" pattern and may suggest review gaps.

### 7. Hotspot Analysis

Show the top 10 most-changed files. Flag:

- Files changed five times or more
- Test files versus production files in the hotspot list
- VERSION or CHANGELOG frequency as a version-discipline signal

### 8. Change-Unit Size Distribution

Estimate change-unit sizes from commit diffs and bucket them.
Use one heuristic consistently across the whole report:

1. A merge commit counts as one change unit.
2. A squash-style subject with `(#123)` or `!123` counts as one
   change unit.
3. If the history preserves neither, fall back to individual
   commits.

If the repository history does not preserve true PR boundaries,
label the results as estimated change units rather than PRs.

Bucket sizes like this:

- Small: under 100 LOC
- Medium: 100 to 500 LOC
- Large: 500 to 1500 LOC
- XL: 1500 LOC or more, flagged with file counts

### 9. Focus Score and Ship of the Week

Focus score: calculate the percentage of commits touching the
single most-changed top-level directory. Higher means more
focused work, lower means more context switching. Report it as:

```text
Focus score: 62% (app/services/)
```

Ship of the week: identify the single highest-LOC change unit in
the window and highlight:

- PR or change-unit label and title
- LOC changed
- Why it matters, inferred from commit messages and files touched

### 10. Week-over-Week Trends

If the window is 14 days or longer, split it into weekly
buckets and show trends for:

- Commits per week
- LOC per week
- Test ratio per week
- Fix ratio per week
- Session count per week

### 11. Streak Tracking

Count consecutive days with at least one commit to the remote
default branch, working backward from today in London, UK time.

```bash
TZ=Europe/London git log "${default_branch}" --format="%ad" --date=format:"%Y-%m-%d" | sort -u
```

Display the result as:

```text
Shipping streak: 47 consecutive days
```

### 12. Load History and Compare

Before saving the new snapshot, check for prior retro history.

```bash
ls -t .context/retros/*.json 2>/dev/null
```

In normal mode, load the most recent prior retro whose `window`
matches the current window. Calculate deltas for the key metrics
and include a `Trends vs Last Retro` section such as:

```text
                    Last        Now         Delta
Test ratio:         22%    →    41%         ↑19pp
Sessions:           10     →    14          ↑4
LOC/hour:           200    →    350         ↑75%
Fix ratio:          54%    →    30%         ↓24pp (improving)
Commits:            32     →    47          ↑47%
Deep sessions:      3      →    5           ↑2
```

If no same-window retro exists, skip the comparison section and
say:

```text
First retro recorded — run again next week to see trends.
```

If compare mode is active, skip `Trends vs Last Retro`
completely. Compare mode already uses the immediately prior
same-length window, so do not mix that with saved-snapshot
comparison.

### 13. Save Retro History

After computing all metrics, save a JSON snapshot.

```bash
mkdir -p .context/retros
today=$(TZ=Europe/London date +%Y-%m-%d)
existing=$(ls .context/retros/${today}-*.json 2>/dev/null | wc -l | tr -d ' ')
next=$((existing + 1))
```

Save to `.context/retros/${today}-${next}.json` using the Write
tool with this schema:

```json
{
  "date": "2026-03-08",
  "window": "7d",
  "metrics": {
    "commits": 47,
    "change_units": 12,
    "insertions": 3200,
    "deletions": 800,
    "net_loc": 2400,
    "test_loc": 1300,
    "test_ratio": 0.41,
    "active_days": 6,
    "sessions": 14,
    "deep_sessions": 5,
    "avg_session_minutes": 42,
    "loc_per_session_hour": 350,
    "feat_pct": 0.40,
    "fix_pct": 0.30,
    "peak_hour": 22
  },
  "release_markers": ["v1.16.0", "v1.16.1"],
  "streak_days": 47,
  "tweetable": "Week of Mar 1: 47 commits, 3.2k LOC, 38% tests, 12 change units, peak: 10pm"
}
```

### 14. Write the Narrative

Use this outline:

```markdown
**Tweetable summary**

Week of Mar 1: 47 commits, 3.2k LOC, 38% tests, 12 change units,
peak: 10pm | Streak: 47d

## Engineering Retro: [date range]

### Summary Table

### Trends vs Last Retro

Skip this on first run and in compare mode.

### Time and Session Patterns

Interpret productive hours, session length trends, and active
hours per day.

### Shipping Velocity

Cover commit mix, change-unit size discipline, fix chains, and
release markers when present.

### Code Quality Signals

Cover test ratio, hotspot churn, and any XL change units that
should likely have been split.

### Focus and Highlights

Cover focus score and ship of the week.

### Top 3 Wins

### 3 Things to Improve

Phrase these as "to get even better, you could..."

### 3 Habits for Next Week

Keep them small and realistic.

### Week-over-Week Trends

Include this only when the window is long enough.
```

## Compare Mode

When the user runs `/retro compare` or `/retro compare 14d`:

1. Compute metrics for the current window.
2. Compute metrics for the immediately prior same-length window
   using both `--since` and `--until` so the windows do not
   overlap.
3. Show a side-by-side comparison table with deltas and arrows.
4. Write a brief narrative highlighting the largest
   improvements and regressions.
5. Save only the current-window snapshot to `.context/retros/`.

## Tone

- Encouraging but candid
- Specific and concrete, always anchored in real commits
- Skip generic praise and say exactly what was good and why
- Frame improvements as levelling up rather than criticism
- Scale the output to the activity level. For most windows,
  aim for roughly 1200 to 2200 words, and go shorter for quiet
  periods or 24-hour retros.
- Use markdown tables and code blocks for data, prose for the
  narrative
- Output directly to the conversation, never to the filesystem,
  except for the `.context/retros/` JSON snapshot

## Important Rules

- Write all narrative output to the conversation
- The only file written is the `.context/retros/` JSON snapshot
- Use `${default_branch}` for all git queries, never the local
  branch tip
- Convert all timestamps with `TZ=Europe/London`
- If the window has zero commits, say so and suggest a
  different window
- Round LOC per hour to the nearest 50
- Use the same change-unit heuristic everywhere: merge commit
  first, then squash-style forge refs, then individual commits
- Prefer this command's workflow, but use repo docs if needed
  to interpret project-specific release markers or versioning
- On the first run, skip comparison sections gracefully
