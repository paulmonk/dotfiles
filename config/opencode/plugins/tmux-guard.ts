/**
 * Blocks background bash commands and task agents when not running inside a tmux session.
 *
 * Background tasks detach from the agent's process tree, making their
 * output unrecoverable if the terminal closes. Tmux provides session
 * persistence.
 */

export const TmuxGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "bash" && input.tool !== "task") return;
    if (!output.args.run_in_background) return;

    if (!process.env.TMUX) {
      throw new Error(
        "Background tasks require a tmux session. Start tmux first, then retry.",
      );
    }
  },
});
