# Open leermaterialen

Hier maken we leermateriaal van Uitwiskeling beschikbaar, waarbij we telkens teruglinken naar het didactische artikel waar je meer kan lezen over het ontwerpproces en verdere inspiratie.
Een abonnement nemen op Uitwiskeling staat [hier](https://www.uitwiskeling.be/abonnementen/?v=d3dcf429c679) uitgelegd; je krijgt er driemaandelijkse didactische inspiratie met becommentarieerde lesactiviteiten ter illustratie.

Geïnteresseerd om mee te werken aan deze verzameling materialen? Contacteer ons op [info@uitwiskeling.be](mailto:info@uitwiskeling.be)!

# TODOs
- [ ] Decide on integrating teacher advice and references in UW articles
- [ ] merge uitwiskeling.css and Vectorruimten.css (loep specifiek)
- [x] preambule integration: ximera.cls v2.7.8 laadt `xmPreamble.tex` en `xmPrintstyle.sty` automatisch; documenten mogen GEEN `\input{./preamble.tex}`/`\addPrintStyle{.}` meer doen. `preamble.tex`/`printstyle.sty` zijn verouderde kopieën (te verwijderen?). Zie `docs/XIMERA_PROBLEMEN_EN_TRICKS.md`.
- [ ] only one definition of \pdfOnly{\renewcommand{\xmcursusnaam}{{\textsc{Uitwiskeling}}}} ? global.sty
- [x] extra packages toevoegen: in `xmPreamble.tex` (en daarna pdf+html testen), zie `docs/XIMERA_PROBLEMEN_EN_TRICKS.md` punt 8

Voor compileren (lokaal, Codespaces of Claude): zie `COMPILING.md`. Voor het omzetten
van Uitwiskeling-artikels naar Ximera: zie `docs/CONVERSIE.md`.