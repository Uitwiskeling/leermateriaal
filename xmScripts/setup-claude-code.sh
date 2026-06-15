#!/bin/bash
#
# Setup-script voor Claude Code cloud-sessies (web/desktop-app, "Claude Code on the web").
#
# Waarom dit nodig is:
#   De normale Ximera-workflow draait in een Docker-container
#   (ghcr.io/ximeraproject/ximeralatex:v2.7.8-full), maar in de Claude
#   cloud-omgeving kunnen Docker-image-blobs NIET gedownload worden
#   (pkg-containers.githubusercontent.com en production.cloudflare.docker.com
#   worden door de netwerkpolicy geblokkeerd; ghcr.io zelf werkt wel, waardoor
#   'docker pull' pas faalt bij de blobs).
#
#   Daarom bouwen we de inhoud van die container hier 'native' na:
#   TeX Live via apt + ximeraLatex (cls/luaxake/xmlatex) via GitHub.
#
# Gebruik:
#   - Eenmalig per sessie/container draaien vanuit de repo-root:
#       bash xmScripts/setup-claude-code.sh
#     (let op het pad 'xmScripts/' — zonder dat pad krijg je "file not found").
#   - Of, aanbevolen, als setup-script van de Claude-omgeving instellen, zodat het
#     automatisch draait bij de start van elke sessie. Zet dan exact dit in het
#     veld "Setup script" (het draait als root vanuit de repo-root):
#       bash xmScripts/setup-claude-code.sh
#     Zie https://code.claude.com/docs/en/claude-code-on-the-web
#   Duurt ca. 5-10 minuten (TeX Live-installatie); het script is idempotent en
#     bestand tegen kapotte third-party apt-bronnen en korte netwerkhaperingen.
#
# Daarna compileren zoals in de container, bv.:
#   xmlatex bake -s --nodependencies --force --compile pdf UW4201/vectorruimten_definieren.tex
#   xmlatex bake -s --nodependencies --force --compile html UW4201/vectorruimten_definieren.tex
#
set -euo pipefail

XIMERA_VERSION=v2.7.8   # houd dit gelijk met XAKE_VERSION in xmScripts/config.txt
TEXMF_XIMERA=/root/texmf/tex/latex/ximeraLatex

log() { echo "=== [setup-claude-code] $*"; }

if [[ $(id -u) -ne 0 ]]; then
    echo "Dit script verwacht root (zoals in de Claude cloud-omgeving)."; exit 1
fi

# Probeer een commando enkele keren met oplopende wachttijd (tegen netwerkhaperingen).
retry() {
    local n=0 max=4 delay=2
    until "$@"; do
        n=$((n+1))
        if [[ $n -ge $max ]]; then
            log "Commando bleef falen na $max pogingen: $*"
            return 1
        fi
        log "Poging $n/$max mislukt; opnieuw over ${delay}s: $*"
        sleep "$delay"; delay=$((delay*2))
    done
}

