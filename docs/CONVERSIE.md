# Handleiding: Uitwiskeling-LaTeX omzetten naar Ximera

Deze handleiding beschrijft hoe je lesmateriaal in het **Uitwiskeling-tijdschriftformaat**
(zoals de uitgecommentarieerde bron in `UW4202/simpele_zandhopen.tex`) omzet naar het
**Ximera-formaat** van dit repo (zoals de afgewerkte voorbeelden in `UW4201/*.tex`).
Conversie vanuit Word is hier nooit nodig: de bron is altijd al LaTeX.

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

## Omzettingstabel

| Uitwiskeling-bron | Ximera-doel |
|---|---|
| `\begin{lesactiviteit}{Titel}` | apart bestand met `\xmtitle{Titel}{}`, of `\subsection*{Titel}` als je meerdere korte activiteiten in één pagina bundelt |
| `\begin{vraagenantwoord}` / `[resume]` | vervalt; elke vraag wordt een eigen `exercise` (nummering gebeurt automatisch) |
| `\vraag{...}` | de tekst van `\begin{exercise} ... \end{exercise}` |
| `\antwoord{...}` | `\begin{oplossing} ... \end{oplossing}` binnen de exercise |
| (geen equivalent) | `\begin{hint} ... \end{hint}` — voeg zelf 1-3 **progressieve** hints toe vóór de oplossing waar dat de leerling helpt (zie `UW4201/vectorruimten_definieren.tex`) |
| `\afbeelding[breedte]{pad}{caption}{label}` | `\begin{image}[breedte] \includegraphics[width=...,keepaspectratio]{pad} \end{image}`; caption als gewone tekst eronder, `\label` mag binnen image |
| `\begin{afbeeldingenv}` (foto's naast elkaar) | één `image`-omgeving met meerdere `\includegraphics` gescheiden door `\quad` |
| `\begin{tabel}` + `\tableheader{...}` | gewone `tabular` (header desnoods `\textbf`); geen float |
| definities/eigenschappen in lopende tekst | `\begin{definition}`, `\begin{proposition}`, `\begin{example}`, ... (Nederlandse titels komen uit de stylefile) |
| `\begin{multicols}{2}` | meestal weglaten (HTML kent geen kolommen); enkel behouden als het puur om pdf-layout gaat |
| `\clearcolumn`, `\newpage`, `\clearpage` | weglaten (tijdschrift-layout) |
| didactisch commentaar voor de leerkracht | `\begin{instructorNotes} ... \end{instructorNotes}`, of voorlopig als `%`-commentaar laten staan — **open beslissing**, zie README |
| `\begin{bronnen}` / verwijzingen | voorlopig weglaten en terugverwijzen naar het artikel — **open beslissing**, zie README |

## Ximera-extra's die je mag toevoegen

De online versie kan meer dan het tijdschrift; gebruik dat waar het didactisch loont:

- **Meerkeuze**: `\begin{multipleChoice} \choice{fout} \choice[correct]{juist} \end{multipleChoice}`
  (zie `UW4201/basis_definieren.tex` voor gebruikte varianten in dit repo).
- **YouTube/GeoGebra**: kan ingebed worden in de online versie (zie ximeraLatex-docs).
- Verwijs in de inleiding van de activiteit naar het Uitwiskeling-artikel
  (zoals in `inleiding.tex`).

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
6. Compileer ook de xourse (`xmlatex bake`) zodat het geheel blijft werken.
7. Werk `CLAUDE_PROGRESS.md` bij (wat is geconverteerd, wat nog niet, open vragen).
