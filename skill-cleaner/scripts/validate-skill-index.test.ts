import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import test from "node:test";

const script = fileURLToPath(new URL("./validate-skill-index.ts", import.meta.url));

test("--root validates repository index instead of personal skills", (t) => {
  const fixture = fs.mkdtempSync(path.join(os.tmpdir(), "skill-index-fixture-"));
  const skillDir = path.join(fixture, "sample");
  fs.mkdirSync(skillDir);
  const skillFile = path.join(skillDir, "SKILL.md");
  fs.writeFileSync(skillFile, "---\nname: sample\ndescription: Sample skill\n---\n");
  const readme = path.join(fixture, "README.md");
  t.after(() => {
    fs.unlinkSync(skillFile);
    fs.unlinkSync(readme);
    fs.rmdirSync(skillDir);
    fs.rmdirSync(fixture);
  });
  const run = () => spawnSync(process.execPath, ["--experimental-strip-types", script, "--root", fixture], { encoding: "utf8" });

  fs.writeFileSync(readme, "收錄 **1 個通用 skills**\n[`sample`](./sample/)\n");
  assert.equal(run().status, 0);

  fs.writeFileSync(readme, "收錄 **1 個通用 skills**\n");
  const missingLink = run();
  assert.equal(missingLink.status, 1);
  assert.match(missingLink.stderr, /sample: missing README index link/);

  fs.writeFileSync(readme, "收錄 **1 個通用 skills**\n[`sample`](./sample/)\n");
  fs.writeFileSync(skillFile, "---\ndescription: Sample skill\n---\n");
  const missingName = run();
  assert.equal(missingName.status, 1);
  assert.match(missingName.stderr, /sample: expected exactly 1 frontmatter name/);
});
