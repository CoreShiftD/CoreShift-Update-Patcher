#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST_DIR="$ROOT_DIR/dist"
TEMPLATE_ZIP="$DIST_DIR/CoreShift_Update_Patcher_Template_v1.0.zip"
INOI_ZIP="$DIST_DIR/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip"
TMP_DIR="$ROOT_DIR/.validate"

cd "$ROOT_DIR"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

require_file "$TEMPLATE_ZIP"
require_file "$INOI_ZIP"
require_file checksums.txt

unzip -tq "$TEMPLATE_ZIP"
unzip -tq "$INOI_ZIP"

if cmp -s "$TEMPLATE_ZIP" "$INOI_ZIP"; then
  echo "OK: INOI artifact matches template artifact byte-for-byte"
else
  echo "FAIL: INOI artifact differs from template artifact" >&2
  exit 1
fi

sha256sum -c checksums.txt
echo "OK: release checksums are correct"

if grep -R -E 'avbctl[[:space:]]+disable-(verity|verification)' META-INF; then
  echo "FAIL: installer contains AVB/vbmeta disable commands" >&2
  exit 1
fi
echo "OK: installer contains no AVB/vbmeta disable commands"

if grep -R -F '/data/adb/ksu/bin' META-INF; then
  echo "FAIL: installer has hard dependency on /data/adb/ksu/bin" >&2
  exit 1
fi
echo "OK: installer has no /data/adb/ksu/bin dependency"

sh -n META-INF/com/google/android/update-binary

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
for z in "$TEMPLATE_ZIP" "$INOI_ZIP"; do
  rm -rf "$TMP_DIR"/*
  unzip -q "$z" META-INF/com/google/android/update-binary -d "$TMP_DIR"
  sh -n "$TMP_DIR/META-INF/com/google/android/update-binary"
done
rm -rf "$TMP_DIR"

echo "All release validation checks passed."
