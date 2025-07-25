# Claude Command: Optimize

This command helps you optimize your code to ensure it aligns with our coding standards and best practices.

## Usage

To optimize your code, just type:
```
/optimize
```

## What This Command Does

This command runs a series of checks to ensure your code aligns with our coding standards and best practices.
These should be configured in the `CLAUDE.md` file for the project, explaining the convetions and how to run the the
checks.

## How to Use

Follow these steps:
1. Run the lint/fix checks configured in the `CLAUDE.md` file for the project.
2. Review the code which has been changed in the current context.
3. Analyze the code and suggest improvements (if any) to align with the coding standards and best practices.
   Consider what packages we have installed and the stdlib. Are we using them most effectively?
   Have we sufficiently tested the code?
4. Suggest improvements to the code which could be made.
5. Once accepted make the confirmed improvements.
6. Finally fix any linting/typing issues.
