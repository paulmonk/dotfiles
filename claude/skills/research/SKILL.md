---
name: research
description: >-
  This skill should be used when the user asks to "research",
  "spike", "evaluate options", "compare approaches", "assess
  feasibility", "explore whether", "find out if we can",
  "pros and cons of", or "what's the best way to". Also
  triggered by requests to produce a spike report, write up
  research findings, or answer a technical question that
  requires exploration before implementation.
user_invocable: true
---

# Research

Structured workflow for time-boxed research spikes. Produces
a report that answers a specific question, documents what was
explored, and gives actionable recommendations so the team
can make a decision.

## Usage

Invoke with the question or topic to research:

```text
/research best approach for real-time notifications
/research compare Redis vs DragonflyDB for our caching layer
/research feasibility of migrating auth to Clerk
What's the best way to support multi-tenancy?
```

## Arguments

`$ARGUMENTS`: the question to answer, topic to explore, or
decision to inform.

## Scope

- Evaluating libraries, tools, vendors, or approaches
- Feasibility assessments before committing to implementation
- Comparing options with trade-offs (cost, performance,
  complexity, maintenance)
- Answering "can we?" or "should we?" questions
- Time-boxed exploration to reduce uncertainty

## When NOT to Use

- The problem is already diagnosed and needs a fix
  (use /fix-issue instead)
- Diagnosing a live issue or data discrepancy
  (use /investigation instead)
- The decision is already made and implementation is needed

## Output Format

The research report MUST use the following structure. Sections
marked (optional) may be omitted when not applicable. All
other sections are mandatory.

```markdown
## Goal

<State in 2-3 sentences what question(s) this spike answers
and why they matter to the product or team. Frame as a
question where possible: "Can we...?", "Should we...?",
"What is the best way to...?">

## Approach

<List what was actually done to answer the question:>
- Research activities (docs read, APIs reviewed, vendors
  compared)
- Experiments or prototypes built
- People or teams consulted

## Evidence

<Summarise what was discovered:>
- Key data points, constraints, and metrics
- Links to code, prototypes, diagrams, or notes
- Anything that disproved an assumption
- Constraints discovered (rate limits, licensing, cost
  ceilings, compatibility issues)

## Outcomes

<State what is now known that was not known before:>
- Which options are viable and which are ruled out
- Key trade-offs between viable options
- Unknowns that remain unresolved

## Recommendations

<Give actionable next steps:>
- Decisions recommended (e.g. "proceed with option B,
  de-scope X")
- Follow-up work needed (including further spikes, if any)
- Risks that the team should accept or mitigate

## Artifacts (optional)

<List and link anything produced:>
- Code location (branch, directory, prototype)
- Diagrams or design documents
- Test data or scripts
```

## Workflow

### 1. Define the question

Extract the core question from the user's request. A good
spike question is specific and answerable: "Which queue
system fits our throughput and latency requirements?" not
"research queues".

If the question is too broad, break it into sub-questions
and address each.

### 2. Research

Gather evidence to answer the question. Prioritise official
documentation and primary sources over blog posts. Use web
searches, library docs, API references, and the existing
codebase as needed.

For comparisons, establish evaluation criteria up front
(cost, performance, complexity, maintenance burden,
community health) so findings are structured, not ad hoc.

This is a time-boxed spike, not exhaustive research. Focus
on answering the core question. Note unexplored unknowns in
the Outcomes section so the team knows the limits of the
findings.

### 3. Synthesise

Separate raw findings from conclusions. The "Evidence"
section records what was found. The "Outcomes" section
states what that evidence means. The "Recommendations"
section says what to do about it.

### 4. Write the report

Produce the report using the output format above. Be
direct about trade-offs. If one option is clearly better,
say so. If the answer is "it depends", specify on what.

### 5. Review

Before presenting the report, check:

- Does the Goal clearly state the question being answered?
- Is every recommendation backed by evidence in the report?
- Are trade-offs stated, not hidden?
- Are remaining unknowns called out in Outcomes?
- Could a reader make a decision from this report alone?

## Guidelines

- **Answer the question.** The report exists to inform a
  decision. If the question was "should we use X?", the
  report must end with a clear yes, no, or "it depends on Y".
- **Document the evidence.** Link to docs, benchmarks, or
  code that support conclusions. Reproducible evidence beats
  opinion.
- **State trade-offs explicitly.** Every option has downsides.
  Hiding them erodes trust and leads to surprises later.
- **Flag what was not checked.** Time-boxed research means
  some questions remain open. State them clearly so the team
  knows the limits of the findings.
- **Keep it skimmable.** Stakeholders will read the Goal,
  skip to Recommendations, and only read Evidence if they
  need convincing. Structure accordingly.
