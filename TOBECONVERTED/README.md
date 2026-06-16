# TOBECONVERTED — referentie-PDF's voor Ximera-vergelijking

Elke Uitwiskeling-loep-activiteit wordt hier gecompileerd in het **originele
tijdschriftformaat** (pdflatex + `uitwiskeling-style.sty`). De resulterende PDF
dient als visuele referentie naast de Ximera-versie — onze "unit test" voor
conversies.

## Mapstructuur

```
TOBECONVERTED/
  compilefiles/              # gedeelde preamble-bestanden — dit is de iteratiedoelwit
    Uitwiskeling.tex         # mastertemplate (preamble + loep-placeholder __LOEP__)
    uitwiskeling-style.sty   # tijdschriftstijl
    img/                     # omslag- en inline-design-afbeeldingen
    imgDesign/               # rubriek-iconen, checkmarks, ...
  originals/                 # minimale bron per nummer (gecommit)
    UW3501-minim/            # loep.tex + exact de gerefereerde afbeeldingen
    UW3502-minim/
    ...  (28 mappen, UW3501 t/m UW4104)
  fullfoldersnotcommitted/   # volledige originelen (gitignored)
  compile-old-source.sh      # compilatiescript
  _work/                     # tijdelijke werkdirectory's (gitignored, door script aangemaakt)
```

Elke `originals/UWXXYY-minim/` bevat:
- **één** loep-`.tex` (naam varieert: `loep.tex`, `Lgrafen.tex`, `LOEPpython.tex`, …)
- de subdirectory's `figurenAuteur/` en/of `tekeningenKurt/` met exact de
  afbeeldingen waarnaar de loep verwijst

## Compileren

```bash
bash TOBECONVERTED/compile-old-source.sh UW3501        # één nummer
bash TOBECONVERTED/compile-old-source.sh all           # alle 28 nummers
```

Het script:
1. zoekt automatisch het loep-`.tex`-bestand in `originals/UWXXYY-minim/`
2. maakt `_work/UWXXYY/` aan en kopieert preamble + bronbestanden daarin
3. genereert een `Uitwiskeling.tex` met de juiste `\input{}`
4. draait `pdflatex` 2× (TikZ-headers hebben twee passes nodig)
5. meldt het pad van de PDF

## Preamble itereren

Het doel: **één `compilefiles/Uitwiskeling.tex`** die alle 28 nummers foutloos
compileert. Werkwijze:

1. Compileer een nummer: `bash TOBECONVERTED/compile-old-source.sh UW3501`
2. Lees de log bij fouten: `_work/UW3501/Uitwiskeling.log`
3. Voeg ontbrekende packages of commando's toe aan `compilefiles/Uitwiskeling.tex`
4. Herhaal tot alle 28 nummers slagen — **pas nooit de loep-`.tex`-bestanden aan**

## Compilatiestatus

| Nummer  | Loep-bestand           | Status |
|---------|------------------------|--------|
| UW3501  | loep.tex               | ⬜ TBD |
| UW3502  | loep3502.tex           | ⬜ TBD |
| UW3503  | loep.tex               | ⬜ TBD |
| UW3504  | loep.tex               | ⬜ TBD |
| UW3601  | Leerstegraadsfuncties.tex | ⬜ TBD |
| UW3602  | Lgrafen.tex            | ⬜ TBD |
| UW3603  | Ldimensies.tex         | ⬜ TBD |
| UW3604  | 3604L.tex              | ⬜ TBD |
| UW3701  | 3701L.tex              | ⬜ TBD |
| UW3702  | loep.tex               | ⬜ TBD |
| UW3703  | loep.tex               | ⬜ TBD |
| UW3704  | Llinprog.tex           | ⬜ TBD |
| UW3801  | onderdeloep.tex        | ⬜ TBD |
| UW3802  | L3802krommen.tex       | ⬜ TBD |
| UW3803  | L3803.tex              | ⬜ TBD |
| UW3804  | Lgroepen.tex           | ⬜ TBD |
| UW3901  | onderdeloep.tex        | ⬜ TBD |
| UW3902  | LStatistiek.tex        | ⬜ TBD |
| UW3903  | L3903.tex              | ⬜ TBD |
| UW3904  | onderdeloep.tex        | ⬜ TBD |
| UW4001  | onderdeloep.tex        | ⬜ TBD |
| UW4002  | loep.tex               | ⬜ TBD |
| UW4003  | LAlgebra.tex           | ⬜ TBD |
| UW4004  | onderdeloep.tex        | ⬜ TBD |
| UW4101  | onderdeloep.tex        | ⬜ TBD |
| UW4102  | LOEPpython.tex         | ⬜ TBD |
| UW4103  | LOEPSpeltheorie.tex    | ⬜ TBD |
| UW4104  | LOEPvariabelenrol.tex  | ⬜ TBD |

Werk de status bij zodra een nummer compileert: ✅ OK / ❌ Fout (met korte notitie).
