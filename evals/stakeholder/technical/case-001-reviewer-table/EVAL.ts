/**
 * SAD eval stub — stakeholder technical case 001.
 *
 * Purpose: deterministic check that walkthroughs/technical.md contains a
 * reviewer rollup table referencing required reviewer rows.
 */

export type EvalResult = {
  passed: boolean;
  missingHeaders: string[];
  reason?: string;
};

export function evaluateReviewerTable(
  walkthroughMarkdown: string,
  requiredHeadersOrGroundTruth: string[] | Record<string, unknown>,
): EvalResult {
  // The harness invokes every grader as `evaluator(promptText, groundTruth ?? {})`.
  // Accept either a bare string[] (direct unit-test invocation) or a ground-truth
  // object exposing `required_headers` (harness invocation). When the walkthrough
  // text supplied by the harness is the case's own PROMPT.md (i.e. no real
  // walkthroughs/technical.md fixture is wired), return a stub result so CI does
  // not flag a "fail" for a fixture that simply has not been wired yet. A real
  // run supplies a real walkthrough body and the grader runs normally.
  let requiredHeaders: string[] | null = null;
  if (Array.isArray(requiredHeadersOrGroundTruth)) {
    requiredHeaders = requiredHeadersOrGroundTruth;
  } else if (requiredHeadersOrGroundTruth && typeof requiredHeadersOrGroundTruth === "object") {
    const gt = requiredHeadersOrGroundTruth as Record<string, unknown>;
    const candidate = (gt.required_headers ?? gt.requiredHeaders) as unknown;
    if (Array.isArray(candidate)) {
      requiredHeaders = candidate as string[];
    }
  }
  // Heuristic for "no real walkthrough fixture": a markdown walkthrough always
  // contains at least one `|` table delimiter (the reviewer-rollup table). The
  // case PROMPT.md does not.
  const looksLikeRealWalkthrough = walkthroughMarkdown.includes("|");
  if (!requiredHeaders || !looksLikeRealWalkthrough) {
    return {
      passed: false,
      missingHeaders: [],
      reason: "stub: no walkthroughs/technical.md fixture wired (PROMPT.md is the case instructions)",
    };
  }
  const missingHeaders = requiredHeaders.filter(
    (h) => !walkthroughMarkdown.toLowerCase().includes(h.toLowerCase()),
  );
  return { passed: missingHeaders.length === 0, missingHeaders };
}
