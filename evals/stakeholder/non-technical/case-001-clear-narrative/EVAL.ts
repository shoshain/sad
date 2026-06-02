/**
 * SAD eval stub — stakeholder non-technical case 001.
 *
 * Purpose: SME-calibrated LLM-judge with rubric for narrative clarity dimensions
 * (plain_language, scenario_coverage, decision_alternatives). This stub returns
 * shape only; wire to your LLM-judge runtime for real scoring.
 */

export type RubricScores = {
  plain_language: number;
  scenario_coverage: number;
  decision_alternatives: number;
};

export type EvalResult = {
  scores: RubricScores;
  rationale: string;
  passed: boolean;
};

export function evaluateNonTechnicalWalkthrough(
  _walkthroughMarkdown: string,
): EvalResult {
  // TODO: invoke your LLM judge with rubric loaded from ground-truth.json.
  return {
    scores: { plain_language: 0, scenario_coverage: 0, decision_alternatives: 0 },
    rationale: "Stub: connect LLM judge.",
    passed: false,
  };
}
