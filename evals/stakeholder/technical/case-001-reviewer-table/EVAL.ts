/**
 * SAD eval stub — stakeholder technical case 001.
 *
 * Purpose: deterministic check that walkthroughs/technical.md contains a
 * reviewer rollup table referencing required reviewer rows.
 */

export type EvalResult = { passed: boolean; missingHeaders: string[] };

export function evaluateReviewerTable(
  walkthroughMarkdown: string,
  requiredHeaders: string[],
): EvalResult {
  const missingHeaders = requiredHeaders.filter(
    (h) => !walkthroughMarkdown.toLowerCase().includes(h.toLowerCase()),
  );
  return { passed: missingHeaders.length === 0, missingHeaders };
}
