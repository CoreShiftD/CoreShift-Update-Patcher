# INOI A75 Elegance Example

This directory documents the INOI A75 Elegance profile bundled in this release.

The working INOI release ZIP is built from the current repository content that
was reinitialized from the verified working source tree.

The current package model preserves stock EROFS metadata, avoids
`big_pcluster`, uses `extract.erofs -x`, and resizes logical partitions with
`lptools resize` before writeback if a rebuilt EROFS image is larger than the
current mapper block. EXT4 profiles continue to grow the logical partition and
filesystem before patching mounted files in place.
