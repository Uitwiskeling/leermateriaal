# Claude-instructies voor dit repo

Dit repo zet Uitwiskeling-lesmateriaal (LaTeX) om naar Ximera-pagina's (PDF + HTML).

**Lees eerst:**
1. `CLAUDE_PROGRESS.md` — waar staan we, wat is de TODO. **Werk dit bij na elke stap**
   (sessies kunnen door usage-limieten afgebroken worden; de volgende sessie moet
   meteen verder kunnen).
2. `COMPILING.md` — compileren in deze omgeving. In een verse Claude cloud-sessie eerst
   `bash xmScripts/setup-claude-cloud.sh` draaien (±5-10 min; Docker werkt hier niet).
3. `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` — bekende problemen; vul aan bij elk nieuw
   opgelost probleem.

**Gespecialiseerde agents** (in `.claude/agents/`):
- `ximera-expert` — technische build-/LaTeX-/Ximera-problemen, structurele oplossingen.
- `uitwiskeling-converter` — Uitwiskeling-formaat → Ximera-formaat omzetten
  (handleiding: `docs/CONVERSIE.md`).
- `didactical-review` — PLACEHOLDER (nog in te vullen; didactische review vanuit
  edtech/leertheorieën). Nog niet gebruiken in de workflow.

**Oude bron compileren ter vergelijking:** gooi een Uitwiskeling-tijdschrift-`.zip` in
`TOBECONVERTED/` en draai `bash TOBECONVERTED/compile-old-source.sh` (gewone pdflatex,
geen Ximera). Zo vergelijk je de originele lesactiviteit visueel met de Ximera-conversie.
Zie `TOBECONVERTED/README.md`. Conversie verloopt nooit via Word — altijd LaTeX→LaTeX.

**Harde regels:**
- Geen `\input{./preamble.tex}` of `\addPrintStyle{.}` in documenten (auto-geladen door
  ximera.cls v2.7.8). `preamble.tex`/`printstyle.sty` zijn verouderde kopieën.
- Elke activiteit moet standalone compileren (pdf én html) vóór je commit.
- Structurele oplossingen, geen quick fixes per bestand.
- Geen spaties in .tex-bestandsnamen; geen underscores in afbeeldingsnamen.
- Werken op de afgesproken branch; gegenereerde output (pdf/html/aux/...) niet committen.
