---
name: recall
description: Search past conversation sessions via QMD. Use when the user wants to find previous sessions, recall what was discussed, or search conversation history.
user_invocable: true
argument-hint: "[query]"
allowed-tools: mcp__qmd__vsearch, mcp__qmd__search, mcp__qmd__get
disable-model-invocation: true
---

# /recall - Search Past Sessions

Search conversation summaries from Claude Code and Codex sessions
stored in the Obsidian vault.

## When to Use

- User asks to recall, find, or search past sessions.
- User wants to know what was discussed previously.
- Looking up context from earlier conversations.

## When NOT to Use

- Searching for general knowledge (use web search).
- Looking for code in the current project (use grep/fd).
- Reading QMD documents outside of session history.

## Usage

```text
/recall                    # Recent sessions for current project
/recall authentication     # Search for auth-related sessions
/recall dbt pipeline fix   # Search for dbt pipeline discussions
```

## Workflow

### With a query argument

Perform a semantic search across all past sessions:

1. Use `mcp__qmd__vsearch` with the query, filtering to
   collection `obsidian`, limit 10.
2. Filter results to paths containing `3-Claude-Sessions/`
   or `3-Codex-Sessions/`.
3. If fewer than 3 results, also run `mcp__qmd__search`
   with the same query and collection filter as a fallback.
4. Present results as a concise list: date, project, and
   one-line summary for each match.

### Without a query argument

Show recent sessions for the current project:

1. Determine the project name from the current working
   directory basename.
2. Use `mcp__qmd__search` with the project name as query,
   filtering to collection `obsidian`, limit 5.
3. Filter results to paths containing `3-Claude-Sessions/`
   or `3-Codex-Sessions/`.
4. Present results sorted by date (newest first).

If no results are found, suggest broadening the query or
checking `qmd status` to verify the collection is indexed.

## Output format

```markdown
# Recent Sessions

- (2026-03-01) **project-name** - Brief summary of what was discussed
- (2026-02-28) **project-name** - Another session summary
```

## Notes

- Sessions are markdown files with YAML frontmatter containing
  `date`, `project`, `session_id`, `agent` (claude or codex),
  and `type: conversation`.
- Use `mcp__qmd__get` to read the full content of a session
  if the user wants more detail.
