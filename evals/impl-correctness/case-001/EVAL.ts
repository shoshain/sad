/**
 * SAD eval stub — impl-correctness case 001.
 *
 * Purpose: hidden behavioral test stub. Real cases should keep authoritative
 * answers under a hidden directory (per vercel-labs/agent-eval guidance) and
 * load them only at grading time, never during agent generation.
 */

export type EvalResult = { passed: boolean; reason?: string };

export function evaluateImplementation(
  _candidate: unknown,
): EvalResult {
  return { passed: false, reason: "Stub: implement behavioral checks." };
}
