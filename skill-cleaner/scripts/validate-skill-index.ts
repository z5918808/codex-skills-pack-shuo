#!/usr/bin/env -S node --experimental-strip-types
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

type SkillFrontmatter = {
  name: string;
  description: string;
  path: string;
  descriptionCount: number;
};

const home = os.homedir();
const personalCodexRoot = path.join(home, ".codex", "skills");
const roots = [
  { path: personalCodexRoot, enforceDescriptionLimit: true },
  { path: path.join(home, ".agents", "skills"), enforceDescriptionLimit: false },
  { path: path.join(home, ".codex", "plugins", "cache"), enforceDescriptionLimit: false },
];
const aliasesPath = path.join(path.dirname(process.argv[1] ?? ""), "required-trigger-aliases.json");
const requiredAliases = JSON.parse(fs.readFileSync(aliasesPath, "utf8")) as Record<string, string[]>;
const maxDescriptionChars = Number(process.env.SKILL_INDEX_MAX_DESCRIPTION_CHARS ?? "120");

function exists(input: string): boolean {
  try {
    fs.accessSync(input);
    return true;
  } catch {
    return false;
  }
}

function walkSkillFiles(root: string): string[] {
  const out: string[] = [];
  const seen = new Set<string>();
  function walk(dir: string) {
    let real = dir;
    try {
      real = fs.realpathSync(dir);
    } catch {
      return;
    }
    if (seen.has(real)) return;
    seen.add(real);
    let entries: fs.Dirent[];
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      return;
    }
    for (const entry of entries) {
      const file = path.join(dir, entry.name);
      if (entry.isDirectory() || entry.isSymbolicLink()) {
        let stat: fs.Stats;
        try {
          stat = fs.statSync(file);
        } catch {
          continue;
        }
        if (stat.isDirectory()) walk(file);
      } else if (entry.isFile() && entry.name === "SKILL.md") {
        out.push(file);
      }
    }
  }
  if (exists(root)) walk(root);
  return out;
}

function sanitize(value: string): string {
  return value
    .replace(/^[ \t]*["']?/, "")
    .replace(/["']?[ \t]*$/, "")
    .replace(/\s+/g, " ")
    .trim();
}

function parseFrontmatter(file: string): SkillFrontmatter | null {
  const text = fs.readFileSync(file, "utf8");
  const lines = text.split(/\r?\n/);
  if (lines[0]?.trim() !== "---") return null;
  const end = lines.findIndex((line, index) => index > 0 && line.trim() === "---");
  if (end < 0) return null;
  const fm = lines.slice(1, end);
  let name = path.basename(path.dirname(file));
  let description = "";
  let descriptionCount = 0;
  for (let index = 0; index < fm.length; index++) {
    const line = fm[index] ?? "";
    const nameMatch = /^name\s*:\s*(.*)$/.exec(line);
    if (nameMatch) name = sanitize(nameMatch[1] ?? name);
    const descMatch = /^description\s*:\s*(.*)$/.exec(line);
    if (!descMatch) continue;
    descriptionCount++;
    const raw = descMatch[1]?.trim() ?? "";
    if (raw === "|" || raw === ">") {
      const block: string[] = [];
      for (let blockIndex = index + 1; blockIndex < fm.length; blockIndex++) {
        if (/^[A-Za-z0-9_-]+\s*:/.test(fm[blockIndex] ?? "")) break;
        block.push((fm[blockIndex] ?? "").replace(/^\s{2}/, ""));
      }
      description = sanitize(block.join(" "));
    } else {
      description = sanitize(raw);
    }
  }
  return { name, description, path: file, descriptionCount };
}

const skills = new Map<string, SkillFrontmatter>();
const errors: string[] = [];
for (const root of roots) {
  for (const file of walkSkillFiles(root.path)) {
    const skill = parseFrontmatter(file);
    if (!skill) continue;
    if (skill.descriptionCount !== 1) {
      errors.push(`${skill.name}: expected exactly 1 frontmatter description, found ${skill.descriptionCount} (${skill.path})`);
    }
    const isBundledSystemSkill = file.startsWith(path.join(personalCodexRoot, ".system") + path.sep);
    if (root.enforceDescriptionLimit && !isBundledSystemSkill && skill.description.length > maxDescriptionChars) {
      errors.push(
        `${skill.name}: description is ${skill.description.length} chars; max is ${maxDescriptionChars} (${skill.path})`,
      );
    }
    if (!skills.has(skill.name)) skills.set(skill.name, skill);
  }
}

for (const [name, aliases] of Object.entries(requiredAliases)) {
  const skill = skills.get(name);
  if (!skill) {
    errors.push(`${name}: required skill missing`);
    continue;
  }
  const haystack = `${skill.name} ${skill.description}`.toLowerCase();
  for (const alias of aliases) {
    if (!haystack.includes(alias.toLowerCase())) {
      errors.push(`${name}: missing alias "${alias}" in visible skill index description (${skill.path})`);
    }
  }
}

if (errors.length) {
  console.error(["Skill index validation failed:", ...errors.map((error) => `- ${error}`)].join("\n"));
  process.exit(1);
}

console.log(
  `Skill index validation passed: ${skills.size} skills, ${Object.keys(requiredAliases).length} protected trigger sets, max description ${maxDescriptionChars} chars.`,
);
