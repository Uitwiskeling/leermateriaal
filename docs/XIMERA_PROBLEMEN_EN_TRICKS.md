# Ximera: bekende problemen & tricks

Kennisbank voor dit project (ximeraLatex **v2.7.8** + luaxake). Vul aan bij elk nieuw
opgelost probleem: beschrijf het symptoom, de oorzaak en de **structurele** oplossing.
Quick fixes die het onderliggende probleem laten bestaan horen hier niet thuis —
los het op in `xmPreamble.tex`/`xmPrintstyle.sty` of in de bron, niet met een hack per bestand.

Bronnen: git history van dit repo, de sessie van 2026-06-12, en de
[ximeraLatex-documentatie](https://github.com/XimeraProject/ximeraLatex).

## Architectuur in het kort

- `ximera.cls` (en `xourse.cls`, dat `ximera.cls` laadt) laadt op het einde van de klasse
  **automatisch** `xmPreamble.tex` en (alleen voor PDF) `xmPrintstyle.sty` uit de projectroot
  (zoekpad `./`, `../`, ...). Zie `\xmDefaultPreamble` in ximera.cls.
- `luaxake` (aangeroepen via `xmlatex bake`) compileert:
  - **PDF**: `pdflatex -shell-escape -file-line-error`
  - **HTML**: `make4ht -c ximera.cfg -f html5+dvisvgm_hashes ... 'svg,htex4ht,mathjax,-css'`
    → gewone wiskunde wordt MathJax, maar `image`/tikz-omgevingen worden door echte TeX
    gezet en via dvisvgm naar SVG omgezet. **HTML is dus strenger dan PDF**: wat in de PDF
    werkt kan in HTML nog breken.
- Logbestanden: PDF-run → `bestand.log`; HTML-run → `bestand.online.log` (jobname `.online`).
  Fouten zoeken: regels van de vorm `./bestand.tex:123:`.
- Een mislukte PDF wordt hernoemd naar `bestand.pdf.failed`.

## Bekende problemen

### 1. Honderden "Command \... already defined"-fouten
**Oorzaak:** `\input{./preamble.tex}` of `\addPrintStyle{.}` in een document, terwijl
ximera.cls v2.7.8 `xmPreamble.tex`/`xmPrintstyle.sty` al automatisch laadt → alles wordt
dubbel gedefinieerd.
**Oplossing:** die regels gewoon weglaten. (Opgelost in `inleiding.tex` en
`activiteitenvolgensnummer.tex` op 2026-06-12; dit was ook de oorzaak van de gefaalde
GitHub Action run #3.)
**Status preamble.tex/printstyle.sty:** verouderde kopieën; `xmPreamble.tex` is een
superset (op `\usepackage{XCharter}` na, dat al door `xmPrintstyle.sty` met opties wordt
geladen — voeg het dus NIET nogmaals toe, dat geeft een 'option clash'). Kandidaten om
te verwijderen na akkoord van Alexander.

### 2. Losse activiteit faalt op `\uitgavenr` / lege `\includegraphics{}`
**Symptoom:** `Undefined control sequence \uitgavenr` of `File '' not found` bij het
standalone compileren van één activiteit; in een xourse werkt alles wel.
**Oorzaak:** de pagestyle `uitwiskeling` in `xmPrintstyle.sty` gebruikt commando's die
alleen in de xourse gedefinieerd waren.
**Oplossing (toegepast 2026-06-12):** defaults in `xmPrintstyle.sty`
(`\providecommand*{\uitgavenr}{}`, grijze `paginanrbg`/logo-defaults); de xourse
overschrijft met `\renewcommand*`. **Regel:** elke activiteit moet standalone compileren;
xourse-specifieke waarden krijgen altijd een default.

**Vervolg (2026-06-13): default in stylefile is niet genoeg voor de html-build.**
`xmPrintstyle.sty` wordt door ximera.cls **alleen voor pdf** geladen, maar de xourse
doet `\renewcommand*{\uitgavenr}` die in **beide** builds draait. In de html-build was de
default dus nog niet geladen → `Command \uitgavenr undefined` bij
`html|activiteitenvolgensnummer.tex` (pdf werkte wel). **Oplossing:** defaults voor
waarden die de xourse met `\renewcommand*` overschrijft horen in `xmPreamble.tex`
(pdf én html), niet in `xmPrintstyle.sty` (pdf-only). `\uitgavenr`/`\uitgaveseizoen`
verhuisd naar `xmPreamble.tex`. **Regel:** een default die in de html-build nodig is,
hoort in `xmPreamble.tex`; alleen puur typografische pdf-defaults mogen in `xmPrintstyle.sty`.

### 3. HTML-build faalt: `pmatrix` in een tikz-node
**Symptoom:** `Extra \right.`, `Missing $ inserted`, ... in de `.online.log`, op het
moment dat de SVG geschreven wordt (`Writing ....idv`).
**Oorzaak:** `\begin{pmatrix}...\end{pmatrix}` in een node-label van een tikzpicture
breekt in de tex4ht/dvisvgm-fase (PDF werkt wel!).
**Oplossing:** in tikz-nodes `\left(\begin{smallmatrix}...\end{smallmatrix}\right)` of
`\binom{a}{b}` gebruiken (beide getest OK). Buiten figuren is pmatrix prima (MathJax).

### 4. Spaties in bestandsnamen breken de HTML-build
**Symptoom:** make4ht maakt o.a. `simpele.log` van `simpele zandhopen.tex`; html ontbreekt,
en `frost` faalt daarna op het ontbrekende bestand.
**Oplossing:** geen spaties in `.tex`-bestandsnamen; underscores zijn OK voor .tex-bestanden
(`vectorruimten_definieren.tex` werkt al jaren).

### 5. Underscores in afbeeldingsbestandsnamen (bij `\logo` e.d.)
Commit `68610c4 "geen underscore...."`: `\logo{xmPictures/logo_uitwiskeling.png}` brak;
hernoemd naar `logouitwiskeling.png`. Vermijd `_` in namen van afbeeldingen die in
HTML-context verwerkt worden.

### 6. `cases` niet in `\left\{...\right.` wikkelen
Commit `ae06d7b`: `\begin{cases}` zet zelf al de accolade; extra `\left\{ ... \right.`
errond geeft fouten. Idem: geen overbodige `\left.`-constructies rond omgevingen die
zelf delimiters zetten.

### 7. `image` gebruiken in plaats van `figure`
Commit `3f681e6`: Ximera kent geen floats in HTML; gebruik de `image`-omgeving
(uit printstyle: `\begin{image}[breedte] ... \end{image}`), niet `figure`/`\centering`.

### 8. Pakketten die de HTML-structuur breken
Uit commentaar in `xmPreamble.tex`:
- `animate`: **breekt de HTML-structuur** — niet gebruiken.
- `babel` en `doclicense`: alleen binnen `\pdfOnly{...}` laden (geven anders
  syntaxfouten in de gegenereerde `.jax`-bestanden).
- Extra packages toevoegen doe je in `xmPreamble.tex`; check daarna ALTIJD zowel pdf
  als html van een testbestand.

### 9. Omgevingsverschillen (alleen Claude cloud-omgeving)
De native toolchain (zie `xmScripts/setup-claude-cloud.sh`) gebruikt Ubuntu's TeX Live
2023 i.p.v. TL2024 uit de officiële container. Al verholpen in het setup-script:
- LuaXML te oud (geen `luaxml-mod-html.lua`) → recente versie van GitHub in TEXMFHOME.
- babel 24.1 heeft `\localename` nog als foutmelding-stub ("Find an armchair...")
  terwijl ximera.cls het gebruikt → recente babel van GitHub in TEXMFHOME.
Bij een onbegrijpelijke fout hier: controleer eerst of de GitHub Action (officiële
container) hetzelfde doet voor je iets aan het project verandert.

### 10. `docker pull` lijkt te werken maar faalt
In de Claude cloud-omgeving zijn `pkg-containers.githubusercontent.com` en
`production.cloudflare.docker.com` geblokkeerd (`x-deny-reason: host_not_allowed`);
`ghcr.io` zelf antwoordt wél, dus de fout komt pas bij de blobs. Niet blijven proberen:
gebruik de native setup. Check exit codes nooit door een pipe (`| tail` verbergt ze).

### 11. GitHub Action faalt meteen: `XIMERA_NAME contains characters that are not allowed`
**Symptoom:** de Action-stap "Build and publish" stopt vóór de bake met
`ERROR: WARNING: XIMERA_NAME contains characters that are not allowed. Only use [a-z0-9] and .*-`.
**Oorzaak:** `.github/workflows/serve-ximera.yml` zette `XIMERA_NAME: uitwiskeling*${{ github.ref_name }}`.
Een branchnaam met een `/` (zoals `claude/...` of `feature/...`) levert dan een ongeldige naam op;
`main` werkte enkel toevallig. De ximera-publishnaam mag alleen `[a-z0-9]` en `.*-` bevatten
(de `*` is de scheiding tussen repo- en branchdeel).
**Oplossing:** saneer de branchnaam in de workflow vóór gebruik (lowercase + alles wat niet
`[a-z0-9.-]` is vervangen door `-`), en geef `github.ref_name` via een env-var door (niet rechtstreeks
interpoleren) om shell-injectie te vermijden:
`SAFE_REF=$(printf '%s' "$REF_NAME" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9.-' '-')`.

### 12. Defaults die de HTML-build nodig heeft horen in `xmPreamble.tex`, niet in `xmPrintstyle.sty`
**Symptoom:** PDF van een xourse compileert, maar `html|<xourse>.tex` faalt met
`Command \uitgavenr undefined` (zie ook punt 2). Op `main` was dit de laatste overblijvende
CI-fout na het oplossen van alle activiteiten.
**Oorzaak:** ximera.cls laadt `xmPrintstyle.sty` **alleen voor de PDF-build**, maar `xmPreamble.tex`
voor **beide** builds. De default `\providecommand*{\uitgavenr}{}` stond in `xmPrintstyle.sty`,
terwijl de xourse die met `\renewcommand*` overschrijft — en `\renewcommand*` draait in beide builds.
In de html-build bestond het commando dus nog niet → fout.
**Oplossing:** zet defaults voor waarden die in beide builds (her)gedefinieerd worden in
`xmPreamble.tex`. Vuistregel: **`xmPrintstyle.sty` = enkel puur-typografische PDF-defaults;
alles wat de HTML-build ook nodig heeft → `xmPreamble.tex`.**

### 13. CSS/styling van de online versie: welke stylesheet is actief + de twee logo's
**Welke CSS wordt geladen?** Voor dit project wordt enkel **`global.css`** automatisch geladen.
`uitwiskeling.css` en `Vectorruimten.css` staan in de root maar worden (nog) **niet** ingeladen
(daarom is de hoofding blauw zoals in `global.css`, niet roze zoals `Vectorruimten.css` zou zetten).
Pas online-styling dus aan in `global.css`, niet in die losse bestanden (zie ook de TODO in README
om ze samen te voegen/koppelen). Handige selectors in `global.css`:
- `.main-title` (achtergrond van de blauwe titelbalk) en `.toc .part` (de blauwe nummer-rijen in
  de inhoudstafel) — projecthuiskleur hier was `#5d98d2`, nu `#5983c2`.
- `.title-xourse` / `.title-activity` → `text-transform: uppercase` zet titels in kapitalen;
  per selector overschrijven met `text-transform: none` als je een titel in gewone kast wil.
**Twee logo's (het "dubbele logo"-probleem):** in de online hoofding staan twee afbeeldingen:
- `img.brandlogo` = **organisatie-logo** (Ximera-server/organisatieniveau). Stond hier zonder
  geldige bron → gebroken afbeelding linksboven.
- `img.xourselogo` = het **xourse-logo** uit `\logo{...}` in de `.tex` (course-niveau).
`uitwiskeling.css` zette al `img.brandlogo { display:none }`, maar omdat die stylesheet niet geladen
wordt kwam het gebroken organisatie-logo terug. **Oplossing:** `img.brandlogo { display:none }` in
`global.css` (de wél geladen stylesheet); zo blijft enkel het Uitwiskeling-`\logo{}` over, links.

## Tricks

- **Snelle foutdiagnose:** `grep -n -m5 ':[0-9]*:' bestand.log` (PDF) of
  `bestand.online.log` (HTML). luaxake crasht soms zelf bij het formatteren van
  fouten (`luaxake-bake.lua:246: attempt to concatenate a nil value (field 'context')`) —
  dat betekent gewoon: er zijn LaTeX-fouten, lees de log rechtstreeks.
- **Strenger testen:** compileer na elke wijziging zowel `--compile pdf` als
  `--compile html`; HTML vangt de meeste structurele problemen.
- **Cache omzeilen:** `--force` hercompileert ook als luaxake denkt dat alles up-to-date
  is; `xmlatex bake` zonder argumenten doet het hele project met dependency-checking.
- **GitHub Action als referentie:** de Action-logs (Ximera Workflow) tonen het gedrag
  van de officiële container; vergelijk daarmee bij twijfel over omgevingsverschillen.
- **`\rubriek{loep}{...}`** zet de kleuren/headers van een Uitwiskeling-rubriek
  (redactioneel, spin, loep, bib, actua); zonder rubriek krijg je grijze defaults.
- **Handout-modus:** `\ifhandout` verbergt `oplossing`-omgevingen in de print;
  online verschijnen ze als uitklapbare "Toon uitwerking".
