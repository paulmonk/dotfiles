/**
 * Requires a cost cap on bq query commands.
 */

const BQ_QUERY_PATTERN = /(^|[;&|]\s*)bq\s+.*\bquery\b/;
const BQ_BYTES_BILLED_PATTERN = /--maximum_bytes_billed[= ]+(\d+)/;

const BYTES_PER_GIB = 1_073_741_824;
const LIMIT_GIB = 10;
const LIMIT_BYTES = LIMIT_GIB * BYTES_PER_GIB;

export const BqGuard = async () => ({
  "tool.execute.before": async (
    input: { tool: string },
    output: { args: Record<string, unknown> },
  ) => {
    if (input.tool !== "bash") return;
    const command = String(output.args.command ?? "");

    if (!BQ_QUERY_PATTERN.test(command)) return;

    const match = command.match(BQ_BYTES_BILLED_PATTERN);
    if (!match) {
      throw new Error(
        `bq query requires a cost cap. Add --maximum_bytes_billed=${LIMIT_BYTES} (${LIMIT_GIB} GiB limit).`,
      );
    }
    const billed = parseInt(match[1], 10);
    if (billed > LIMIT_BYTES) {
      throw new Error(
        `maximum_bytes_billed=${billed} exceeds the ${LIMIT_GIB} GiB limit. Use --maximum_bytes_billed=${LIMIT_BYTES} or lower.`,
      );
    }
  },
});
