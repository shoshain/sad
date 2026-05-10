/**
 * SAD eval stub — spec-conformance case 001.
 *
 * Purpose: deterministic check that feature.spec.md contains capabilities (C*)
 * and matching EARS acceptance criteria (AC*) per SAD discipline.
 *
 * Replace this stub with a real runner (Vercel agent-eval, vitest, jest, etc.).
 * Keep grading hidden from the agent during generation per agent-eval guidance.
 */

export type EvalResult = {
  passed: boolean;
  details: string[];
};

export function evaluateSpec(specMarkdown: string): EvalResult {
  const details: string[] = [];
  const capabilities = Array.from(specMarkdown.matchAll(/^- C(\d+)\./gm)).map(
    (m) => Number(m[1]),
  );
  const acceptanceTopLevels = new Set(
    Array.from(specMarkdown.matchAll(/^- AC(\d+)\./gm)).map((m) => Number(m[1])),
  );

  if (capabilities.length === 0) {
    details.push("No capabilities (C*) found in spec.");
  }
  for (const c of capabilities) {
    if (!acceptanceTopLevels.has(c)) {
      details.push(`Capability C${c} has no matching AC${c}.* acceptance criterion.`);
    }
  }

  return { passed: details.length === 0, details };
}
