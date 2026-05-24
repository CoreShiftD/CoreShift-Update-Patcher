# CoreShift Update Patcher v1.0

## Reinitialized release package

- Reinitialized release artifacts from the verified working source tree.
- EROFS rebuilds now omit the `mkfs.erofs -U` UUID argument entirely.
- This prevents invalid or short UUID values such as `9` from reaching `mkfs.erofs`.
- Confirmed on-device dry-run: `-U 9` fails, while no-UUID builds pass.
- Preserves current metadata-matching EROFS rebuild improvements.
- Recovery flash/writeback remains experimental until confirmed on the target device.

## Initial release baseline

Initial release baseline for CoreShift Update Patcher.

- Reinitialized the package from the renewed confirmed-working recovery
  flashable package.
- Preserved the generic installer skeleton with EROFS, EXT4, active-slot,
  logical partition, `system_root`, idempotent hash validation, payload
  allowlist, and AVB report-only behavior.
- Updated the EROFS rebuild model to use `extract.erofs -x`, patch the selected
  target root in-place, rebuild from the full extracted image root, and verify
  the rebuilt image with extraction.
- Updated EROFS mkfs behavior to preserve stock-like metadata with stock
  `fs_config`, stock `file_contexts`, fixed 2009 timestamp, `--mount-point`,
  and no `big_pcluster`. UUID is intentionally omitted.
- Added EROFS oversize handling: validation reports oversize as a warning, while
  install mode resizes the active logical partition with `lptools resize`,
  rechecks mapper capacity, and only writes the rebuilt image after it fits.
- Kept EXT4 on the existing grow-and-patch model: resize the logical partition
  with `lptools`, run `resize2fs`, remount read-write, then patch files in
  place.
- Redirected helper output to logs so colored extractor/mkfs progress cannot
  leak raw text into recovery's updater command channel.
- Rebuilt release artifacts from the same current repository
  source so they carry the synchronized updater, tools, and payload.
