# CoreShift Update Patcher

CoreShift Update Patcher is a recovery-flashable ROM update patcher package. It
provides a known-working installer structure for device profiles that patch
selected ROM files from recovery.

The package is designed around a known-working recovery installer structure and
supports:

- EROFS partition handling.
- EXT4 partition handling.
- Active slot detection.
- Dynamic and logical partition layouts.
- Recovery `system_root` mount layout handling.
- Idempotent hash validation.
- Payload allowlist enforcement.
- Original hash equals patch.
- Patched hash equals skip.
- Unknown hash equals abort.
- AVB and verity report-only behavior.
- No vbmeta or verity modification.
- Install markers when present in a device profile.

Always back up the device before flashing a generated package. Recovery
environments, partition layouts, filesystem formats, and vendor changes vary by
device and firmware build.

## What Is Included

- `META-INF/` recovery installer structure copied from the confirmed-working
  package.
- `module.prop` with generic CoreShift Update Patcher metadata.
- `manifest.json` copied from the release package.
- `manifest.example.json` as an example device manifest.
- `checksums.txt` for generated release artifacts.
- `payload/` files copied from the release package.
- Documentation and example device-profile notes.
- Release build and validation scripts.

## Installer Model

- Manual logical partition mapping is the primary path. Recovery-mounted
  `/system`, `/system_root/system`, and `/mnt/system` paths are fallback/debug
  candidates only.
- EROFS partitions are dumped to the heavy work directory, extracted with
  `extract.erofs -x`, patched in-place, rebuilt from the full extracted image
  root, and verified by extracting the rebuilt image again.
- EROFS rebuilds preserve stock-like filesystem metadata using the extracted
  stock `fs_config` and `file_contexts`, the stock UUID, the stock 2009
  timestamp, and stock-compatible mkfs options. The rebuild intentionally avoids
  `big_pcluster`.
- If a rebuilt EROFS image is larger than the current logical partition, the
  installer warns, resizes the active logical partition with `lptools resize`,
  rechecks the mapper size, and only then writes the rebuilt image.
- EXT4 partitions are patched by mounting the mapped block read-write. If the
  replacement payloads do not fit the mounted filesystem, the installer grows
  the logical partition with `lptools resize`, runs `resize2fs`, remounts, and
  then patches files in place.
- External helper output is redirected to logs so recovery stdout remains a
  clean updater command channel.

## Device Profiles

INOI A75 Elegance is documented as the bundled device profile for this release.
Release ZIPs are rebuilt from the current repository content.

## Build

From the repository root:

```sh
scripts/build-releases.sh
```

This creates:

- `dist/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip`
- `dist/CoreShift_Update_Patcher_Template_v1.0.zip`

Both artifacts are produced from the same flashable package staging directory
and should match byte-for-byte. The ZIPs contain flashable content only:
`META-INF/`, `payload/`, `module.prop`, and `manifest.json`.

## Validate

```sh
scripts/validate-releases.sh
```

Validation checks ZIP integrity, verifies that the generated artifacts match,
checks `checksums.txt`, rejects installer commands that disable AVB or verity,
confirms there is no hard dependency on `/data/adb/ksu/bin`, and syntax-checks
the source and embedded `update-binary` files. Runtime dry validation should
treat EROFS oversize as a warning and report whether install mode would resize
with `lptools`.
