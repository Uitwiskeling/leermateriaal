# TOBECONVERTED — oude bron compileren om conversies te vergelijken

Deze map dient om **lesmateriaal in het oude Uitwiskeling-tijdschriftformaat** te
compileren (LaTeX met `\begin{lesactiviteit}`, `\begin{vraagenantwoord}`,
`\vraag{}`, `\antwoord{}`, ...), zodat je de originele lesactiviteiten **visueel
kan vergelijken** met hun nieuwe Ximera-versie. Dit is onze "unit test" voor
conversies: de oude PDF naast de nieuwe Ximera-PDF leggen.

Het oude formaat gebruikt `\documentclass{book}` + `uitwiskeling-style.sty` en
compileert met **gewone `pdflatex`** — geen Ximera, docker of luaxake nodig.
(De nieuwe Ximera-activiteiten compileer je zoals altijd met `xmlatex`, zie
`../COMPILING.md`.)

## Werkwijze

1. Gooi een bron-`.zip` in deze map. Verwachte inhoud (zoals het Uitwiskeling-
   tijdschriftrepo aanlevert): een `Uitwiskeling.tex` (master), de artikel-`.tex`'s
   (bv. `LOEPfuncties.tex`), `uitwiskeling-style.sty`, en de mappen `img/`,
   `imgDesign/`, `tekeningenKurt/`. Een top-level map in de zip (bv. `UW4203/`)
   is geen probleem; het script zoekt zelf het masterbestand.

2. Compileer:
   ```bash
   bash TOBECONVERTED/compile-old-source.sh                 # nieuwste .zip in deze map
   bash TOBECONVERTED/compile-old-source.sh TOBECONVERTED/UW4203.zip   # specifieke zip
   bash TOBECONVERTED/compile-old-source.sh TOBECONVERTED/_work/UW4203 # al uitgepakte map
   ```
   De zip wordt uitgepakt in `TOBECONVERTED/_work/<naam>/` (tijdelijk, gitignored),
   het masterbestand (een `.tex` met `\documentclass`) wordt gezocht en 2x met
   `pdflatex` gecompileerd (TikZ-hoofdingen hebben 2 passes nodig). Het script
   print het pad van de gegenereerde PDF.

3. Vergelijk: open die PDF naast de Ximera-PDF van je conversie
   (`UW42xx/<activiteit>.pdf`, gemaakt met `xmlatex bake ... --compile pdf`).
   Claude kan beide PDF's rechtstreeks inlezen met de Read-tool (vereist
   `poppler-utils`; zit in `xmScripts/setup-claude-code.sh`).

## Wat wordt niet gecommit

`_work/` (uitgepakte bronnen) en `*.zip` (vaak groot) staan in `.gitignore`.
Alleen dit `README.md` en `compile-old-source.sh` horen in git. Zo blijft het
repo schoon terwijl je elke bron-zip kan binnengooien en testen.

## Voor de conversie zelf

Zie `../docs/CONVERSIE.md` (omzettingstabel oud → Ximera) en de agent
`uitwiskeling-converter`. Dit mapje gaat enkel over het *compileren van de oude
bron* ter vergelijking, niet over de conversie zelf.

## ALREADY DONE THINGS

# ZIP-map: Uitwiskeling-bronarchief → UWXXYY-minim/

## Wat er al gedaan is

