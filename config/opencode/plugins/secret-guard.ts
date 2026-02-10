/**
 * Blocks reading sensitive files (.env, credentials, keys).
 */

const SENSITIVE_FILE_PATTERNS = [
  /\.env$/,
  /\.env\./,
  /secrets?\//,
  /credentials/i,
  /\.pem$/,
  /_rsa$/,
  /_ed25519$/,
];

export const SecretGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "read") return;
    const filePath = String(output.args.filePath ?? "");

    for (const pattern of SENSITIVE_FILE_PATTERNS) {
      if (pattern.test(filePath)) {
        throw new Error(
          `Refused to read sensitive file: ${filePath}. Credential and secret files must not be read by agents.`,
        );
      }
    }
  },
});
