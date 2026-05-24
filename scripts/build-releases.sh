#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST_DIR="$ROOT_DIR/dist"
STAGE_DIR="$ROOT_DIR/.build/template"
TEMPLATE_ZIP="$DIST_DIR/CoreShift_Update_Patcher_Template_v1.0.zip"
INOI_ZIP="$DIST_DIR/CoreShift_Update_Patcher_INOI_A75_Elegance_Runtime_Fixes_v1.0.zip"
SOURCE_ZIP="$ROOT_DIR/example.zip"

cd "$ROOT_DIR"

if [ ! -f "$SOURCE_ZIP" ]; then
  echo "missing source ZIP: example.zip" >&2
  exit 1
fi

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR" "$DIST_DIR"

copy_path() {
  src=$1
  dst="$STAGE_DIR/$src"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
}

copy_path README.md
copy_path RELEASE_NOTES.md
copy_path module.prop
copy_path manifest.example.json
copy_path checksums.example.txt
copy_path .gitignore
copy_path META-INF
copy_path payload
copy_path docs
copy_path examples
copy_path .github

(
  cd "$STAGE_DIR"
  sha256sum README.md module.prop manifest.example.json > checksums.example.txt
)

rm -f "$TEMPLATE_ZIP"
(
  cd "$STAGE_DIR"
  find . -type f | sort | sed 's#^\./##' | zip -q -X "$TEMPLATE_ZIP" -@
)

cp "$SOURCE_ZIP" "$INOI_ZIP"

echo "SHA256:"
sha256sum "$SOURCE_ZIP" "$TEMPLATE_ZIP" "$INOI_ZIP"

if cmp -s "$SOURCE_ZIP" "$INOI_ZIP"; then
  echo "INOI release ZIP matches example.zip byte-for-byte."
else
  echo "INOI release ZIP differs from example.zip." >&2
  exit 1
fi
