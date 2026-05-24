# CoreShift Update Patcher v1.0

Initial public template release for CoreShift Update Patcher.

- Reinitialized the public template from the renewed confirmed-working recovery
  flashable package.
- Preserved the generic installer skeleton with EROFS, EXT4, active-slot,
  logical partition, `system_root`, idempotent hash validation, payload
  allowlist, and AVB report-only behavior.
- Updated the EROFS rebuild model to use `extract.erofs -x`, patch the selected
  target root in-place, rebuild from the full extracted image root, and verify
  the rebuilt image with extraction.
- Updated EROFS mkfs behavior to preserve stock-like metadata with stock
  `fs_config`, stock `file_contexts`, stock UUID, fixed 2009 timestamp,
  `--mount-point`, and no `big_pcluster`.
- Added EROFS oversize handling: validation reports oversize as a warning, while
  install mode resizes the active logical partition with `lptools resize`,
  rechecks mapper capacity, and only writes the rebuilt image after it fits.
- Kept EXT4 on the existing grow-and-patch model: resize the logical partition
  with `lptools`, run `resize2fs`, remount read-write, then patch files in
  place.
- Redirected helper output to logs so colored extractor/mkfs progress cannot
  leak raw text into recovery's updater command channel.
- Kept the public template free of proprietary OEM binaries.
- Published the INOI A75 Elegance runtime fixes as a separate release artifact
  copied byte-for-byte from the confirmed-working `example.zip`.
