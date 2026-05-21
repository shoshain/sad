#!/usr/bin/env node
// SAD minimal eval harness.
//
// Walks evals/**/EVAL.ts, dynamic-imports each, and invokes its exported
// evaluateSpec / evaluateImplementation / evaluateReviewerTable function
// against the matching PROMPT.md (and ground-truth.json when present).
//
// Output: green/yellow/red text by default; structured JSON with --json.
// Exit code: 0 if all pass, 1 if any fail. Concerns / stubs do not fail.
//
// Designed to run on stock Node 22+ with no third-party dependencies.
// Uses Node's --experimental-strip-types so EVAL.ts is loaded directly.

import { readdir, readFile, stat } from "node:fs/promises";
import { join, dirname, basename, relative } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const EVALS_ROOT = __dirname;
const REPO_ROOT = join(__dirname, "..");

const args = new Set(process.argv.slice(2));
const JSON_OUT = args.has("--json");
const VERBOSE = args.has("--verbose");

// --------------------------------------------------------------- discovery

async function findEvalFiles(root) {
  const out = [];
  async function walk(dir) {
    let entries;
    try {
      entries = await readdir(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) {
        if (entry.name === "node_modules" || entry.name.startsWith(".")) continue;
        await walk(full);
      } else if (entry.isFile() && entry.name === "EVAL.ts") {
        out.push(full);
      }
    }
  }
  await walk(root);
  return out.sort();
}

// ----------------------------------------------------------------- helpers

async function readIfExists(path) {
  try {
    return await readFile(path, "utf8");
  } catch {
    return null;
  }
}

function categorize(evalFilePath) {
  // evals/<suite>/<...>/case-<id>/EVAL.ts
  const rel = relative(EVALS_ROOT, evalFilePath).replace(/\\/g, "/");
  const suite = rel.split("/")[0] || "unknown";
  return suite;
}

// --------------------------------------------------------------- adapters

async function runOneEval(evalPath) {
  const caseDir = dirname(evalPath);
  const suite = categorize(evalPath);
  const caseId = relative(EVALS_ROOT, caseDir).replace(/\\/g, "/");
  const result = {
    suite,
    case: caseId,
    status: "stub",
    details: [],
  };

  let mod;
  try {
    mod = await import(pathToFileURL(evalPath).href);
  } catch (err) {
    result.status = "error";
    result.details.push(`failed to import: ${err.message}`);
    return result;
  }

  const promptPath = join(caseDir, "PROMPT.md");
  const promptText = (await readIfExists(promptPath)) || "";
  const groundTruthRaw = await readIfExists(join(caseDir, "ground-truth.json"));
  let groundTruth = null;
  if (groundTruthRaw) {
    try {
      groundTruth = JSON.parse(groundTruthRaw);
    } catch (err) {
      result.status = "error";
      result.details.push(`invalid ground-truth.json: ${err.message}`);
      return result;
    }
  }

  // Discover an exported evaluator. Convention: any named export starting with `evaluate`
  // (case-insensitive) is treated as a grader. We pick the first one we find.
  const evaluatorName = Object.keys(mod).find((k) => /^evaluate/i.test(k));
  if (!evaluatorName) {
    result.status = "skip";
    result.details.push("no exported function named evaluate*");
    return result;
  }
  const evaluator = mod[evaluatorName];
  if (typeof evaluator !== "function") {
    result.status = "skip";
    result.details.push(`export ${evaluatorName} is not a function`);
    return result;
  }

  // Build a positional argument list:
  //   arg 0 = PROMPT.md text
  //   arg 1 = ground-truth payload (whole object) — graders that ignore it just discard it
  let raw;
  try {
    raw = evaluator(promptText, groundTruth ?? {});
  } catch (err) {
    result.status = "error";
    result.details.push(`evaluator threw: ${err.message}`);
    return result;
  }

  // Interpret common shapes. Anything with `passed === true` is pass; explicit stubs
  // (passed === false AND reason starts with "stub") map to status: stub so they
  // don't fail CI.
  if (raw && typeof raw === "object") {
    if (raw.passed === true) {
      result.status = "pass";
    } else if (raw.passed === false) {
      const reason = (raw.reason ?? "").toString().toLowerCase();
      if (reason.startsWith("stub")) {
        result.status = "stub";
      } else if ((raw.scores && allZero(raw.scores)) && /stub/i.test(raw.rationale ?? "")) {
        // LLM-judge rubric stub: all zeros + "stub" in rationale → treat as stub.
        result.status = "stub";
      } else {
        result.status = "fail";
      }
    } else {
      // No explicit passed field. If the grader returns scores only, treat as stub.
      result.status = "stub";
    }
    // Collect details from common fields.
    if (Array.isArray(raw.details)) result.details.push(...raw.details);
    if (Array.isArray(raw.missing)) result.details.push(...raw.missing.map((m) => `missing: ${m}`));
    if (Array.isArray(raw.missingHeaders)) result.details.push(...raw.missingHeaders.map((m) => `missing header: ${m}`));
    if (typeof raw.reason === "string" && raw.reason.length > 0) result.details.push(raw.reason);
    if (typeof raw.rationale === "string" && raw.rationale.length > 0) result.details.push(raw.rationale);
  } else {
    result.status = "skip";
    result.details.push("evaluator returned non-object");
  }
  return result;
}

function allZero(scores) {
  if (!scores || typeof scores !== "object") return false;
  return Object.values(scores).every((v) => v === 0);
}

// ----------------------------------------------------------------- runner

function tally(results) {
  const summary = { pass: 0, fail: 0, error: 0, stub: 0, skip: 0 };
  for (const r of results) summary[r.status] = (summary[r.status] || 0) + 1;
  return summary;
}

function colorTag(status) {
  switch (status) {
    case "pass":  return "[OK]  ";
    case "fail":  return "[FAIL]";
    case "error": return "[ERR] ";
    case "stub":  return "[STUB]";
    case "skip":  return "[SKIP]";
    default:      return "[??]  ";
  }
}

async function main() {
  const evalFiles = await findEvalFiles(EVALS_ROOT);
  if (evalFiles.length === 0) {
    if (JSON_OUT) {
      process.stdout.write(JSON.stringify({ summary: { pass: 0, fail: 0, error: 0, stub: 0, skip: 0 }, cases: [] }, null, 2) + "\n");
    } else {
      console.log("No EVAL.ts files found under evals/.");
    }
    return 0;
  }

  const results = [];
  for (const evalPath of evalFiles) {
    const r = await runOneEval(evalPath);
    results.push(r);
  }
  const summary = tally(results);

  if (JSON_OUT) {
    process.stdout.write(JSON.stringify({ summary, cases: results }, null, 2) + "\n");
  } else {
    const counts = `${summary.pass} pass · ${summary.fail} fail · ${summary.error} error · ${summary.stub} stub · ${summary.skip} skip`;
    console.log(`/sad-eval-harness — ${counts}`);
    console.log("-".repeat(60));
    for (const r of results) {
      console.log(`${colorTag(r.status)} ${r.case}`);
      if (VERBOSE && r.details.length > 0) {
        for (const d of r.details) console.log(`       · ${d}`);
      }
    }
  }
  return summary.fail + summary.error > 0 ? 1 : 0;
}

main().then((code) => process.exit(code)).catch((err) => {
  console.error("eval harness crashed:", err);
  process.exit(2);
});
