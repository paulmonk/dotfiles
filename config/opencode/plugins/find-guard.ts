/**
 * Rejects find commands and suggests fd.
 */

const FIND_PATTERN = /(^|[;&|]\s*)find(\s|$)/;

export const FindGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "bash") return;
    const command = String(output.args.command ?? "");

    if (FIND_PATTERN.test(command)) {
      throw new Error(
        "Use fd instead of find. fd is faster, respects .gitignore, and has simpler syntax.",
      );
    }
  },
});
