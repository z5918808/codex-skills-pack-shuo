import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const fixture = fs.mkdtempSync(path.join(os.tmpdir(), "skill-roots-fixture-"));
const script = fileURLToPath(new URL("./skill-cleaner.ts", import.meta.url));
const env = { ...process.env, USERPROFILE: fixture, HOME: fixture };
const run = (args) => spawnSync(process.execPath, ["--experimental-strip-types", script, ...args], {
  cwd: fixture, env, encoding: "utf8", timeout: 10000,
});
const parseJson = (result) => {
  assert.equal(result.status, 0, result.stderr);
  return JSON.parse(result.stdout);
};
const section = (report, title) => {
  const start = report.indexOf(`## ${title}`);
  assert.notEqual(start, -1, `Missing report section: ${title}`);
  const end = report.indexOf("\n## ", start + 4);
  return report.slice(start, end < 0 ? report.length : end);
};
const assertFixtureContained = () => {
  const tempRoot = fs.realpathSync(os.tmpdir());
  const fixtureRoot = fs.realpathSync(fixture);
  const relative = path.relative(tempRoot, fixtureRoot);
  assert.ok(
    relative && relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative),
    `Fixture escaped temp root: ${fixtureRoot}`,
  );
};
try {
  for (const [root, name] of [[".codex/skills", "direct-fixture"], [".agents/skills", "personal-fixture"]]) {
    const dir = path.join(fixture, root, name);
    fs.mkdirSync(dir, { recursive: true });
    const description = name === "direct-fixture"
      ? "Fixture product/action/trigger description deliberately long enough to appear in the analyzer description-candidate section for manual review."
      : "Fixture skill";
    fs.writeFileSync(path.join(dir, "SKILL.md"), `---\nname: ${name}\ndescription: ${description}\n---\n\nFixture body.\n`);
  }
  const noLogs = parseJson(run(["--no-logs", "--json"]));
  assert.deepEqual(noLogs.skills.map(s => s.name).sort(), ["direct-fixture", "personal-fixture"]);
  assert.equal(noLogs.logFiles.length, 0);
  assert.equal(noLogs.usageCheck, "not_checked");

  const noLogsTextResult = run(["--no-logs"]);
  assert.equal(noLogsTextResult.status, 0, noLogsTextResult.stderr);
  assert.match(noLogsTextResult.stdout, /usage_check: not_checked/);
  assert.match(section(noLogsTextResult.stdout, "Unused Candidates"), /- none/);
  assert.match(noLogsTextResult.stdout, /manual review:/);
  assert.doesNotMatch(noLogsTextResult.stdout, /suggested:/i);

  const noFiles = parseJson(run(["--json"]));
  assert.equal(noFiles.logFiles.length, 0);
  assert.equal(noFiles.usageCheck, "not_checked");

  const history = path.join(fixture, ".codex", "history.jsonl");
  fs.mkdirSync(path.dirname(history), { recursive: true });
  fs.writeFileSync(history, JSON.stringify({ prompt: "Use $direct-fixture for this fixture." }) + "\n");
  const withUsage = parseJson(run(["--json"]));
  assert.equal(withUsage.usageCheck, "checked");
  assert.deepEqual(withUsage.logFiles, [history]);
  assert.ok(withUsage.usage["direct-fixture"].dollar > 0);
  assert.equal(withUsage.usage["personal-fixture"].dollar, 0);
  assert.equal(withUsage.usage["personal-fixture"].fileRead, 0);
  assert.equal(withUsage.usage["personal-fixture"].text, 0);

  const withUsageTextResult = run([]);
  assert.equal(withUsageTextResult.status, 0, withUsageTextResult.stderr);
  const unused = section(withUsageTextResult.stdout, "Unused Candidates");
  assert.match(unused, /personal-fixture/);
  assert.doesNotMatch(unused, /direct-fixture/);
  console.log("PASS: roots, no-log status, manual review, and evidence-based usage reporting verified.");
} finally {
  assertFixtureContained();
  fs.rmSync(fixture, { recursive: true, force: true });
}
