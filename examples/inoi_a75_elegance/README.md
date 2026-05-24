# INOI A75 Elegance Example

This directory documents the INOI A75 Elegance profile as an example only.

The public repository does not include OEM payload binaries. The working INOI
release ZIP is produced outside the generic template build by directly copying
the confirmed-working `example.zip` into `dist/`.

The current package model preserves stock EROFS metadata, avoids
`big_pcluster`, uses `extract.erofs -x`, and resizes logical partitions with
`lptools resize` before writeback if a rebuilt EROFS image is larger than the
current mapper block. EXT4 profiles continue to grow the logical partition and
filesystem before patching mounted files in place.
