/**
 * Rejects grep commands and suggests rg, ast-grep, or semgrep.
 */

const GREP_PATTERN = /(^|[;&|]\s*)grep(\s|$)/;

export const GrepGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "bash") return;
    const command = String(output.args.command ?? "");

    if (GREP_PATTERN.test(command)) {
      throw new Error(
        "Use rg (ripgrep) instead of grep. For AST-aware searches use ast-grep, for semantic analysis use semgrep.",
      );
    }
  },
});
