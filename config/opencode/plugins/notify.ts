/**
 * Sends a desktop notification when the session goes idle.
 *
 * Delegates to the shared agent-notify script which handles
 * notifications for all coding agents. Payload is passed via
 * stdin to avoid shell metacharacter issues with JSON in argv.
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
      const payload = JSON.stringify({ type: "session.idle", cwd: process.cwd() });
      try {
        await new Promise<void>((resolve, reject) => {
          const proc = spawn("agent-notify", [payload], { stdio: "ignore" });
          proc.on("close", (code) =>
            code === 0 ? resolve() : reject(new Error(`exit ${code}`)),
          );
          proc.on("error", reject);
        });
      } catch (err) {
        console.error("[notify] agent-notify failed:", err);
      }
    }
  },
});
