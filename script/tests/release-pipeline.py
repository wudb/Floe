#!/usr/bin/env python3
"""在临时仓库验证发布规则与失败保护；不构建、发布或改动真实版本。"""
import importlib.util
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.dont_write_bytecode = True


class ReleaseChecks(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="Floe-release-test-")
        self.addCleanup(self.temporary.cleanup)
        self.repo = Path(self.temporary.name)
        (self.repo / "script/lib").mkdir(parents=True)
        (self.repo / "Floe.xcodeproj").mkdir()
        for file in ("script/build.sh", "script/lib/build-settings.sh"):
            shutil.copy2(ROOT / file, self.repo / file)
        self.env = {key: value for key, value in os.environ.items()
                    if key not in ("MARKETING_VERSION", "CURRENT_PROJECT_VERSION") and not key.startswith("FLOE_")}
        self.git("init", "-q")
        self.project("1.0.0", "2350")
        self.commit()
        self.git("tag", "v1.0.0")
        self.project("1.0.1", "2351")
        self.commit()

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.repo), *args], env=self.env, stderr=subprocess.STDOUT)

    def project(self, version, build):
        (self.repo / "Floe.xcodeproj/project.pbxproj").write_text(
            (f"MARKETING_VERSION = {version};\nCURRENT_PROJECT_VERSION = {build};\n"
             "PRODUCT_BUNDLE_IDENTIFIER = com.float.floe;\n") * 2)

    def commit(self):
        self.git("add", ".")
        self.git("-c", "user.name=Floe Test", "-c", "user.email=test@example.invalid",
                 "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-qm", "fixture")

    def resolve(self, command="floe_resolve_build_settings", **env):
        return subprocess.run(["bash", "-c", 'set -euo pipefail; source script/lib/build-settings.sh; '
                               + command + '; printf "%s\\n" "${VERSION_ARGS[@]}"'],
                              cwd=self.repo, env={**self.env, **env}, capture_output=True, text=True)

    def test_project_defaults_and_environment_override(self):
        result = self.resolve()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.splitlines(), ["MARKETING_VERSION=1.0.1", "CURRENT_PROJECT_VERSION=2351"])
        result = self.resolve(MARKETING_VERSION="9.8.7", CURRENT_PROJECT_VERSION="9999")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.splitlines(), ["MARKETING_VERSION=9.8.7", "CURRENT_PROJECT_VERSION=9999"])

    def test_reject_conflicts_invalid_versions_and_build_rollback(self):
        cases = [
            ("floe_resolve_build_settings v1.0.1", {"MARKETING_VERSION": "1.0.2"}),
            ("floe_resolve_build_settings", {"MARKETING_VERSION": "../invalid"}),
            ("floe_resolve_build_settings", {"CURRENT_PROJECT_VERSION": "2350"}),
            ("floe_resolve_build_settings", {"CURRENT_PROJECT_VERSION": "0"}),
            ("floe_resolve_build_settings", {"CURRENT_PROJECT_VERSION": "1;echo bad"}),
        ]
        for command, env in cases:
            with self.subTest(env=env):
                self.assertNotEqual(self.resolve(command, **env).returncode, 0)

    def test_release_requires_committed_version_and_increasing_build(self):
        self.assertEqual(self.resolve("floe_validate_release_tag v1.0.1").returncode, 0)
        self.assertNotEqual(self.resolve("floe_validate_release_tag v1.0.2").returncode, 0)
        self.assertNotEqual(self.resolve("floe_validate_release_tag v1.0.1", CURRENT_PROJECT_VERSION="9999").returncode, 0)
        self.project("1.0.1", "2350")
        self.commit()
        self.assertNotEqual(self.resolve("floe_validate_release_tag v1.0.1").returncode, 0)

    def test_configuration_mismatch(self):
        path = self.repo / "Floe.xcodeproj/project.pbxproj"
        path.write_text(path.read_text().replace("CURRENT_PROJECT_VERSION = 2351", "CURRENT_PROJECT_VERSION = 2352", 1))
        self.assertNotEqual(self.resolve().returncode, 0)

    def build(self, output):
        return subprocess.run(["bash", "script/build.sh"], cwd=self.repo,
                              env={**self.env, "FLOE_RELEASE_ROOT": str(output)}, capture_output=True, text=True)

    def test_existing_output_is_never_replaced(self):
        output = self.repo / "artifacts"
        version = output / "v1.0.1"
        version.mkdir(parents=True)
        marker = version / "keep"
        marker.write_text("original")
        result = self.build(output)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Output already exists", result.stderr)
        self.assertEqual(marker.read_text(), "original")
        shutil.rmtree(version)
        version.symlink_to(output / "missing")
        self.assertNotEqual(self.build(output).returncode, 0)
        self.assertTrue(version.is_symlink())

    def test_failed_build_retains_old_release_and_failure_log(self):
        output = self.repo / "artifacts"
        (output / "v1.0.0").mkdir(parents=True)
        marker = output / "v1.0.0/keep"
        marker.write_text("original")
        tools = self.repo / "tools"
        tools.mkdir()
        xcode = tools / "xcodebuild"
        xcode.write_text("#!/bin/bash\necho controlled-build-failure\nexit 23\n")
        xcode.chmod(0o755)
        self.env["PATH"] = str(tools) + os.pathsep + self.env["PATH"]
        result = self.build(output)
        self.assertEqual(result.returncode, 23, result.stderr)
        self.assertEqual(marker.read_text(), "original")
        self.assertFalse((output / "v1.0.1").exists())
        self.assertEqual(list(output.glob(".v1.0.1.*")), [])
        logs = list(output.glob("failed-build-*.log"))
        self.assertEqual(len(logs), 1)
        self.assertIn("controlled-build-failure", logs[0].read_text())

    def test_package_verifier_rejects_wrong_version_and_identity(self):
        spec = importlib.util.spec_from_file_location("floe_verify", ROOT / "script/verify-release.py")
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        app = self.repo / "Floe.app"
        (app / "Contents").mkdir(parents=True)
        info = {"CFBundleShortVersionString": "1.0.1", "CFBundleVersion": "2351", "CFBundleIdentifier": "com.float.floe"}
        with (app / "Contents/Info.plist").open("wb") as stream:
            plistlib.dump(info, stream)
        for version, build, identifier in [("9.8.7", "2351", "com.float.floe"),
                                            ("1.0.1", "9999", "com.float.floe"),
                                            ("1.0.1", "2351", "wrong.identifier")]:
            with self.assertRaises(ValueError):
                module.verify_app(app, version, build, identifier)


if __name__ == "__main__":
    unittest.main(verbosity=2)
