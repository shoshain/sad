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
  const capabilities = new Set(
    Array.from(specMarkdown.matchAll(/^- C(\d+)\./gm)).map((m) => Number(m[1])),
  );
  // AC rows must have a sub-number: AC<n>.<m>. AC1 without a sub-number is malformed.
  const acceptanceMatches = Array.from(
    specMarkdown.matchAll(/^- AC(\d+)\.(\d+)/gm),
  ).map((m) => ({ top: Number(m[1]), sub: Number(m[2]) }));
  const acceptanceTopLevels = new Set(acceptanceMatches.map((a) => a.top));
  // Detect malformed AC rows: starts with "- AC<n>." but missing a numeric sub-id.
  const malformedAc = Array.from(
    specMarkdown.matchAll(/^- AC(\d+)(?!\.\d)/gm),
  ).map((m) => Number(m[1]));

  if (capabilities.size === 0) {
    details.push("No capabilities (C*) found in spec.");
  }
  for (const c of capabilities) {
    if (!acceptanceTopLevels.has(c)) {
      details.push(`Capability C${c} has no matching AC${c}.* acceptance criterion.`);
    }
  }
  for (const top of acceptanceTopLevels) {
    if (!capabilities.has(top)) {
      details.push(`Orphan AC${top}.* acceptance criterion: no matching capability C${top}.`);
    }
  }
  for (const top of malformedAc) {
    details.push(`Malformed acceptance criterion AC${top} (missing .<sub-id>).`);
  }

  return { passed: details.length === 0, details };
}
