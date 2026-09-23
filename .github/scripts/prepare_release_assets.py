#!/usr/bin/env python3
"""
Prepares and normalizes release asset names for GitHub Releases.
Categorizes assets by platform prefix ('Windows - ', 'Android - ', 'macOS - ', 'Linux - ', 'iOS - ')
and groups developer/unsigned/bundle files under 'ZDev - ' so they sort to the bottom.
"""

import os
import sys
import shutil
from pathlib import Path


def classify_asset(filepath: Path) -> str | None:
    """Determines the standardized release asset name for a given file path."""
    name_lower = filepath.name.lower()
    path_str = str(filepath).lower()

    # Skip temporary, build, or hidden files
    if filepath.name.startswith(".") or name_lower.endswith(".sha256"):
        return None

    # 1. Android & Wear OS App Bundles (.aab) -> Always ZDev
    if name_lower.endswith(".aab"):
        if "wear" in name_lower or "wear" in path_str:
            return "ZDev - Android - WearOS.aab"
        return "ZDev - Android - Discipulus.aab"

    # 2. Android & Wear OS APKs
    if name_lower.endswith(".apk"):
        is_unsigned = "unsigned" in name_lower
        is_wear = "wear" in name_lower or "wear" in path_str

        if is_unsigned:
            if is_wear:
                return "ZDev - Android - WearOS_unsigned.apk"
            return "ZDev - Android - Discipulus_unsigned.apk"

        if is_wear:
            return "Android - Discipulus_WearOS.apk"
        if "arm64" in name_lower:
            return "Android - Discipulus_arm64-v8a.apk"
        if "armeabi" in name_lower:
            return "Android - Discipulus_armeabi-v7a.apk"
        if "x86_64" in name_lower:
            return "Android - Discipulus_x86_64.apk"
        if "universal" in name_lower or name_lower == "app-release.apk":
            return "Android - Discipulus_Universal.apk"
        return f"Android - Discipulus_{filepath.stem}.apk"

    # 3. Windows Assets
    if name_lower.endswith(".exe"):
        # We only publish the installer executable, skip bare raw runner executables
        if "setup" in name_lower or "installer" in name_lower:
            return "Windows - Discipulus_Setup.exe"
        if "windows" in path_str and name_lower == "discipulus.exe":
            # Standalone runner without assets/dlls is not runnable on its own; skip
            return None

    if name_lower.endswith(".zip") and ("windows" in name_lower or "windows" in path_str):
        return "Windows - Discipulus_Portable.zip"

    # 4. Linux Assets
    if name_lower.endswith(".flatpak"):
        return "Linux - Discipulus.flatpak"
    if name_lower.endswith(".tar.gz") and ("linux" in name_lower or "linux" in path_str):
        return "Linux - Discipulus.tar.gz"

    # 5. macOS Assets
    if name_lower.endswith(".dmg"):
        return "macOS - Discipulus.dmg"
    if name_lower.endswith(".zip") and ("macos" in name_lower or "macos" in path_str):
        return "macOS - Discipulus.zip"

    # 6. iOS Assets
    if name_lower.endswith(".ipa"):
        if "unsigned" in name_lower or "unaligned" in name_lower:
            return "ZDev - iOS - Discipulus_unsigned.ipa"
        return "iOS - Discipulus.ipa"

    return None


def prepare_assets(input_dir: Path, output_dir: Path):
    if not input_dir.exists():
        print(f"[ERROR] Input directory '{input_dir}' does not exist.")
        sys.exit(1)

    output_dir.mkdir(parents=True, exist_ok=True)
    staged: dict[str, Path] = {}

    for root, _, files in os.walk(input_dir):
        for f in files:
            src = Path(root) / f
            dest_name = classify_asset(src)
            if not dest_name:
                continue

            # Deduplication: if target already chosen, keep the larger file
            if dest_name in staged:
                existing_size = staged[dest_name].stat().st_size
                current_size = src.stat().st_size
                if current_size > existing_size:
                    staged[dest_name] = src
            else:
                staged[dest_name] = src

    print("=" * 65)
    print(" Staging Release Assets ")
    print("=" * 65)

    for target_name in sorted(staged.keys()):
        src_path = staged[target_name]
        dest_path = output_dir / target_name
        shutil.copy2(src_path, dest_path)
        size_mb = dest_path.stat().st_size / (1024 * 1024)
        print(f" -> {target_name:<40} ({size_mb:.2f} MB)")

    print("=" * 65)
    print(f"Total staged assets: {len(staged)} files in '{output_dir}'")


if __name__ == "__main__":
    in_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("artifacts")
    out_dir = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("release_assets")
    prepare_assets(in_dir, out_dir)
