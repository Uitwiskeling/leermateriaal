# Compileren naar PDF en HTML

Dit project gebruikt [Ximera](https://ximera.osu.edu/) (versie **v2.7.8**, zie
`xmScripts/config.txt`): uit één `.tex`-bron komt zowel een printbare PDF als een
online HTML-pagina. De build gebeurt door `luaxake`, aangestuurd via het
`xmlatex`-script.

## De commando's (overal hetzelfde)

```bash
# PDF van één bestand
xmlatex bake -s --nodependencies --force --compile pdf UW4201/vectorruimten_definieren.tex

# HTML van één bestand
xmlatex bake -s --nodependencies --force --compile html UW4201/vectorruimten_definieren.tex

# Alles (pdf + html van alle bestanden, met dependency-checking)
xmlatex bake
```

Output komt naast de bron te staan: `bestand.pdf`, `bestand.html`, `bestand.log`.

**Log lezen bij fouten:** de terminaloutput van `xmlatex` vat fouten samen; de
volledige LaTeX-log staat in `pad/naar/bestand.log`. Zoek naar regels in de vorm
`./bestand.tex:123: ...` (we compileren met `-file-line-error`). Als een compilatie
faalt wordt de (gedeeltelijke) PDF hernoemd naar `bestand.pdf.failed`.

## 1. Claude Code cloud-omgeving (web/desktop-app)

Docker-images kunnen hier **niet** gepulled worden (de netwerkpolicy blokkeert de
blob-hosts van ghcr.io en Docker Hub). Daarom bouwen we de inhoud van de officiële
container native na met `xmScripts/setup-claude-code.sh`:

```bash
bash xmScripts/setup-claude-code.sh   # eenmalig per sessie, ±5-10 min
```

Het script installeert TeX Live via apt, cloont `ximeraLatex@v2.7.8` (met luaxake en
de volledige `xmlatex`) naar `/root/texmf/tex/latex/ximeraLatex`, repareert twee
versie-achterstanden van Ubuntu's TeX Live (LuaXML en babel, beide vanaf GitHub),
maakt symlinks in `/usr/local/bin` en zet `/.dockerenv` zodat `xmlatex` niet probeert
zichzelf in Docker te herstarten. Daarna werken de bovenstaande commando's gewoon.

**Aanrader:** stel dit in als setup-script van de omgeving (zie
https://code.claude.com/docs/en/claude-code-on-the-web), dan staat alles klaar bij de
start van elke sessie.

Claude kan in deze omgeving zowel de logs als de geproduceerde PDF's rechtstreeks
lezen (de Read-tool toont PDF's inclusief layout).

## 2. GitHub Codespaces / VS Code devcontainer

De devcontainer (`.devcontainer/`) start **in** de officiële container
`ghcr.io/ximeraproject/ximeralatex:v2.7.8` — alles is daar voorgeïnstalleerd en
`xmlatex` staat op het PATH. Gebruik:

- de taakknoppen **PDF / HTML / SERVE** in VS Code (zie `.vscode/tasks.json`), of
- dezelfde terminalcommando's als hierboven.

Naast de app-container draait een lokale Ximera-server op poort 2080
(`docker-compose.yml`) om de online versie te bekijken.

Claude Code in een Codespace gebruikt ook gewoon `xmlatex ...` in de terminal —
geen extra setup nodig.

## 3. GitHub Actions (publicatie)

Elke push draait `.github/workflows/serve-ximera.yml`: `./xmScripts/xmlatex ghaction`
bouwt alles in de container en publiceert naar https://leermateriaal.uitwiskeling.be/
(branchnaam wordt deel van de cursusnaam: `uitwiskeling*<branch>`). De GPG-sleutels
staan in de Action Secrets.

## Veelvoorkomende valkuilen

Zie `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` voor de volledige lijst. De belangrijkste:

1. **Nooit** `\input{./preamble.tex}` of `\addPrintStyle{.}` in een document:
   `ximera.cls` v2.7.8 laadt `xmPreamble.tex` en `xmPrintstyle.sty` automatisch
   (dubbel laden geeft honderden "already defined"-fouten).
2. Een los activiteitsbestand moet standalone compileren; commando's die alleen in
   de xourse bestaan horen als default (met `\providecommand`) in `xmPrintstyle.sty`.
3. `docker pull` lijkt in de cloud-omgeving te lukken maar faalt op de blobs —
   controleer altijd de exit code apart, niet via een pipe.
