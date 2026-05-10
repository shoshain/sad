/**
 * SAD eval stub — stakeholder semi-technical case 001.
 *
 * Purpose: verify that walkthroughs/semi-technical.md references every changed
 * contract with a backward-compatibility verdict.
 */

export type EvalResult = { passed: boolean; missing: string[] };

export function evaluateContractCoverage(
  walkthroughMarkdown: string,
  changedContracts: string[],
): EvalResult {
  const missing = changedContracts.filter((c) => !walkthroughMarkdown.includes(c));
  return { passed: missing.length === 0, missing };
}