# 1. TeX Live + hulpprogramma's (zoals in docker/Dockerfile.full van ximeraLatex)
if ! command -v pdflatex >/dev/null || ! command -v make4ht >/dev/null; then
    log "TeX Live installeren via apt (duurt enkele minuten)..."

    # De Claude-cloudimage bevat soms third-party PPA's (bv. deadsnakes, ondrej/php)
    # die 403 Forbidden geven. Onder 'set -e' breekt 'apt-get update' daar volledig op
    # af, terwijl de Ubuntu-archieven zelf prima bereikbaar zijn. We schakelen daarom
    # alle niet-Ubuntu apt-bronnen tijdelijk uit en herstellen ze achteraf.
    disabled_sources=()
    shopt -s nullglob
    for f in /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
        case "$f" in
            */ubuntu.sources) ;;  # officiële Ubuntu-archieven houden we
            *) mv "$f" "$f.disabled" && disabled_sources+=("$f") ;;
        esac
    done
    shopt -u nullglob
    restore_sources() {
        local f
        for f in "${disabled_sources[@]:-}"; do
            [[ -e "$f.disabled" ]] && mv "$f.disabled" "$f"
        done
    }
    trap restore_sources EXIT
    if ((${#disabled_sources[@]})); then
        log "Niet-Ubuntu apt-bronnen tijdelijk uitgeschakeld: ${disabled_sources[*]}"
    fi

    retry apt-get update -q
    DEBIAN_FRONTEND=noninteractive retry apt-get install -y -q \
        texlive-latex-extra texlive-science texlive-lang-european \
        texlive-luatex texlive-fonts-recommended texlive-fonts-extra \
        texlive-extra-utils tex4ht texlive-plain-generic \
        mupdf-tools poppler-utils pdf2svg imagemagick jq git-restore-mtime dos2unix
        # poppler-utils (pdftoppm) laat Claude PDF's als beeld inlezen — handig om
        # oude bron en Ximera-conversie visueel te vergelijken (zie TOBECONVERTED/).

    restore_sources
    trap - EXIT
else
    log "TeX Live al aanwezig, sla apt-installatie over."
fi

# 2. ximeraLatex (ximera.cls, xourse.cls, luaxake, volledige xmlatex) op de juiste tag
if [[ ! -d "$TEXMF_XIMERA" ]]; then
    log "ximeraLatex $XIMERA_VERSION clonen..."
    mkdir -p /root/texmf/tex/latex
    retry git clone --depth 1 --branch "$XIMERA_VERSION" https://github.com/XimeraProject/ximeraLatex.git "$TEXMF_XIMERA"
else
    log "ximeraLatex al aanwezig."
fi

# 3. Nieuwere LuaXML: de Ubuntu-TeXLive-versie mist luaxml-mod-html.lua (nodig voor luaxake)
if ! kpsewhich luaxml-mod-html.lua >/dev/null 2>&1; then
    log "LuaXML (recent) installeren vanaf GitHub..."
    rm -rf /tmp/LuaXML
    retry git clone --depth 1 https://github.com/michal-h21/LuaXML.git /tmp/LuaXML
    mkdir -p /root/texmf/scripts/luaxml
    cp /tmp/LuaXML/luaxml-*.lua /root/texmf/scripts/luaxml/
fi

# 4. Nieuwere babel: ximera.cls v2.7.8 gebruikt \localename, dat in babel<=24.1 nog
#    een foutmelding-stub is ("Find an armchair..."). TL2024 in de officiële container
#    heeft een nieuwere babel; we halen die van GitHub en zetten ze vooraan in TEXMFHOME.
if [[ ! -f /root/texmf/tex/generic/babel-latest/babel.sty ]]; then
    log "babel (recent) bouwen vanaf GitHub..."
    rm -rf /tmp/babel
    retry git clone --depth 1 https://github.com/latex3/babel.git /tmp/babel
    ( cd /tmp/babel && pdflatex -interaction=batchmode babel.ins >/dev/null 2>&1 || true )
    mkdir -p /root/texmf/tex/generic/babel-latest
    cp /tmp/babel/babel.sty /tmp/babel/babel.def /tmp/babel/switch.def \
       /tmp/babel/txtbabel.def /tmp/babel/luababel.def /tmp/babel/xebabel.def \
       /tmp/babel/errbabel.def /tmp/babel/plain.def \
       /root/texmf/tex/generic/babel-latest/
fi
mktexlsr /root/texmf >/dev/null 2>&1 || true

# 5. Symlinks zoals in de container + /.dockerenv-marker zodat xmlatex/luaxake
#    NIET proberen zichzelf in Docker te herstarten
ln -sf "$TEXMF_XIMERA/luaxake/luaxake"   /usr/local/bin/luaxake
ln -sf "$TEXMF_XIMERA/xmScripts/xmlatex" /usr/local/bin/xmlatex
touch /.dockerenv

# 6. Controle
log "Controle:"
kpsewhich ximera.cls          || { echo "FOUT: ximera.cls niet gevonden"; exit 1; }
kpsewhich luaxml-mod-html.lua || { echo "FOUT: luaxml-mod-html.lua niet gevonden"; exit 1; }
command -v xmlatex make4ht pdflatex >/dev/null || { echo "FOUT: tools ontbreken"; exit 1; }
log "Klaar! Compileer met bv.:"
log "  xmlatex bake -s --nodependencies --force --compile pdf UW4201/vectorruimten_definieren.tex"
