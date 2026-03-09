---
name: investigation
description: >-
  This skill should be used when the cause of a problem is
  unknown and evidence gathering is needed before a fix.
  Triggered by phrases like "why did X break", "something
  stopped working", "find the root cause", "investigate why",
  "diagnose this issue". Symptoms include data discrepancies,
  unexpected behaviour changes, intermittent failures,
  regressions, dropped metrics, mismatched values, and missing
  records. Produces a five-section diagnostic report.
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
/investigation test suite started flaking after dependency upgrade
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

### Context preservation

Use the **Scout agent** (via the Agent tool with
`subagent_type: scout`) for all codebase exploration, file
reading, log tailing, and search operations. This keeps the
heavy output out of the main context window.

Dispatch Scout with a clear, specific question. Scout returns
a concise summary. Synthesise those summaries here rather than
reading raw files yourself.

Reserve direct tool use in the main context for:

- Writing the final report
- Small, targeted reads (a single config value, a short diff)
- Web searches (exa, deepwiki, context7) that Scout cannot do
- Interactive clarification with the user

### 1. Gather context

Extract the key facts from the user's description: what
changed, when, what's affected.

Dispatch Scout subagents (in parallel where independent) to:

- Read files, logs, or documentation the user points to
- Check `git log` and `git blame` for recent changes
- Search the codebase for related code and configuration
- Find error messages or patterns in logs

If the problem involves external data, use web search tools
(exa, deepwiki) directly since Scout cannot access them.

### 2. Form hypotheses

Based on Scout's findings, list possible causes. Rank by
likelihood. This guides where to look next.

### 3. Verify

For each hypothesis, dispatch Scout to gather evidence that
confirms or rules it out. Use parallel Scout calls when
checking independent hypotheses.

For regressions, ask Scout to run `git bisect` or inspect
commit history to pinpoint the introducing change.

Record what was checked and what was found, including
negative results (things ruled out).

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

## Common Mistakes

- **Jumping to a fix before understanding the cause.** If the
  cause is already known, use /fix-issue instead. This skill
  is for when you need to find the cause first.
- **Mixing fact and hypothesis.** "What is verified" must be
  independently confirmable. If you're guessing, it goes in
  "Suspected cause".
- **Reading entire files in main context.** Delegate to Scout.
  You only need the summary to write the report.
- **Sequential hypothesis checking.** If hypotheses are
  independent, dispatch parallel Scout calls. Don't wait for
  one to finish before starting the next.
- **Vague impact.** "Some users are affected" is not useful.
  Quantify: how many, how much, since when.
