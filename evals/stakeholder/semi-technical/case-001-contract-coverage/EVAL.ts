/**
 * SAD eval stub — stakeholder semi-technical case 001.
 *
 * Purpose: verify that walkthroughs/semi-technical.md references every changed
 * contract with a backward-compatibility verdict.
 */

export type EvalResult = {
  passed: boolean;
  missing: string[];
  reason?: string;
};

export function evaluateContractCoverage(
  walkthroughMarkdown: string,
  changedContractsOrGroundTruth: string[] | Record<string, unknown>,
): EvalResult {
  // The harness invokes every grader as `evaluator(promptText, groundTruth ?? {})`.
  // Accept either a bare string[] (direct unit-test invocation) or a ground-truth
  // object with a `changed_contracts` key (harness invocation). When neither
  // shape provides an array — as is the case today with the stub ground-truth
  // that ships in this case folder — return a stub result so CI does not flag
  // a "fail" for a fixture that simply has not been wired yet.
  let changedContracts: string[] | null = null;
  if (Array.isArray(changedContractsOrGroundTruth)) {
    changedContracts = changedContractsOrGroundTruth;
  } else if (changedContractsOrGroundTruth && typeof changedContractsOrGroundTruth === "object") {
    const gt = changedContractsOrGroundTruth as Record<string, unknown>;
    const candidate = (gt.changed_contracts ?? gt.changedContracts) as unknown;
    if (Array.isArray(candidate)) {
      changedContracts = candidate as string[];
    }
  }
  if (!changedContracts) {
    return {
      passed: false,
      missing: [],
      reason: "stub: ground-truth.json does not yet supply a changed_contracts array",
    };
  }
  const missing = changedContracts.filter((c) => !walkthroughMarkdown.includes(c));
  return { passed: missing.length === 0, missing };
}
