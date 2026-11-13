#!/usr/bin/env python3
"""在临时仓库验证发布规则与失败保护；不构建、发布或改动真实版本。"""
import importlib.util
import hashlib
import json
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


class AppcastChecks(unittest.TestCase):
    """使用固定测试签名验证草稿发布与错误拦截，不读取真实发布私钥。"""

    @classmethod
    def setUpClass(cls):
        cls.build_directory = tempfile.TemporaryDirectory(prefix="Floe-appcast-verifier-")
        cls.addClassCleanup(cls.build_directory.cleanup)
        cls.verifier = Path(cls.build_directory.name) / "verify-appcast"
        subprocess.run(["swiftc", str(ROOT / "script/verify-appcast.swift"), "-o", str(cls.verifier),
                        "-module-cache-path", str(Path(cls.build_directory.name) / "modules")], check=True)

    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="Floe-appcast-test-")
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.archive = b"Floe appcast test archive"
        self.public_key = "6kpsY+KcUgq+9VB7Ey7F+ZVHdq6+vnuSQh7qaRRG0iw="
        self.signature = "fgqTNoelv9hFMkyArXUDifi9B0grXY3ylLp4JGbbYoDJNXgF/Vwfo47TJsIWq0zHz5f4kNHvzr9upCs/ss3xDQ=="
        self.feed = "https://github.com/wudb/Floe/releases/latest/download/appcast.xml"
        self.download = "https://github.com/wudb/Floe/releases/download/v1.0.4/Floe.zip"
        self.configuration = {"SUPublicEDKey": self.public_key, "SUFeedURL": self.feed}
        self.info = {**self.configuration, "CFBundleVersion": "2354", "CFBundleShortVersionString": "1.0.4",
                     "CFBundleIdentifier": "com.float.floe", "LSMinimumSystemVersion": "14.0"}
        self.metadata = {"tagName": "v1.0.4", "isDraft": False, "isPrerelease": False,
                         "assets": [{"name": "Floe.zip", "url": self.download, "state": "uploaded",
                                     "size": len(self.archive),
                                     "digest": "sha256:" + hashlib.sha256(self.archive).hexdigest()}]}

    def verify(self):
        (self.directory / "Floe.zip").write_bytes(self.archive)
        (self.directory / "archive.plist").write_bytes(plistlib.dumps(self.info))
        (self.directory / "config.plist").write_bytes(plistlib.dumps(self.configuration))
        (self.directory / "release.json").write_text(json.dumps(self.metadata))
        (self.directory / "appcast.xml").write_text(
            '<rss xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" version="2.0">'
            '<channel><item><sparkle:version>2354</sparkle:version>'
            '<sparkle:shortVersionString>1.0.4</sparkle:shortVersionString>'
            '<sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>'
            f'<enclosure url="{self.download}" length="{len(self.archive)}" '
            f'sparkle:edSignature="{self.signature}"/></item></channel></rss>')
        return subprocess.run([str(self.verifier), str(self.directory / "appcast.xml"),
                               str(self.directory / "Floe.zip"), str(self.directory / "archive.plist"),
                               str(self.directory / "config.plist"), str(self.directory / "release.json"),
                               "v1.0.4", "false"], capture_output=True, text=True)

    def test_published_and_draft_asset_urls(self):
        result = self.verify()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.metadata["isDraft"] = True
        self.metadata["assets"][0]["url"] = "https://github.com/wudb/Floe/releases/download/untagged-example/Floe.zip"
        result = self.verify()
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_reject_foreign_draft_asset_and_published_temporary_url(self):
        self.metadata["isDraft"] = True
        self.metadata["assets"][0]["url"] = "https://github.com/other/Floe/releases/download/untagged-example/Floe.zip"
        self.assertIn("Unexpected draft release download URL", self.verify().stderr)
        self.metadata["isDraft"] = False
        self.metadata["assets"][0]["url"] = "https://github.com/wudb/Floe/releases/download/untagged-example/Floe.zip"
        self.assertIn("Unexpected release download URL", self.verify().stderr)

    def test_reject_wrong_signature_and_archive_key(self):
        self.signature = "AA" + self.signature[2:]
        self.assertIn("signature does not match", self.verify().stderr)
        self.info["SUPublicEDKey"] = "wrong-key"
        self.assertIn("Archive public key mismatch", self.verify().stderr)

    def test_reject_changed_archive(self):
        self.archive = b"X" + self.archive[1:]
        self.assertIn("SHA-256 mismatch", self.verify().stderr)


if __name__ == "__main__":
    unittest.main(verbosity=2)
