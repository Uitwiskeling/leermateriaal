# Handleiding: Uitwiskeling-LaTeX omzetten naar Ximera

Deze handleiding beschrijft hoe je lesmateriaal in het **Uitwiskeling-tijdschriftformaat**
(zoals de uitgecommentarieerde bron in `UW4202/simpele_zandhopen.tex`) omzet naar het
**Ximera-formaat** van dit repo (zoals de afgewerkte voorbeelden in `UW4201/*.tex`).
Conversie vanuit Word is **nooit** aan de orde in dit repo: de bron is altijd al LaTeX
(Uitwiskeling-tijdschrift-LaTeX → Ximera-LaTeX).

**Referentiebronnen — bekijk deze eerst:**
- **Canonieke commandolijst van het oude formaat:** het `voorbeeld.tex` uit een
  Uitwiskeling-tijdschriftbron (zit in de zips die je in `TOBECONVERTED/` gooit) toont
  álle commando's en omgevingen van het oude formaat met uitleg. Dit is je
  betrouwbaarste naslagwerk voor wat je kan tegenkomen.
- **Afgewerkt voorbeeld (Ximera):** `UW4201/vectorruimten_definieren.tex` (volledigst,
  met progressieve hints) en `UW4201/basis_definieren.tex` (met meerkeuze).
- **Onafgewerkt voorbeeld:** `UW4202/simpele_zandhopen.tex` (inhoud in `%`-comments).
- **Visueel vergelijken (unit test):** compileer de oude bron met
  `bash TOBECONVERTED/compile-old-source.sh <zip>` en leg die PDF naast je Ximera-PDF.
  Zie `TOBECONVERTED/README.md`.

## Doel en mindset

Het tijdschriftartikel is geschreven **voor de leerkracht**: vragen mét antwoorden en
didactisch commentaar erbij. De Ximera-pagina is **voor de leerling**: een zelfstandig
werkbare activiteit waar antwoorden pas op vraag verschijnen ("Toon uitwerking") en in
de print-pdf via de handout-modus verborgen kunnen worden. Converteren is dus méér dan
omgevingen hernoemen: herformuleer waar nodig van "vraag aan de lezer-leerkracht" naar
"opdracht aan de leerling", en haal didactische regie-aanwijzingen ("dit kan in groepjes",
"via een onderwijsleergesprek") uit de leerlingtekst.

## Bestandsstructuur

1. **Eén lesactiviteit = één `.tex`-bestand** in de map van het nummer (bv. `UW4202/`),
   met een korte snake_case-naam **zonder spaties** (bv. `zandhoop_rond_en_vierkant.tex`).
2. Skelet van elk bestand (geen `\input{preamble}`, geen `\addPrintStyle` — de klasse
   laadt `xmPreamble.tex`/`xmPrintstyle.sty` automatisch):

   ```latex
   \documentclass{ximera}

   % eventuele activiteit-specifieke macro's, bv. \newcommand{\pijl}[1]{\vec{#1}}

   \begin{document}
   \author{Voornaam Achternaam}
   \xmtitle{Titel van de lesactiviteit}{}

   \subsection*{Inleiding}
   ...
   \end{document}
   ```
3. Voeg het bestand toe aan de xourse `activiteitenvolgensnummer.tex` onder het juiste
   `\part{UW42xx}` met `\activitychapter{UW42xx/bestandsnaam.tex}`.
4. Afbeeldingen staan in `UW42xx/img/`; verwijs er met pad vanaf de projectroot
   (bv. `UW4202/img/plateau.jpg`). Geen underscores in afbeeldingsbestandsnamen.

## Belangrijke nesting-regels van het oude formaat (om te begrijpen wat je leest)

In de tijdschriftbron gelden strikte structuurregels (anders crasht de tijdschrift-layout):
- `\begin{lesactiviteit}` staat **buiten** `\begin{multicols}` en beheert zelf zijn breedte.
- `\begin{vraagenantwoord}` staat **binnen** een `lesactiviteit`; `\vraag{}`/`\antwoord{}`
  staan **binnen** `vraagenantwoord`.
