# Claude session progress & TODO

> Doel van dit bestand: elke Claude-sessie up-to-date houden over wat er al gebeurd is
> en wat nog moet gebeuren. **Werk dit bestand bij na elke afgeronde stap.**

## Context van het project
- Repo zet Uitwiskeling-lesmateriaal (LaTeX) om naar Ximera-pagina's (PDF + HTML).
- `UW4202/simpele_zandhopen.tex` = bron in **Uitwiskeling-formaat** (inhoud staat in
  `%`-comments, nog te converteren).
- `UW4201/*.tex` = voorbeelden van al geconverteerd **Ximera-formaat**.
- `activiteitenvolgensnummer.tex` = de xourse die alles bundelt.
- Werkbranch: `claude/focused-dirac-x12mr3`.
- Documentatie: `COMPILING.md` (compileren), `docs/CONVERSIE.md` (conversiehandleiding),
  `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` (kennisbank), `CLAUDE.md` (instructies),
  agents in `.claude/agents/` (`ximera-expert`, `uitwiskeling-converter`).

## TODO
- [x] Compilatie (pdf + html) werkend krijgen in de Claude cloud-omgeving — `xmScripts/setup-claude-code.sh`
- [x] Compilatie in GitHub Codespaces gedocumenteerd (devcontainer = officiële container, werkt out of the box)
- [x] Compilatie effectief getest: pdf + html van alle bestanden, logs en pdf's gelezen
- [x] Structurele bugs gefixt waardoor zelfs de GitHub Action faalde (zie log hieronder)
- [x] Agent `ximera-expert` aangemaakt
- [x] Agent `uitwiskeling-converter` aangemaakt
- [x] `docs/CONVERSIE.md` geschreven
- [x] `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` geschreven (uit git history + sessiebevindingen)
- [ ] **VOLGENDE STAP:** UW4202 `simpele_zandhopen` effectief converteren met de
      `uitwiskeling-converter` agent (inhoud staat klaar in comments; figuren deels in
      `UW4202/img/`, sommige verwijzen naar `UW4201/img/`-paden die niet bestaan — checken!)
