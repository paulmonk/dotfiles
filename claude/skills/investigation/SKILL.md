---
name: investigation
description: >-
  This skill should be used when the user asks to "investigate",
  "look into", "find out why", "what caused", "root cause",
  "diagnose", "troubleshoot", "debug why", "analyze this
  failure", or "figure out what's going on with". Also triggered
  by requests to write up findings, produce an investigation
  report, or explain a data discrepancy.
user_invocable: true
---

# Investigation

Guided evidence-gathering workflow that produces a five-section
report for stakeholders. Covers data issues, system behaviour
changes, and bugs where the cause is not immediately obvious.

## Usage

Invoke with a topic or problem description:

```text
/investigation why daily revenue dropped 15% on March 1st
/investigation cost data mismatch in campaign reporting
/investigation why deploy pipeline fails on main since Monday
/investigation intermittent 502 errors on payments endpoint
```

## Arguments

`$ARGUMENTS`: topic description, error message, or problem
statement to investigate.

## Scope

- Data discrepancies (mismatched values, missing records,
  unexpected truncation)
- System behaviour changes (something worked before, now
  it doesn't)
- Bugs or failures where the cause is not obvious
- Any situation requiring evidence gathering before a fix

## When NOT to Use

- The cause is already known and only a fix is needed
  (use /fix-issue instead)
- Quick debugging where a stack trace points directly to
  the problem
- Evaluating options or exploring approaches before
  implementation (use /research instead)
- Pure code review without a diagnostic question

## Output Format

The investigation report MUST use the following structure.
Every section is mandatory. Use the exact headers shown.

```markdown
## Overview

<Concise description of what was found. State the observable
problem factually. Include specific values, dates, and
identifiers. Show "expected vs actual" comparisons where
applicable.>

## Impact

<Who or what is affected and how. Quantify where possible:
dollar amounts, row counts, percentage of users, duration
of impact. Connect the technical issue to business
consequences.>

## What is verified

<Evidence gathered and confirmed. Each point should be
independently verifiable. Reference specific files, queries,
logs, or commands used to confirm. Distinguish between
"confirmed" and "observed but not yet confirmed".>

## Suspected cause

<Root cause hypothesis based on the evidence. Explain the
mechanism: why does the observed behaviour happen? If
multiple hypotheses exist, list them ranked by likelihood.
Flag if the cause is confirmed or still a hypothesis.>

## Recommendation

<Concrete next steps. Who needs to do what. Include both
the immediate fix and any follow-up work (backfills,
monitoring, prevention). If action is needed from an
external party, state exactly what to ask them.>
```

## Workflow

### 1. Gather context

Read any files, logs, data, or documentation the user points
to. If the user describes the problem verbally, extract the
key facts: what changed, when, what's affected.

Inspect files, tail logs, check `git log` and `git blame`
for recent changes, query databases, or search the web for
error messages and known issues.

### 2. Form hypotheses

Based on initial evidence, list possible causes. Rank by
likelihood. This guides where to look next.

### 3. Verify

For each hypothesis, gather evidence to confirm or rule it
out. Use queries, file inspection, log analysis, or web
searches as needed. For regressions, `git bisect` can
pinpoint the introducing commit. Record what was checked
and what was found, including negative results (things
ruled out).

### 4. Write the report

Produce the report using the output format above. Be direct
and factual. Avoid hedging language where evidence is clear.
Use hedging only where uncertainty genuinely remains.

### 5. Review

Before presenting the report, check:

- Are all five sections present?
- Are specific values, dates, and identifiers included?
- Is the impact quantified?
- Is the suspected cause backed by the verified evidence?
- Are recommendations actionable (who does what)?

## Guidelines

- **Specificity over vagueness.** "Cost is $370-400/day on the
  wrong name since Feb 21st" beats "cost data is incorrect".
- **Show the comparison.** When something is wrong, show both
  the expected and actual values side by side.
- **Separate fact from hypothesis.** The "What is verified"
  section is fact. The "Suspected cause" section is hypothesis.
  Do not mix them.
- **Trace to the source.** Follow the data upstream until the
  point of failure is found. State clearly whether the issue
  originates in our systems or an external one.
- **Quantify impact.** Stakeholders need to know how bad it is
  to prioritise the fix. Rough numbers are better than none.
