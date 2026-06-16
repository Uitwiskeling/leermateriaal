# TOBECONVERTED — referentie-PDF's voor Ximera-vergelijking

Elke Uitwiskeling-loep-activiteit wordt hier gecompileerd in het **originele
tijdschriftformaat** (pdflatex + `uitwiskeling-style.sty`). De resulterende PDF
dient als visuele referentie naast de Ximera-versie — onze "unit test" voor
conversies.

## Mapstructuur

```
TOBECONVERTED/
  Uitwiskeling.tex           # mastertemplate — compileer dit vanuit TOBECONVERTED/
  compile-all.sh             # batch: compileer alle 28 nummers, schrijf SUMMARY.md
  extract-missing-images.sh  # haal ontbrekende afbeeldingen uit fullfoldersnotcommitted/
  compilefiles/              # gedeelde stijl- en designbestanden
    uitwiskeling-style.sty   # tijdschriftstijl (incl. FOR OLD FORMAT shims onderaan)
    img/                     # omslag- en inline-design-afbeeldingen
    imgDesign/               # rubriek-iconen, checkmarks, ...
  originals/                 # minimale bron per nummer (gecommit)
    UW3501-minim/            # UW3501.tex + img/ met alle gerefereerde afbeeldingen
    UW3502-minim/
    ...  (28 mappen, UW3501 t/m UW4104)
  OUTPUTTEDPDFS/             # succesvol gecompileerde PDF's (gitignored)
  _compilelogs/              # logs + SUMMARY.md (gitignored)
  fullfoldersnotcommitted/   # volledige originelen (gitignored)
```

Elke `originals/UWXXYY-minim/` bevat:
- **één** `UWXXYY.tex` (de loep-activiteit)
- `img/` met exact de afbeeldingen waarnaar de loep verwijst

Sommige `img/` mappen hebben subdirectory's (bv. `img/loepMichele/`, `img/LAlgebra/`).

## Compileren

Compileer vanuit de `TOBECONVERTED/` map:

```bash
# Eén nummer:
pdflatex "\def\uwid{UW3502}\input{Uitwiskeling}"

# Alle 28 tegelijk (PDF's → OUTPUTTEDPDFS/, logs → _compilelogs/):
bash compile-all.sh
```

## Preamble itereren

Het doel: **één `Uitwiskeling.tex`** die alle 28 nummers foutloos compileert.
Fixes gaan uitsluitend in `compilefiles/uitwiskeling-style.sty` (sectie `%%% FOR OLD FORMAT %%%`)
of in `Uitwiskeling.tex`. **Pas nooit de `originals/`-bestanden aan.**

## Compilatiestatus (best known — run compile-all.sh voor actuele stand)

Laatste verified run: sessie juni 2026, na de preamble-iteraties beschreven hieronder.
UW3704 en UW3802 zijn gefixed maar nog niet opnieuw geverifieerd via compile-all.

| Nummer  | Status      | Noot |
|---------|-------------|------|
| UW3501  | ✅ OK       | tabu-environment (deprecated package, shim aanwezig) |
| UW3502  | ✅ OK       | |
| UW3503  | ✅ OK       | |
| UW3504  | ✅ OK       | |
| UW3601  | ✅ OK       | |
| UW3602  | ✅ OK       | |
| UW3603  | ❌ Bronf.   | `\emph{...}` met extra `}` in bron — niet fixbaar vanuit preamble |
| UW3604  | ❌ Bronf.   | `\textbf{...}` met extra `}` in bron — niet fixbaar vanuit preamble |
| UW3701  | ✅ OK       | |
| UW3702  | ✅ OK       | |
| UW3703  | ✅ OK       | FloatBarrier-fix aanwezig voor multicols |
| UW3704  | ✅ OK*      | *fix: lege regels in array + kader 0-args; nog te verifiëren |
| UW3801  | ✅ OK       | |
| UW3802  | ✅ OK*      | *fix: lege regels in array; nog te verifiëren |
| UW3803  | ✅ OK       | |
| UW3804  | ✅ OK       | |
| UW3901  | ✅ OK       | |
| UW3902  | ✅ OK       | |
| UW3903  | ❌ Pending  | `\circled` conflict: UW3903 definieert eigen TikZ-versie; `\ifstrequal` vergelijking werkt niet correct met huidige MiKTeX-packages |
| UW3904  | ✅ OK       | gebruikt `\circled` (fallback) |
| UW4001  | ❌ Bronf.   | meerdere bronfouten: `r{2.8cm}` kolom, `&` in bibliografie, ontbrekend `\item` |
| UW4002  | ✅ OK       | arydshln voor `:` kolomtype |
| UW4003  | ✅ OK       | |
| UW4004  | ✅ OK       | |
| UW4101  | ✅ OK       | `\includestandalone` no-op'd (double .tex extensie) |
| UW4102  | ✅ OK       | python/ symlink aangemaakt in compile-all.sh |
| UW4103  | ✅ OK       | |
| UW4104  | ✅ OK       | |

**Bronfouten** = fouten in de `originals/`-bestanden zelf die niet via preamble-shims te fixen zijn.
**Pending** = fix is geschreven maar nog niet geverifieerd.

## FOR OLD FORMAT — overzicht van toegepaste shims

Alle backward-compat fixes zitten in `compilefiles/uitwiskeling-style.sty` onderaan
de sectie `%%% FOR OLD FORMAT %%%`. Overzicht:

| Package/fix | Reden |
|-------------|-------|
| `tabu` | `longtabu`-omgevingen in UW3501 e.a. |
| `float` | `[H]` float-plaatsing |
| `multirow` | `\multirow` in tabellen |
| `arydshln` | `:` als kolomscheidingsteken (UW4002) |
| `standalone` (no-op) | `\includestandalone` met .tex-extensie (UW4101) |
| `\usetikzlibrary{arrows}` | `>=triangle 45` in tikzpicture (UW3604) |
| `\typeRubriek` | oud metadata-commando, no-op |
| `\startNieuweRubriek` | oud rubriek-header, no-op |
| `\inhoudstafelLoep` | oud TOC-commando, no-op |
| `\includestandalone` no-op | dubbele .tex extensie |
| `\@nolnerr\relax` | `\\` in vertical mode (UW3502, UW3604) |
| `\everymath/\everydisplay \par\relax` | lege regels in `array`-omgeving (UW3704, UW3802) |
| `\renewenvironment{kader}` (0 args) | oude loep-bestanden gebruiken `\begin{kader}` zonder args |
| `\BeforeBeginEnvironment{multicols}{\FloatBarrier}` | deferred floats (UW3703) |
| `\nummering`, `\opsomming`, `\werktekstoef`, `\meerkeuze` | verouderde lijstomgevingen |
| `\beginwerktekst`/`\eindewerktekst` | → `lesactiviteit` (zie noot in agent) |
| `\tussentitel` | → `\lestitel` |
| `\figuurrechts` | minipage-layout |
| `\stellingkadertwee`, `\stellingkader` | → `kader{type}{titel}` |

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
