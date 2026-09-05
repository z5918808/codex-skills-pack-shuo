from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(SKILL_ROOT / "scripts"))

import inventory_workspace as inventory  # noqa: E402


class InventoryTests(unittest.TestCase):
    def test_detects_project_and_never_reads_secret_content(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            project = root / "demo"
            project.mkdir()
            (project / "pyproject.toml").write_text("[project]\nname='demo'\n", encoding="utf-8")
            (project / ".env.local").write_text("TOKEN=do-not-leak-this-value\n", encoding="utf-8")

            result = inventory.build_inventory(root)
            payload = json.dumps(result, ensure_ascii=False)
            project_record = next(item for item in result["projects"] if item["path"] == "demo")
            coverage_record = next(item for item in result["coverage"] if item["path"] == "demo")

            self.assertIn("pyproject.toml", project_record["markers"])
            self.assertEqual("project", coverage_record["kind"])
            self.assertIn(".env.local", project_record["sensitive_file_names"])
            self.assertNotIn("do-not-leak-this-value", payload)

    def test_records_default_dependency_boundary(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "node_modules").mkdir()
            result = inventory.build_inventory(root)
            entry = next(item for item in result["coverage"] if item["path"] == "node_modules")
            self.assertEqual("excluded", entry["kind"])

    @unittest.skipUnless(shutil.which("git"), "git is not installed")
    def test_captures_git_dirty_state_without_writing_index(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            subprocess.run(["git", "init", str(root)], check=True, capture_output=True)
            (root / "untracked.txt").write_text("unique work\n", encoding="utf-8")

            result = inventory.build_inventory(root)
            project = next(item for item in result["projects"] if item["path"] == ".")

            self.assertTrue(project["git"]["available"])
            self.assertTrue(project["git"]["dirty"])
            self.assertEqual(1, project["git"]["status_counts"]["untracked"])

    def test_remote_redaction_removes_userinfo_and_query(self) -> None:
        value = "https://token@example.com/org/repo.git?credential=secret#fragment"
        redacted = inventory.redact_remote(value)
        self.assertEqual("https://<redacted>@example.com/org/repo.git", redacted)


if __name__ == "__main__":
    unittest.main()
