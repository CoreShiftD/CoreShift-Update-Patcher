# INOI A75 Elegance

INOI A75 Elegance is included as an example device profile reference for the
CoreShift Update Patcher template.

The public template does not include INOI payload files, stock blobs, patched
framework files, or patched native libraries. The INOI release artifact is
generated separately by copying the confirmed-working `example.zip` without
rebuilding or modifying it.

The current INOI package uses the metadata-preserving EROFS pipeline:

- active logical partition mapping through `/dev/block/mapper`;
- `extract.erofs -x` extraction;
- separate image root and target root handling;
- stock `fs_config`, stock `file_contexts`, stock UUID, and fixed 2009
  timestamp during rebuild;
- EROFS logical partition resize with `lptools resize` if the rebuilt image is
  larger than the current mapper block;
- EXT4 logical partition growth with `lptools resize` plus `resize2fs` before
  in-place file replacement when free space is insufficient.

For the v1.0 release artifact:

- Source of truth: `example.zip`
- Output: `dist/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip`
- Required behavior: byte-identical copy