- Een **geneste** `vraagenantwoord` = subvragen binnen een vraag.
- `\begin{vraagenantwoord}[resume]` laat de vraagnummering doorlopen.
Bij conversie laat je deze layout-structuur grotendeels los: in Ximera wordt elke `\vraag`
een losse `exercise` met automatische nummering.

## Omzettingstabel

| Uitwiskeling-bron (oud) | Ximera-doel (nieuw) |
|---|---|
| `\artikel{titel}{subtitel}{auteur}` / `\artikelfoto{...}{foto}` | `\xmtitle{titel}{}` + `\author{auteur}`; subtitel evt. als `\subsection*`; artikelfoto vervalt |
| `\rubriek{type}{titel}` | niet in de activiteit zelf; de rubriek/kleur staat in de xourse (`\rubriek{loep}{...}`) |
| `\begin{lesactiviteit}{Titel}` | apart bestand met `\xmtitle{Titel}{}`, of `\subsection*{Titel}` als je meerdere korte activiteiten bundelt |
| `\begin{vraagenantwoord}` / `[resume]` | vervalt; elke vraag wordt een eigen `exercise` (nummering automatisch) |
| geneste `\begin{vraagenantwoord}` (subvragen) | deelvragen als `\begin{enumerate}` binnen één `exercise`, of als aparte exercises |
| `\vraag{...}` | de tekst van `\begin{exercise} ... \end{exercise}` |
| `\antwoord{...}` | `\begin{oplossing} ... \end{oplossing}` binnen de exercise |
| (geen equivalent) | `\begin{hint} ... \end{hint}` — voeg zelf 1-3 **progressieve** hints toe vóór de oplossing (zie `UW4201/vectorruimten_definieren.tex`) |
| `\lestitel{...}` / `\lessubtitel{...}` | `\subsection*{...}` / lopende tekst |
| `\afbeelding[breedte]{pad}{caption}{label}` | `\begin{image}[breedte] \includegraphics[width=...,keepaspectratio]{pad} \end{image}`; caption als gewone tekst eronder, `\label` mag binnen image |
| `\afbeeldingtotrand{l\|r\|b}{pad}` | decoratief, tot paginarand → meestal **weglaten** (puur tijdschrift-layout) of als gewone `image` als de figuur inhoudelijk is |
| `\begin{afbeeldingenv}` (foto's naast elkaar) | één `image`-omgeving met meerdere `\includegraphics` gescheiden door `\quad` |
| `\begin{tabel}` + `\tableheader{}` + `\hlinethick` + `\rowcolor{\rubriekkleur!50}` | gewone `tabular` (header met `\textbf`); geen float; geen `\rubriekkleur`/`\hlinethick` (tijdschrift-macro's) |
| `\begin{kader}{type}{titel}` | een passende Ximera-omgeving: `definition`/`proposition`/`example`/`theorem`, of `\begin{xmuitweiding}[titel]` voor een uitklapbare uitweiding (controleer exacte signatuur in `xmPreamble.tex`) |
| `\begin{citaat}[auteur]` | `\begin{quote} ... \end{quote}` (auteur als bijschrift) |
| definities/eigenschappen in lopende tekst | `\begin{definition}`, `\begin{proposition}`, `\begin{example}`, ... (NL-titels uit de stylefile) |
| `\autoref{label}` / `\label{}` | blijft werken; controleer dat het label bestaat (zie valkuilen) |
| `\auteurslot{auteur}` | vervalt (of `\author{}` bovenaan) |
| `\begin{multicols}{2}` | meestal weglaten (HTML kent geen kolommen) |
| `\clearcolumn`, `\newpage`, `\clearpage`, `\smallskip/\medskip/\bigskip` | weglaten (tijdschrift-layout) |
| `\lipsum...` | dummytekst — verwijderen |
| didactisch commentaar voor de leerkracht | `\begin{instructorNotes} ... \end{instructorNotes}`, of voorlopig als `%`-commentaar — **open beslissing**, zie README |
| `\begin{bronnen}` / verwijzingen | voorlopig weglaten en terugverwijzen naar het artikel — **open beslissing**, zie README |

## Ximera-extra's die je mag toevoegen

De online versie kan meer dan het tijdschrift; gebruik dat waar het didactisch loont:

- **Meerkeuze**: `\begin{multipleChoice} \choice{fout} \choice[correct]{juist} \end{multipleChoice}`
  (zie `UW4201/basis_definieren.tex` voor gebruikte varianten in dit repo).
- **YouTube/GeoGebra**: kan ingebed worden in de online versie (zie ximeraLatex-docs).
- Verwijs in de inleiding van de activiteit naar het Uitwiskeling-artikel
  (zoals in `inleiding.tex`).

## Veelvoorkomende valkuilen bij conversie (uit ervaring)

Reële aandachtspunten uit eerdere conversies van Uitwiskeling-bronnen (deels uit
Alexanders notities). Loop dit na **terwijl** je converteert:

1. **Wiskunde in math-modus.** In de oude bron staat wiskunde soms zónder `$`/`\(\)`
   of staan **getallen niet in de math-omgeving**. In Ximera moet álle wiskunde in
   `\(...\)` (inline) of `\[...\]`/`align` (display). Zet losse getallen/variabelen die
   wiskundig bedoeld zijn altijd in `\(...\)`.
2. **Afgeleide-accenten.** Het accentje van een afgeleide (`f'`, `f''`) belandde soms
   verkeerd in superscript. Schrijf `f'(x)`, `f''(x)` netjes in math-modus en controleer
   het resultaat in de PDF.
3. **Figuren staan wel in `img/` maar niet in de tekst.** In de bron werden figuren vaak
   wél meegeleverd maar **niet altijd opgenomen** in de lopende tekst. Controleer of elke
   relevante figuur ook echt met `\begin{image}...\end{image}` in de Ximera-versie staat.
4. **Captions ontbreken vaak.** Onderschriften waren in de bron meestal **niet** ingevuld.
   Voeg waar zinvol een duidelijk onderschrift toe (en een `\label` als je ernaar verwijst).
5. **Dode verwijzingen.** Controleer dat elke `\autoref{...}`/`\ref{...}` een bestaand
   `\label` heeft; bij conversie sneuvelen labels makkelijk.
6. **Decoratieve vs. inhoudelijke figuren.** `\afbeeldingtotrand` is bijna altijd
   decoratief (tijdschrift-randvulling) → weglaten. `\afbeelding` is inhoudelijk → behouden.

## Regels om HTML-breuk te vermijden (belangrijk!)

Zie `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` voor de volledige lijst. Samengevat:

1. Geen spaties in bestandsnamen; geen `_` in afbeeldingsnamen.
2. In tikz-nodes: geen `pmatrix`; gebruik `\left(\begin{smallmatrix}...\end{smallmatrix}\right)`.
3. `cases` niet extra in `\left\{...\right.` wikkelen.
4. `image` i.p.v. `figure`; geen floats, geen `\centering`-figuren.
5. Geen `animate`-package; nieuwe packages enkel via `xmPreamble.tex` en altijd
   pdf + html testen.

## Werkwijze per conversie

1. Lees de hele bron-lesactiviteit; noteer welke vragen, figuren en leerkracht-commentaren erin zitten.
2. Maak het nieuwe bestand volgens het skelet hierboven; zet de inhoud om met de tabel.
3. Schrijf vraagteksten leerlinggericht; bedenk hints; zet het antwoord (eventueel
   geherformuleerd, zonder "de leerlingen zullen...") in `oplossing`.
4. Voeg het bestand toe aan `activiteitenvolgensnummer.tex`.
5. **Compileer en controleer**:
   ```bash
   xmlatex bake -s --nodependencies --force --compile pdf  UW42xx/bestand.tex
   xmlatex bake -s --nodependencies --force --compile html UW42xx/bestand.tex
   ```
   Lees de pdf na (Claude: met de Read-tool) en check de log op fouten/overfull boxes.
6. **Vergelijk met de originele bron (unit test).** Compileer de oude bron met
   `bash TOBECONVERTED/compile-old-source.sh <zip-of-map>` en leg die PDF naast je
   Ximera-PDF. Controleer dat alle vragen, figuren (zie valkuilen 3-4) en wiskunde
   correct zijn overgenomen. Zie `TOBECONVERTED/README.md`.
7. Compileer ook de xourse (`xmlatex bake`) zodat het geheel blijft werken.
8. Werk `CLAUDE_PROGRESS.md` bij (wat is geconverteerd, wat nog niet, open vragen).
