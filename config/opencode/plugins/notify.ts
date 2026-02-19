/**
 * Sends a desktop notification when the session goes idle.
 *
 * Handles OpenCode notifications directly to keep plugin behavior
 * local to the OpenCode configuration.
 */

import { spawn } from "node:child_process";

export const Notify = async (_ctx: {
  project: unknown;
  client: unknown;
  $: (strings: TemplateStringsArray, ...values: unknown[]) => Promise<unknown>;
  directory: string;
  worktree: string;
}) => ({
  event: async ({ event }: { event: { type: string; [key: string]: unknown } }) => {
    if (event.type === "session.idle") {
      const project = process.cwd().split("/").filter(Boolean).at(-1) ?? "";
      const args = [
        "-title",
        "OpenCode",
        "-message",
        "Task completed",
        "-group",
        "opencode",
        "-ignoreDnD",
      ];
      if (project) {
        args.push("-subtitle", project);
      }

      try {
        await new Promise<void>((resolve, reject) => {
          const proc = spawn("terminal-notifier", args, { stdio: "ignore" });
          proc.on("close", (code) =>
            code === 0 ? resolve() : reject(new Error(`exit ${code}`)),
          );
          proc.on("error", reject);
        });
      } catch (err) {
        console.error("[notify] terminal-notifier failed:", err);
      }
    }
  },
});
