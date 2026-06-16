# TOBECONVERTED — referentie-PDF's voor Ximera-vergelijking

Elke Uitwiskeling-loep-activiteit wordt hier gecompileerd in het **originele
tijdschriftformaat** (pdflatex + `uitwiskeling-style.sty`). De resulterende PDF
dient als visuele referentie naast de Ximera-versie — onze "unit test" voor
conversies.

## Mapstructuur

```
TOBECONVERTED/
  Uitwiskeling.tex           # mastertemplate — compileer dit vanuit TOBECONVERTED/
  compilefiles/              # gedeelde stijl- en designbestanden
    uitwiskeling-style.sty   # tijdschriftstijl
    img/                     # omslag- en inline-design-afbeeldingen
    imgDesign/               # rubriek-iconen, checkmarks, ...
  originals/                 # minimale bron per nummer (gecommit)
    UW3501-minim/            # UW3501.tex + img/ met alle gerefereerde afbeeldingen
    UW3502-minim/
    ...  (28 mappen, UW3501 t/m UW4104)
  fullfoldersnotcommitted/   # volledige originelen (gitignored)
  _work/                     # tijdelijke werkdirectory's (gitignored)
```

Elke `originals/UWXXYY-minim/` bevat:
- **één** `UWXXYY.tex` (de loep-activiteit)
- `img/` met exact de afbeeldingen waarnaar de loep verwijst

Sommige `img/` mappen hebben subdirectory's (bv. `img/loepMichele/`, `img/LAlgebra/`).

## Compileren

Compileer vanuit de `TOBECONVERTED/` map:

```bash
cd TOBECONVERTED
pdflatex Uitwiskeling.tex                          # compileert \uwid (standaard UW3501)
pdflatex -e "\def\uwid{UW3502}" Uitwiskeling.tex   # ander nummer
```

Twee passes nodig voor correcte TikZ-headers:

```bash
pdflatex Uitwiskeling.tex && pdflatex Uitwiskeling.tex
```

## Preamble itereren

Het doel: **één `Uitwiskeling.tex`** die alle 28 nummers foutloos compileert.  
Werkwijze:

1. Compileer een nummer (zie boven)
2. Lees de log bij fouten: `Uitwiskeling.log`
3. Voeg ontbrekende packages of commando's toe aan `Uitwiskeling.tex`
4. Herhaal tot alle 28 nummers slagen — **pas nooit de `originals/`-bestanden aan**

## Compilatiestatus

| Nummer  | Tex-bestand   | Status |
|---------|---------------|--------|
| UW3501  | UW3501.tex    | ⬜ TBD |
| UW3502  | UW3502.tex    | ⬜ TBD |
| UW3503  | UW3503.tex    | ⬜ TBD |
| UW3504  | UW3504.tex    | ⬜ TBD |
| UW3601  | UW3601.tex    | ⬜ TBD |
| UW3602  | UW3602.tex    | ⬜ TBD |
| UW3603  | UW3603.tex    | ⬜ TBD |
| UW3604  | UW3604.tex    | ⬜ TBD |
| UW3701  | UW3701.tex    | ⬜ TBD |
| UW3702  | UW3702.tex    | ⬜ TBD |
| UW3703  | UW3703.tex    | ⬜ TBD |
| UW3704  | UW3704.tex    | ⬜ TBD |
| UW3801  | UW3801.tex    | ⬜ TBD |
| UW3802  | UW3802.tex    | ⬜ TBD |
| UW3803  | UW3803.tex    | ⬜ TBD |
| UW3804  | UW3804.tex    | ⬜ TBD |
| UW3901  | UW3901.tex    | ⬜ TBD |
| UW3902  | UW3902.tex    | ⬜ TBD |
| UW3903  | UW3903.tex    | ⬜ TBD |
| UW3904  | UW3904.tex    | ⬜ TBD |
| UW4001  | UW4001.tex    | ⬜ TBD |
| UW4002  | UW4002.tex    | ⬜ TBD |
| UW4003  | UW4003.tex    | ⬜ TBD |
| UW4004  | UW4004.tex    | ⬜ TBD |
| UW4101  | UW4101.tex    | ⬜ TBD |
| UW4102  | UW4102.tex    | ⬜ TBD |
| UW4103  | UW4103.tex    | ⬜ TBD |
| UW4104  | UW4104.tex    | ⬜ TBD |

Werk de status bij zodra een nummer compileert: ✅ OK / ❌ Fout (met korte notitie).

## TODO: afbeeldingsstrategie heroverwegen

De huidige aanpak: elke `originals/UWXXYY-minim/` heeft een `img/`-map; de loep-tex
verwijst naar `img/foo.jpg`; `\graphicspath` wordt zo gezet dat `img/` in de juiste
map wordt gevonden.

Twee alternatieven om af te wegen:

**A. Unieke bestandsnamen in één gedeelde map**
Alle afbeeldingen van alle nummers in één `compilefiles/img/` of `originals/shared-img/`,
met een prefix zoals `UW3501_foo.jpg`. Voordeel: simpele `\graphicspath`; nadeel:
grote map, moeilijker te onderhouden per nummer.

**B. Vlakke bestandsnamen + dynamische `\graphicspath` per nummer (huidige richting)**
Elk nummer heeft zijn eigen `img/`; de graphicspath-macro `{originals/\uwid-minim/}`
zorgt dat `img/foo.jpg` altijd naar de juiste map wijst. Voordeel: nummers zijn
zelfstandig; nadeel: subdirectory-namen zijn al als prefix ingebakken bij het
platslaan (bv. `img/loepMichele_fig.png`) — dat is een half-compromis.

Kies vóór je meer nummers converteert welke strategie je wilt doorvoeren.
