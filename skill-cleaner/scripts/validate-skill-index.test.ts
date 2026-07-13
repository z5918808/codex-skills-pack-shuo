import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { run } from "./validate-skill-index.ts";

const script = path.join(path.dirname(process.argv[1] ?? ""), "validate-skill-index.ts");

test("--root validates the requested skill tree", () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), "skill-index-root-"));
  const skill = path.join(root, "too-long");
  fs.mkdirSync(skill, { recursive: true });
  fs.writeFileSync(
    path.join(skill, "SKILL.md"),
    `---\nname: too-long\ndescription: ${"x".repeat(121)}\n---\n`,
    "utf8",
  );

  const result = run([process.execPath, script, "--root", root]);

  assert.equal(result.exitCode, 1);
  assert.match(result.stderr, /too-long: description is 121 chars/);
});
