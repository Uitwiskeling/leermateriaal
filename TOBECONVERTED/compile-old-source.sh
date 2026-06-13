#!/bin/bash
#
# compile-old-source.sh — compileer een Uitwiskeling-bronbestand (OUD formaat,
# tijdschrift-LaTeX met \begin{vraagenantwoord} enz.) naar PDF, zodat je de
# originele lesactiviteiten visueel kan vergelijken met hun Ximera-conversie.
# Dit is onze "unit test" voor conversies: oude PDF naast nieuwe Ximera-PDF.
#
# Het OUDE formaat gebruikt \documentclass{book} + uitwiskeling-style.sty en
# compileert met gewone pdflatex (GEEN ximera/docker/luaxake nodig).
#
# Gebruik:
#   bash TOBECONVERTED/compile-old-source.sh                # nieuwste .zip in TOBECONVERTED/
#   bash TOBECONVERTED/compile-old-source.sh pad/naar/UW4203.zip
#   bash TOBECONVERTED/compile-old-source.sh TOBECONVERTED/_work/UW4203   # al uitgepakte map
#
# Werkwijze:
#   - pakt de .zip uit in TOBECONVERTED/_work/<naam>/ (gitignored, tijdelijk)
#   - zoekt het masterbestand (een .tex met \documentclass) — meestal Uitwiskeling.tex
#   - draait pdflatex 2x (TikZ-hoofdingen hebben 2 passes nodig)
#   - meldt het pad van de gegenereerde PDF
#
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR/_work"
mkdir -p "$WORK_DIR"

log() { echo "=== [compile-old-source] $*"; }
err() { echo "FOUT: $*" >&2; }

# ---- 1. Bepaal de bronmap (uitpakken indien een zip is opgegeven) -----------
INPUT="${1:-}"

if [[ -z "$INPUT" ]]; then
    # Geen argument: neem de nieuwste .zip in TOBECONVERTED/
    INPUT="$(ls -t "$SCRIPT_DIR"/*.zip 2>/dev/null | head -1)"
    [[ -z "$INPUT" ]] && { err "Geen .zip opgegeven en geen .zip gevonden in $SCRIPT_DIR/. Zet een .zip in TOBECONVERTED/ of geef een pad mee."; exit 1; }
    log "Geen argument; gebruik nieuwste zip: $INPUT"
fi

if [[ -d "$INPUT" ]]; then
    SRC_ROOT="$INPUT"
    log "Map opgegeven: $SRC_ROOT"
elif [[ -f "$INPUT" && "$INPUT" == *.zip ]]; then
    name="$(basename "$INPUT" .zip)"
    SRC_ROOT="$WORK_DIR/$name"
    rm -rf "$SRC_ROOT"
    mkdir -p "$SRC_ROOT"
    log "Uitpakken van $INPUT naar $SRC_ROOT ..."
    unzip -q "$INPUT" -d "$SRC_ROOT" || { err "Uitpakken mislukt."; exit 1; }
else
    err "Onbekende invoer: $INPUT (verwacht een .zip of een map)."; exit 1
fi

# ---- 2. Vind het masterbestand (.tex met \documentclass) -------------------
# Eerst kijken naar het conventionele Uitwiskeling.tex, anders elke .tex met \documentclass.
MASTER=""
while IFS= read -r f; do
    if grep -q '\\documentclass' "$f"; then MASTER="$f"; break; fi
done < <(find "$SRC_ROOT" -name 'Uitwiskeling.tex')

if [[ -z "$MASTER" ]]; then
    while IFS= read -r f; do
        if grep -q '\\documentclass' "$f"; then MASTER="$f"; break; fi
    done < <(find "$SRC_ROOT" -name '*.tex' | sort)
fi

[[ -z "$MASTER" ]] && { err "Geen masterbestand met \\documentclass gevonden onder $SRC_ROOT."; exit 1; }

MASTER_DIR="$(cd "$(dirname "$MASTER")" && pwd)"
MASTER_FILE="$(basename "$MASTER")"
log "Masterbestand: $MASTER_DIR/$MASTER_FILE"

# ---- 3. Compileren (2 passes voor TikZ-hoofdingen) -------------------------
command -v pdflatex >/dev/null 2>&1 || { err "pdflatex niet gevonden. Draai eerst: bash xmScripts/setup-claude-cloud.sh"; exit 1; }

run_pdflatex() {
    ( cd "$MASTER_DIR" && pdflatex -interaction=nonstopmode -file-line-error "$MASTER_FILE" ) >/dev/null 2>&1
}

log "pdflatex pass 1/2 ..."
run_pdflatex
log "pdflatex pass 2/2 ..."
run_pdflatex
STATUS=$?

PDF="$MASTER_DIR/${MASTER_FILE%.tex}.pdf"
LOG="$MASTER_DIR/${MASTER_FILE%.tex}.log"

# ---- 4. Resultaat ----------------------------------------------------------
if [[ -f "$PDF" ]]; then
    pages="$(command -v mutool >/dev/null 2>&1 && mutool info "$PDF" 2>/dev/null | sed -n 's/^Pages: //p')"
    if [[ -n "$pages" ]]; then
        log "KLAAR. PDF: $PDF ($pages pagina)"
    else
        log "KLAAR. PDF: $PDF"
    fi
    nerr="$(grep -cE ':[0-9]+:|^!' "$LOG" 2>/dev/null)"; nerr="${nerr:-0}"
    [[ "$nerr" =~ ^[0-9]+$ && "$nerr" -gt 0 ]] && log "Let op: $nerr mogelijke fout(regel)(s) in de log; bekijk $LOG"
    echo "$PDF"
else
    err "Geen PDF geproduceerd. Bekijk de log: $LOG"
    grep -m10 -E ':[0-9]+:|^!' "$LOG" 2>/dev/null
    exit 1
fi
