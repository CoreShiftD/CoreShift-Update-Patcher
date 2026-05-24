#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST_DIR="$ROOT_DIR/dist"
TEMPLATE_ZIP="$DIST_DIR/CoreShift_Update_Patcher_Template_v1.0.zip"
INOI_ZIP="$DIST_DIR/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip"
SOURCE_ZIP="$ROOT_DIR/example.zip"
TMP_DIR="$ROOT_DIR/.validate"

cd "$ROOT_DIR"

require_file() {
  if [ ! -f "$1" ]; then
    echo "missing required file: $1" >&2
    exit 1
  fi
}

require_file "$SOURCE_ZIP"
require_file "$TEMPLATE_ZIP"
require_file "$INOI_ZIP"

unzip -tq "$SOURCE_ZIP"
unzip -tq "$INOI_ZIP"
unzip -tq "$TEMPLATE_ZIP"

if cmp -s "$SOURCE_ZIP" "$INOI_ZIP"; then
  echo "OK: INOI artifact is byte-identical to example.zip"
else
  echo "FAIL: INOI artifact differs from example.zip" >&2
  exit 1
fi

if unzip -Z1 "$TEMPLATE_ZIP" | grep -Eq '(^|/)(framework\.jar|mediatek-services\.jar|libandroid_runtime\.so)$'; then
  echo "FAIL: template ZIP contains proprietary OEM payload binaries" >&2
  exit 1
fi
echo "OK: template ZIP contains no OEM proprietary payload binaries"

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

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
unzip -q "$TEMPLATE_ZIP" -d "$TMP_DIR/template"
(
  cd "$TMP_DIR/template"
  sha256sum -c checksums.example.txt
)
rm -rf "$TMP_DIR"
echo "OK: template checksums are correct"

sh -n META-INF/com/google/android/update-binary

echo "All release validation checks passed."
