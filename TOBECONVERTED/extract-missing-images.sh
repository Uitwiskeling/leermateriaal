#!/usr/bin/env bash
# Extract missing images from full-source zips into the minim img/ dirs.
# Run from TOBECONVERTED/:  bash extract-missing-images.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
FULL="fullfoldersnotcommitted"
ORIG="originals"

extract_file() {
  # extract_file <zipfile> <file-in-zip> <dest-dir>
  local zip="$1" src="$2" dest="$3"
  mkdir -p "$dest"
  unzip -p "$zip" "$src" > "$dest/$(basename "$src")" && \
    echo "  ✓ $(basename "$src")" || \
    echo "  ✗ NIET GEVONDEN in $zip: $src"
}

extract_dir() {
  # extract_dir <zipfile> <dir-in-zip> <dest-dir>
  # Extracts all files from dir-in-zip into dest-dir (flat, no subdir creation)
  local zip="$1" src="$2" dest="$3"
  mkdir -p "$dest"
  unzip -j "$zip" "$src/*" -d "$dest" && \
    echo "  ✓ $src/* → $dest" || \
    echo "  ✗ NIET GEVONDEN in $zip: $src/*"
}

echo "=== UW3802 ==="
extract_file "$FULL/UW3802/UW3802 backup.zip" "img/clothoidebanner.jpg" "$ORIG/UW3802-minim/img"

echo "=== UW3803 ==="
extract_file "$FULL/UW3803/UW3803 backup.zip" "img/grexit2.jpg" "$ORIG/UW3803-minim/img"

echo "=== UW3804 ==="
extract_file "$FULL/UW3804/UW 3804 backup.zip" "img/groepeninl.jpg" "$ORIG/UW3804-minim/img"

echo "=== UW3901 ==="
extract_file "$FULL/UW3901/UW3901.zip" "img/ikea.jpg" "$ORIG/UW3901-minim/img"

echo "=== UW3902 ==="
extract_file "$FULL/UW3902/UW 39_2.zip" "img/Lkopfoto.jpg" "$ORIG/UW3902-minim/img"

echo "=== UW3903 ==="
# Space in filename — use exact match
unzip -p "$FULL/UW3903/UW 39_3.zip" "img/LoepGeschiedenis_coverfoto 3903 kleiner.jpg" \
  > "$ORIG/UW3903-minim/img/LoepGeschiedenis_coverfoto 3903 kleiner.jpg" && \
  echo "  ✓ LoepGeschiedenis_coverfoto 3903 kleiner.jpg" || \
  echo "  ✗ NIET GEVONDEN"

echo "=== UW3904 ==="
extract_file "$FULL/UW3904/UW3904.zip" "img/geogebrascherm.png" "$ORIG/UW3904-minim/img"

echo "=== UW4001 ==="
extract_file "$FULL/UW4001/UW 40_1.zip" "img/verkiezingen.jpg" "$ORIG/UW4001-minim/img"

echo "=== UW4002 ==="
extract_file "$FULL/UW4002/UW4002.zip" "img/coverUW4002.jpg" "$ORIG/UW4002-minim/img"

echo "=== UW4004 ==="
extract_file "$FULL/UW4004/UW4004.zip" "img/bannerdeterminant.jpg" "$ORIG/UW4004-minim/img"

echo "=== UW4101 ==="
# 1-1 Boom.jpeg has spaces and dashes — use exact match
unzip -p "$FULL/UW4101/UW4101.zip" "img/1-1 Boom.jpeg" \
  > "$ORIG/UW4101-minim/img/1-1 Boom.jpeg" && \
  echo "  ✓ 1-1 Boom.jpeg" || \
  echo "  ✗ NIET GEVONDEN: 1-1 Boom.jpeg"
extract_file "$FULL/UW4101/UW4101.zip" "img/bayesboomtikztje.tex" "$ORIG/UW4101-minim/img"

echo "=== UW4102 ==="
extract_file "$FULL/UW4102/UW4102.zip" "img/LOEP_pythonbanner.jpeg" "$ORIG/UW4102-minim/img"
# Extract all python source files
extract_dir "$FULL/UW4102/UW4102.zip" "python" "$ORIG/UW4102-minim/python"

echo "=== UW4103 ==="
extract_file "$FULL/UW4103/UW4103.zip" "img/Lspeltheorie_bannerspeltheorie.jpg" "$ORIG/UW4103-minim/img"

echo "=== UW4104 ==="
extract_file "$FULL/UW4104/UW4104.zip" "img/loep_letters.jpg" "$ORIG/UW4104-minim/img"

echo ""
echo "Klaar. Controleer de ✗-regels voor nog ontbrekende bestanden."
