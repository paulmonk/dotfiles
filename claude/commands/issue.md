# Claude Command: Issue

This command helps you analyze and fix GitHub issues.

## Usage

To analyze and fix an issue, just type:
```
/issue <ISSUE_NUMBER>
```

## What This Command Does

This command fetches the issue details using GitHub CLI, then analyzes the issue and fixes it.

## How to Use

Analyze and fix the GitHub issue: $ARGUMENTS.

Follow these steps:
1. Use `gh issue view` to get the issue details.
2. Understand the problem described in the issue.
3. Search the codebase for relevant files.
4. Implement the necessary changes to fix the issue.
5. Ensure the code passes linting and type checking.
6. Create a descriptive commit message.
7. Push and create a PR.

Remember to use the GitHub CLI ('gh') for all Github-related tasks.
