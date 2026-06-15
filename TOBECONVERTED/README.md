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
