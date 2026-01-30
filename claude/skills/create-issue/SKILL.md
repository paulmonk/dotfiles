---
name: create-issue
description: Use when creating a new issue in the project's issue tracker (beads, Jira, Linear, or GitHub)
allowed-tools: Read,Glob,Bash(bd *),mcp__github__*,mcp__atlassian__*,mcp__linear__*
argument-hint: The type of issue to create (task, bug, story, spike, epic) and the title of the issue
disable-model-invocation: true
---

# Create Issue

Create an issue in whatever tracker the project uses, optionally using templates for structured descriptions.

## Usage

```
/create-issue [type] [title]
```

## Workflow

1. **Detect tracker** (in order):

- beads: `.bd` directory or `.bd.json` exists → use `bd create`
- Jira: Ask user for project key → use Atlassian MCP
- Linear: Ask user for team → use Linear MCP
- GitHub: Git remote is GitHub → use `gh issue create`
- None: Just help draft the issue content

2. **Check for templates** (optional):

- Look for templates relative to this skill: `claude/skills/create-issue/templates/{type}.md` or `.github/ISSUE_TEMPLATE/`
- If found, ask user if they want to use it
- If not found or declined, freeform description

3. **Gather info**:

- Title (if not provided)
- Type/labels (task, bug, story, spike, epic)
- Priority (if tracker supports it)
- Description (templated or freeform)

4. **Create issue** in detected tracker

## Tracker Commands

| Tracker | Create Command                                                |
| ------- | ------------------------------------------------------------- |
| beads   | `bd create "Title" --type {type} --priority {n}`              |
| GitHub  | `gh issue create --title "Title" --body "..." --label {type}` |
| Jira    | Atlassian MCP `createJiraIssue`                               |
| Linear  | Linear MCP (if available)                                     |

## Templates (Optional)

Templates are located at `claude/skills/create-issue/templates/`:

- `task.md` - Small pieces of work
- `bug.md` - Defects with repro steps
- `story.md` - User stories (As a.../I want.../So that...)
- `spike.md` - Research/discovery with timebox
- `epic.md` - Large initiatives with OKRs

**Skip templates** if user just wants a quick issue or no templates exist.

## Priority Mapping

| Level    | beads | Jira    | Linear | GitHub              |
| -------- | ----- | ------- | ------ | ------------------- |
| Critical | 1     | Highest | Urgent | label:critical      |
| High     | 2     | High    | High   | label:high-priority |
| Normal   | 3     | Medium  | Medium | (default)           |
| Low      | 4     | Low     | Low    | label:low-priority  |
