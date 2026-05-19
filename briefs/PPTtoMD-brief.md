BRIEF
Projet  : pandoc-macos-toolkit
Script  : PPTtoMD — conversion fichier unique PPTX → Markdown
Moteur  : pandoc (texte + titres des slides ; images non extraites)
Source  : fichier .pptx sélectionné dans Finder ou passé en argument
Sortie  : /Volumes/Andromede/fiches_de_cas_antea/markdown/<nom>.md
Log     : ~/.pandoc_history.log (format pipe-separated, cohérent PDFtoMD)
Branche : feat/new-converters — à merger sur main après validation
Ordre   : 1/3 (PPTtoMD → DOCXtoMD → batch)
Export  : ./PPTtoMD.sh --brief > PPTtoMD-brief.md
