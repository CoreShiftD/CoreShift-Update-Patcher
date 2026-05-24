# INOI A75 Elegance

INOI A75 Elegance is included as a device profile reference for CoreShift
Update Patcher.

This release includes the INOI payload files from the verified release package.
The INOI release artifact is rebuilt from the current repository content.

The current INOI package uses the metadata-preserving EROFS pipeline:

- active logical partition mapping through `/dev/block/mapper`;
- `extract.erofs -x` extraction;
- separate image root and target root handling;
- stock `fs_config`, stock `file_contexts`, fixed 2009 timestamp, and no
  `mkfs.erofs -U` UUID argument during rebuild;
- EROFS logical partition resize with `lptools resize` if the rebuilt image is
  larger than the current mapper block;
- EXT4 logical partition growth with `lptools resize` plus `resize2fs` before
  in-place file replacement when free space is insufficient.

For the v1.0 release artifact:

- Source of truth: verified working source tree
- Output: `dist/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip`
- Required behavior: generated from the flashable package staging directory