- [ ] GitHub Action opnieuw laten draaien na merge en controleren dat hij groen wordt
- [ ] Beslissing Alexander: `preamble.tex` en `printstyle.sty` verwijderen?
      (verouderde kopieën; xmPreamble/xmPrintstyle zijn de echte; zie tricks-doc #1)
- [ ] Beslissing Alexander: leerkrachtenadvies → `instructorNotes` of weglaten + verwijzen naar artikel?
- [ ] Beslissing Alexander: bronnen/referenties integreren of enkel artikellink?
- [ ] (optioneel) Cloud-setup cachebaar maken: nu draait `setup-claude-code.sh` via de
      SessionStart-hook (één bron van waarheid, maar ~5-10 min op elke verse, niet-gecachte
      sessie). Alternatief: de install **inline** in het "Setup script"-veld van de omgeving
      zetten — dan wordt het filesystem gesnapshot/gecached (instant na de eerste keer) en is
      het clone-order-proof. Nadeel: dupliceert de scriptlogica (driftrisico) en de install
      schuurt tegen de ~5-min cache-budgetlimiet. Alleen doen als de opstartvertraging hindert.
- [ ] (later) uitwiskeling.css en Vectorruimten.css mergen (README-TODO)
- [ ] (later) inleiding.tex linkt naar ximera.osu.edu en uitwiskeling.be-artikel; nazien
      of de cursus-URL https://leermateriaal.uitwiskeling.be/ klopt na eerste publish

## Wat is er gedaan (log, nieuwste bovenaan)

### 2026-06-13 (sessie 2)
- **GitHub-push werkt nu** (branch `claude/focused-dirac-x12mr3`); de GitHub App kreeg
  schrijfrechten. Commit-auteur = `Claude <noreply@anthropic.com>`.
- **`.claude/settings.json` aangepast:** SessionStart-hook verwijderd (op verzoek),
  en de permissies `Bash(bash xmScripts/setup-claude-code.sh)` + `git branch` weg.
  De setup-toolchain draai je dus zelf bij een verse cloud-sessie:
  `bash xmScripts/setup-claude-code.sh`.
- **`ximera-expert` agent uitgebreid** met documentatie-links (osu.edu/kuleuven.be zijn
  in de cloud-omgeving geblokkeerd; github werkt) + "offline essentials" (interactieve
  Ximera-elementen, self-hosting/Overleaf-pointers).
- **Conversie-skill verfijnd** met de échte tijdschriftbron (`voorbeeld.tex` uit de zip):
  `docs/CONVERSIE.md` heeft nu de volledige omzettingstabel (artikel, afbeeldingtotrand,
  kader, citaat, tabel, bronnen, ...), de nesting-regels van het oude formaat, en een
  sectie **veelvoorkomende valkuilen** (wiskunde niet in math-modus, afgeleide-accenten,
  figuren wel in img/ maar niet in tekst, ontbrekende captions, dode `\autoref`).
  `uitwiskeling-converter` agent verwijst nu naar `voorbeeld.tex` en de unit-test.
- **`TOBECONVERTED/` opgezet (unit test voor conversies):** `compile-old-source.sh` pakt
  een Uitwiskeling-tijdschrift-`.zip` uit in `TOBECONVERTED/_work/` (gitignored) en
  compileert de oude bron met gewone `pdflatex` (2 passes). **Getest met UW4203.zip →
  Uitwiskeling.pdf, 23 pagina's, 0 fouten.** Zo vergelijk je origineel vs. Ximera-versie.
  `_work/` en `*.zip` staan in `.gitignore`.
- **`poppler-utils` toegevoegd** aan `setup-claude-code.sh` (pdftoppm; laat Claude PDF's
  als beeld inlezen voor de visuele vergelijking).
- **`didactical-review` agent als placeholder** aangemaakt (`.claude/agents/`); leeg op een
  notitie na dat we meerdere agents per didactisch perspectief voorzien. README-TODO erbij.
- Belangrijk inzicht uit het oude tijdschriftrepo (`.claude/` in de zip): hun workflow
  was Word→LaTeX (pandoc) + layout; **dat doen wij hier NIET** — wij doen alleen
  LaTeX(Uitwiskeling)→LaTeX(Ximera). Hun nesting-regels en `voorbeeld.tex` zijn wel nuttig.

### 2026-06-12 (sessie 1)
**Omgeving werkend gekregen (Claude cloud):**
- Docker-route faalt structureel: netwerkpolicy blokkeert image-blob-hosts
  (`pkg-containers.githubusercontent.com`, `production.cloudflare.docker.com`) met
  `x-deny-reason: host_not_allowed`. ghcr.io zelf werkt → pull faalt pas bij blobs.
- Native toolchain gebouwd (= inhoud van de officiële container): TeX Live via apt,
  ximeraLatex v2.7.8 + luaxake + volledige xmlatex via GitHub-clone in
  `/root/texmf/tex/latex/ximeraLatex`, symlinks in /usr/local/bin, `touch /.dockerenv`.
  Twee Ubuntu-TeXLive-achterstanden gefixt: LuaXML (luaxml-mod-html.lua ontbrak) en
  babel (\localename-stub) — beide met recente versies van GitHub in TEXMFHOME.
- Alles geautomatiseerd in **`xmScripts/setup-claude-code.sh`** (idempotent, ±5-10 min).

**Structurele projectbugs gefixt (dezelfde fouten lieten ook GH Action run #3 falen):**
1. Dubbel preamble-laden: `\input{./preamble.tex}` + `\addPrintStyle{.}` verwijderd uit
   `inleiding.tex` en `activiteitenvolgensnummer.tex` (ximera.cls laadt xmPreamble/
   xmPrintstyle automatisch). Beantwoordt de README-vraag over preambule-integratie.
2. Standalone activiteiten faalden op xourse-commando's: defaults toegevoegd in
   `xmPrintstyle.sty` (`\providecommand*{\uitgavenr}{}`, `\uitgaveseizoen`, grijze
   `rubriekpagenrbg`/`rubriekheaderimg`); xourse gebruikt nu `\renewcommand*`.
3. `pmatrix` in tikz-nodes breekt de HTML-build: vervangen door
   `\left(\begin{smallmatrix}...\end{smallmatrix}\right)` in
   `UW4201/lineairecombinatie_voortbrengendedelen.tex` (met minimaal testbestand bewezen).
4. `UW4202/simpele zandhopen.tex` → `simpele_zandhopen.tex` (spatie brak make4ht en
   daardoor ook `frost` in de Action).

**Eindstand build:** `xmlatex bake --force` → alle 7 documenten compileren naar pdf én
html zonder fouten; daarna `xmlatex bake` → "No files need compiling".

**Aangemaakt:** CLAUDE.md, COMPILING.md, docs/CONVERSIE.md,
docs/XIMERA_PROBLEMEN_EN_TRICKS.md, .claude/agents/ximera-expert.md,
.claude/agents/uitwiskeling-converter.md, xmScripts/setup-claude-code.sh.

## Aandachtspunten voor volgende sessie
- Verse cloud-sessie = kale container: eerst `bash xmScripts/setup-claude-cloud.sh`.
- De zandhopen-bron verwijst naar figuren als `UW4201/img/Lrusthoek` die mogelijk niet
  in het repo zitten (img-map van UW4202 heeft andere namen) — inventariseer vóór de
  conversie welke figuren ontbreken en meld dat aan Alexander.
- GH Action gebruikt een cache; eerste run na deze fixes kan nog stale output bevatten
  (`--force` zit niet in de workflow). Bij rare Action-resultaten: cache wissen.
