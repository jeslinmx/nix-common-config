import { tool } from "@opencode-ai/plugin";

export const calculate = tool({
  description:
    "Evaluate mathematical calculations and unit conversions using qalc. Supports arithmetic, algebra, calculus, unit conversions (e.g. '6 feet to cm'), currency conversion, physical constants, and more.",
  args: {
    expr: tool.schema
      .string()
      .describe("The mathematical expression or unit conversion to evaluate"),
  },
  async execute(args) {
    try {
      return (await Bun.$`qalc --exrates ${args.expr}`.text()).trim();
    } catch (e: any) {
      // qalc writes error messages to stdout and exits non-zero;
      // rethrow if this isn't a qalc error (e.g. binary not found)
      if (!e.stdout?.length) throw e;
      return e.stdout.toString().trim();
    }
  },
});
