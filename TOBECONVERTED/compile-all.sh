#!/usr/bin/env bash
# Compile all 28 UWXXYY numbers and write a per-file error summary.
# Run from TOBECONVERTED/:  bash compile-all.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

LOGDIR="_compilelogs"
PDFDIR="OUTPUTTEDPDFS"
mkdir -p "$LOGDIR" "$PDFDIR"

NUMBERS=(
  UW3501 UW3502 UW3503 UW3504
  UW3601 UW3602 UW3603 UW3604
  UW3701 UW3702 UW3703 UW3704
  UW3801 UW3802 UW3803 UW3804
  UW3901 UW3902 UW3903 UW3904
  UW4001 UW4002 UW4003 UW4004
  UW4101 UW4102 UW4103 UW4104
)

SUMMARY="$LOGDIR/SUMMARY.md"
echo "# Compilatieoverzicht — $(date '+%Y-%m-%d %H:%M')" > "$SUMMARY"
echo "" >> "$SUMMARY"
echo "| Nummer | Status | Eerste fout(en) |" >> "$SUMMARY"
echo "|--------|--------|-----------------|" >> "$SUMMARY"

DETAILS=""

for id in "${NUMBERS[@]}"; do
  echo -n "Compiling $id ... "
  logfile="$LOGDIR/${id}.log"

  # UW4102 references python/*.py relative to TOBECONVERTED/; create symlink for compile
  if [ "$id" = "UW4102" ]; then
    ln -sfn "originals/UW4102-minim/python" python 2>/dev/null || true
  fi

  pdflatex \
    -interaction=nonstopmode \
    -jobname="$id" \
    -output-directory="$LOGDIR" \
    "\def\uwid{${id}}\input{Uitwiskeling}" \
    > "$logfile" 2>&1
  rc=$?

  # Collect ! error lines from log
  errs=$(grep "^!" "$logfile" | sort -u | head -8 || true)

  if [ $rc -eq 0 ] && [ -z "$errs" ]; then
    echo "OK"
    echo "| $id | ✅ OK | — |" >> "$SUMMARY"
    mv "$LOGDIR/${id}.pdf" "$PDFDIR/${id}.pdf" 2>/dev/null || true
  elif [ -z "$errs" ]; then
    # Non-zero exit but no ! lines — grab last error hint
    errs=$(grep -i "error" "$logfile" | grep -v "^Output" | head -3 || true)
    echo "FOUT (rc=$rc)"
    first=$(echo "$errs" | head -1 | cut -c1-90 | sed 's/|/\\|/g')
    echo "| $id | ❌ Fout | \`${first}\` |" >> "$SUMMARY"
    DETAILS="$DETAILS\n\n## $id — FOUT (rc=$rc)\n\`\`\`\n${errs}\n\`\`\`\nLog: \`$logfile\`"
  else
    echo "FOUT"
    first=$(echo "$errs" | head -1 | cut -c1-90 | sed 's/|/\\|/g')
    echo "| $id | ❌ Fout | \`${first}\` |" >> "$SUMMARY"
    DETAILS="$DETAILS\n\n## $id — FOUT\n\`\`\`\n${errs}\n\`\`\`\nLog: \`$logfile\`"
  fi
done

# Append details section
echo "" >> "$SUMMARY"
echo "" >> "$SUMMARY"
printf "%b" "$DETAILS" >> "$SUMMARY"
echo ""
echo "Samenvatting geschreven naar $LOGDIR/SUMMARY.md"