- Alle ZIPs hernoemd naar `UWXXYY.zip` formaat (XX = jaargang 35–42, YY = 01–04)
- Alle 28 ZIPs uitgepakt naar gelijknamige map (`UW3501/`, `UW3502/`, …)
- **Aangemaakt en gevuld (loep .tex + exact de gerefereerde mediabestanden):**
  - `UW3501-minim/` — loep.tex + loepElsVE + loepHilde + loepHildeb + afbeeldingen
  - `UW3502-minim/` — loep3502.tex, 47× figurenAuteur, 3× tekeningenKurt (50 files)
  - `UW3503-minim/` — loep.tex, 20× figurenAuteur, 2× tekeningenKurt (23 files)
  - `UW3504-minim/` — loep.tex, 24× figurenAuteur, 4× tekeningenKurt (29 files)
  - `UW3601-minim/` — Leerstegraadsfuncties.tex, 46× figurenAuteur, 2× tekeningenKurt (49 files)
  - `UW3602-minim/` — Lgrafen.tex, 82× figurenAuteur, 4× tekeningenKurt (87 files)
  - `UW3603-minim/` — Ldimensies.tex, 37× figurenAuteur, 3× tekeningenKurt (41 files)
  - `UW3604-minim/` — 3604L.tex, 11× figurenAuteur, 2× tekeningenKurt (14 files)
  - `UW3701-minim/` — 3701L.tex, 30× figurenAuteur, 3× tekeningenKurt (34 files)
  - `UW3702-minim/` — loep.tex, 23× figurenAuteur, 3× tekeningenKurt (27 files)
  - `UW3703-minim/` — loep.tex, 30× figurenAuteur, 1× tekeningenKurt (32 files)
  - `UW3704-minim/` — Llinprog.tex, 34× figurenAuteur, 3× tekeningenKurt (38 files)
  - `UW3801-minim/` — onderdeloep.tex, 27× img/, 3× tekeningenKurt (31 files)
  - `UW3802-minim/` — L3802krommen.tex, 50× img/, 3× tekeningenKurt (54 files)
  - `UW3803-minim/` — L3803.tex, 24× img/, 2× tekeningenKurt (27 files)
  - `UW3804-minim/` — Lgroepen.tex, 40× img/ (incl. 1× .ggb), 2× tekeningenKurt (43 files)
  - `UW3901-minim/` — onderdeloep.tex, 27× img/, 2× tekeningenKurt (30 files)
  - `UW3902-minim/` — LStatistiek.tex, 17× img/, 3× tekeningenKurt (21 files)
  - `UW3903-minim/` — L3903.tex, 48× img/LoepGeschiedenis/, 3× tekeningenKurt (52 files)
  - `UW3904-minim/` — onderdeloep.tex, 54× img/ (incl. img/matrices/), 2× tekeningenKurt (57 files)
  - `UW4001-minim/` — onderdeloep.tex, 11× img/, 3× tekeningenKurt (15 files)
  - `UW4002-minim/` — loep.tex, 49× img/ (loepMichele/loepJohan/loepEls), 2× tekeningenKurt (52 files)
  - `UW4003-minim/` — LAlgebra.tex, 5× img/LAlgebra/ (nested), 4× tekeningenKurt (10 files)
  - `UW4004-minim/` — onderdeloep.tex, 28× img/, 3× tekeningenKurt (32 files)
  - `UW4101-minim/` — onderdeloep.tex, 15× img/, 2× tekeningenKurt (18 files)
  - `UW4102-minim/` — LOEPpython.tex, 18× img/LOEP/, 2× tekeningenKurt (21 files)
  - `UW4103-minim/` — LOEPSpeltheorie.tex, 10× img/Lspeltheorie/, 2× tekeningenKurt (13 files)
  - `UW4104-minim/` — LOEPvariabelenrol.tex, 15× img/loep/ (incl. .pdf), 3× tekeningenKurt (19 files)
- **Alle 28 minim-mappen zijn aangemaakt en gevuld. Taak voltooid.**

Drie "extra" ZIPs zijn bewust niet hernoemd (duplicaten, niet de hoofdversie):
- `UW 35-4 red spin loep bib.zip`
- `UW3703 loep logica.zip`
- `Uitwiskeling3601 voor het nalezen.zip`

---

## Nog te doen: stap 3–4 voor UW3502 t/m UW4104

Per map in volgorde: **identificeer de loep-bestanden, vind hun afbeeldingen, kopieer naar `UWXXYY-minim/`**.

### Werkwijze per map

**1. Check welke bestanden Uitwiskeling.tex daadwerkelijk `\input`:**
```bash
grep "\\\\input{" UW3502/Uitwiskeling.tex
```
Dit filtert draft-/alternatieve versies meteen uit. Alleen het bestand dat hier vermeld staat is het gepubliceerde loep-artikel.

**2. Bevestig dat het een loep-bestand is (contentkenmerk):**
```bash
grep -l "inhoudstafelLoep\|startcontents\[inhoudloep\]" UW3502/*.tex
```
`preambule_uitwiskeling.tex` en `loepvoorbeeld.tex` matchen ook maar zijn templates — negeren.

