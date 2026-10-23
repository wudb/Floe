#!/usr/bin/env python3
"""验证真实 app 与 ZIP/DMG 内的副本，并生成可追溯的发布清单。"""
import hashlib
import json
import os
from pathlib import Path
import plistlib
import subprocess
import sys
import tempfile


def run(*args):
    return subprocess.check_output(args)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def app_manifest(app):
    # 符号链接单独比较，避免漏掉 Sparkle.framework 的版本链接。
    return {
        str(path.relative_to(app)): ("link:" + os.readlink(path) if path.is_symlink() else digest(path))
        for path in app.rglob("*") if path.is_symlink() or path.is_file()
    }


def verify_app(app, version, build, bundle_id):
    with (app / "Contents/Info.plist").open("rb") as stream:
        info = plistlib.load(stream)
    expected = {"CFBundleShortVersionString": version, "CFBundleVersion": build, "CFBundleIdentifier": bundle_id}
    for key, value in expected.items():
        if info.get(key) != value:
            raise ValueError(f"{app}: {key} = {info.get(key)!r}, expected {value!r}")
    run("codesign", "--verify", "--deep", "--strict", str(app))
    architectures = {}
    # 检查所有 Mach-O，包括嵌入的更新器/XPC，而不只检查主程序。
    magic = {bytes.fromhex(value) for value in ("feedface", "cefaedfe", "feedfacf", "cffaedfe", "cafebabe", "bebafeca", "cafebabf", "bfbafeca")}
    for path in app.rglob("*"):
        if path.is_symlink() or not path.is_file():
            continue
        with path.open("rb") as stream:
            is_macho = stream.read(4) in magic
        if is_macho:
            archs = run("lipo", "-archs", str(path)).decode().split()
            if set(archs) != {"arm64", "x86_64"}:
                raise ValueError(f"Non-Universal Mach-O: {path}: {archs}")
            architectures[str(path.relative_to(app))] = archs
    executable = "Contents/MacOS/" + info["CFBundleExecutable"]
    if executable not in architectures:
        raise ValueError("Missing main executable")
    return info, architectures


def main():
    directory = Path(sys.argv[1]).resolve()
    version, build, bundle_id = sys.argv[2:5]
    app = directory / "Floe.app"
    info, architectures = verify_app(app, version, build, bundle_id)
    manifest = app_manifest(app)
    with tempfile.TemporaryDirectory(prefix="Floe-package-check-") as temporary:
        extracted = Path(temporary) / "zip"
        run("ditto", "-x", "-k", str(directory / "Floe.zip"), str(extracted))
        verify_app(extracted / "Floe.app", version, build, bundle_id)
        if app_manifest(extracted / "Floe.app") != manifest:
            raise ValueError("ZIP app differs from the signed app")
        run("hdiutil", "verify", str(directory / "Floe.dmg"))
        mount = Path(temporary) / "mount"
        mount.mkdir()
        run("hdiutil", "attach", "-readonly", "-nobrowse", "-mountpoint", str(mount), str(directory / "Floe.dmg"))
        try:
            verify_app(mount / "Floe.app", version, build, bundle_id)
            if app_manifest(mount / "Floe.app") != manifest:
                raise ValueError("DMG app differs from the signed app")
            if not (mount / "Applications").is_symlink() or os.readlink(mount / "Applications") != "/Applications":
                raise ValueError("DMG Applications link is missing or invalid")
        finally:
            run("hdiutil", "detach", str(mount))
    assets = [{"name": name, "size": (directory / name).stat().st_size, "sha256": digest(directory / name)}
              for name in ("Floe.zip", "Floe.dmg")]
    (directory / "SHA256SUMS.txt").write_text("".join(f"{asset['sha256']}  {asset['name']}\n" for asset in assets))
    project = Path(__file__).resolve().parent.parent
    metadata = {
        "version": version, "build": build, "bundleIdentifier": bundle_id,
        "commit": run("git", "-C", str(project), "rev-parse", "HEAD").decode().strip(),
        "worktreeDirty": bool(run("git", "-C", str(project), "status", "--porcelain")),
        "minimumOSVersion": info.get("LSMinimumSystemVersion"), "sdk": info.get("DTSDKName"),
        "signing": "ad-hoc", "notarized": False,
        "machOArchitectures": architectures, "assets": assets,
    }
    (directory / "build-info.json").write_text(json.dumps(metadata, indent=2) + "\n")
    print(f"Verified version, bundle ID, signatures, all Mach-O architectures and ZIP/DMG contents: {version} ({build})")


if __name__ == "__main__":
    main()
