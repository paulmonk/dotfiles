---
name: create-issue
description: Use when creating a new issue in the project's issue tracker (beads, Jira, Linear, or GitHub)
allowed-tools: Read,Glob,Bash(bd *),mcp__github__*,mcp__atlassian__*,mcp__linear__*
argument-hint: The type of issue to create (task, bug, story, spike, epic) and the title of the issue
disable-model-invocation: true
---

# Create Issue

Create an issue in whatever tracker the project uses, optionally
using templates for structured descriptions.

## Usage

```text
/create-issue [type] [title]
```

## Workflow

### 1. Detect Tracker

Check in order:

| Indicator                        | Tracker | Action              |
| -------------------------------- | ------- | ------------------- |
| `.bd` directory or `.bd.json`    | beads   | Use `bd create`     |
| User provides project key        | Jira    | Use Atlassian MCP   |
| User provides team               | Linear  | Use Linear MCP      |
| Git remote is GitHub             | GitHub  | Use `gh issue create` |
| None detected                    | -       | Draft content only  |

### 2. Check for Templates (Optional)

- Look for templates:
  `claude/skills/create-issue/templates/{type}.md` or
  `.github/ISSUE_TEMPLATE/`
- If found, ask user if they want to use it
- If not found or declined, use freeform description

### 3. Gather Info

- Title (if not provided)
- Type/labels (task, bug, story, spike, epic)
- Priority (if tracker supports it)
- Description (templated or freeform)

### 4. Create Issue

Create in detected tracker using the appropriate command

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