**3. Extraheer afbeeldingsreferenties uit het loep-bestand:**
```bash
grep -h "\\\\includegraphics\|\\\\includesvg\|\\\\afbeelding" UW3502/loep3502.tex \
  | grep -oP '[^{}/\\\\]+\.(jpg|JPG|png|PNG|pdf|PDF|svg|SVG|eps|EPS)'
```
Dit pakt bestandsnamen op extensie — vermijdt vals-positieven zoals breedte-opties.

**4. Vind afbeeldingen zonder extensie** (LaTeX laat extensie soms weg):
```bash
grep -h "\\\\includegraphics\|\\\\includesvg\|\\\\afbeelding" UW3502/loep3502.tex \
  | grep -oP '(?<=\{)[^{}./]+(?=\})'
```
Zoek deze dan op via `find UW3502/ -name "STEM.*"`.

**5. Kopieer naar minim-map:**
```bash
mkdir -p UW3502-minim/figurenAuteur UW3502-minim/tekeningenKurt   # pas aan op werkelijke subdirs
cp UW3502/loep3502.tex UW3502-minim/
cp UW3502/figurenAuteur/beeld.jpg UW3502-minim/figurenAuteur/
# … enzovoort per afbeelding
```

### Tips & valkuilen

- **Alleen exact gerefereerde bestanden kopiëren** — nooit een hele submap bulk-kopiëren. figurenAuteur/ bevat veel draft-/alternatieve bestanden die niet in de loep staan.
- **Media is niet alleen jpg/png** — kan ook `.ggb` (GeoGebra), `.svg`, `.eps`, `.mp4`, `.pdf`, etc. zijn. Grep op alle include-commando's, niet op extensie filteren.
- **Commentaarregels negeren** — regels die beginnen met `%` tellen niet mee.
- **`\includegraphics` kan over twee regels gesplitst zijn** (bv. `[width=0.65` op regel 1, `\linewidth]{bestand.jpg}` op regel 2). De bestandsnaam komt dan niet mee met de gewone grep. Controleer bij twijfel met `grep -n` en lees die regels.
- **Loep-bestandsnaam varieert:** `loep.tex`, `loepXXYY.tex`, of een bestand met prefix `L` (bv. `Lgrafen.tex`, `Ldimensies.tex`, `Leerstegraadsfuncties.tex`). Altijd eerst `grep "\\input{" Uitwiskeling.tex` en dan controleren welk bestand de loep-marker heeft.
- **`\ref{...}` vals-positief** — de grep op `(?<=\{)[^{}./]+(?=\})` pikt ook `\ref{label}` op. Die zijn geen bestanden.
- **Extensie-mismatch:** bronbestand heet `fig01.jpg` maar wordt gerefereerd als `{figurenAuteur/fig01}`. Zoek op met `find UW35XX/ -name "STEM.*"`.
- **Bestandsnamen met spaties** (bv. `UW mei flatland.jpg`) komen voor — PowerShell gaat daar goed mee om via arrays.
- **Ontbrekende afbeeldingen:** als een afbeelding niet in het archief zit, is het een draft-artefact — overslaan, niet blokkeren.
- **`loepvoorbeeld.tex`** is altijd een leeg sjabloon — overslaan.
- **Geen scripts schrijven** — inline commando's in de chat.
- **Geen volledige .tex-bestanden lezen** — altijd `grep`.

### Volgorde resterende mappen

```
✅ UW3502  ✅ UW3503  ✅ UW3504
✅ UW3601  ✅ UW3602  ✅ UW3603  ✅ UW3604
✅ UW3701  ✅ UW3702  ✅ UW3703  ✅ UW3704
✅ UW3801  ✅ UW3802  ✅ UW3803  ✅ UW3804
✅ UW3901  ✅ UW3902  ✅ UW3903  ✅ UW3904
✅ UW4001  ✅ UW4002  ✅ UW4003  ✅ UW4004
✅ UW4101  ✅ UW4102  ✅ UW4103  ✅ UW4104
```

**Alle mappen voltooid.**
