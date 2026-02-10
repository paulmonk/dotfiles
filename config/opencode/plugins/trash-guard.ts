/**
 * Rejects rm commands and suggests trash for safer file deletion.
 */

const RM_PATTERN = /(^|[;&|]\s*)rm(\s|$)/;

export const TrashGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "bash") return;
    const command = String(output.args.command ?? "");

    if (RM_PATTERN.test(command)) {
      throw new Error(
        "Use trash instead of rm. The trash command moves files to the system trash where they can be recovered.",
      );
    }
  },
});
