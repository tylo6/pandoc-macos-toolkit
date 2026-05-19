# CLAUDE.md — pandoc-macos-toolkit

## Contexte

Toolkit de conversion de documents sur macOS, à usage personnel (Antea Group).
Objectif principal : convertir ~5 800 fichiers (PDF, DOCX, PPTX) stockés sur volume externe en Markdown, en batch silencieux sans saturer la machine.

## Stack

| Outil | Rôle |
|---|---|
| **Pandoc** | Conversions DOCX/PPTX → MD, MD → DOCX/HTML |
| **marker-pdf** | PDF → MD via IA (pdftext + OCR surya) |
| **Python 3** | Scripts batch, rapports qualité, log de reprise |
| **Raycast** | Accès rapide fichier unique (scripts dans `raycast/`) |

**Venv marker** : `/Users/marcou/Documents/Obsidian Vault/03-PROJETS/Dev/.venv-marker`
**Remote Git** : `git@github.com:tylo6/pandoc-macos-toolkit.git`

## Structure

```
pandoc-macos-toolkit/
├── raycast/        # Scripts Raycast — un fichier = une conversion, fichier unique
│   ├── PDFtoMD.sh      ← PDF → MD (marker-pdf IA)
│   ├── DOCXtoMD.sh     ← à créer
│   ├── PPTtoMD.sh      ← à créer (priorité 1)
│   ├── pandoc-docx.sh  ← MD → DOCX
│   ├── pandoc-html.sh  ← MD → HTML
│   └── pandoc-pages.sh ← MD → DOCX → Pages
├── batch/          # Scripts batch volume externe — à créer
│   └── convert_batch.py  ← batch PDF+DOCX+PPTX avec throttle et log de reprise
├── install/        # Scripts d'installation fonctions shell
├── docs/           # Documentation de référence
├── editors/        # Configs Sublime Text et VS Code
└── utils/          # Debug et outils divers
```

## Conventions de code

- Scripts Raycast : **zsh** (compatibilité Raycast obligatoire)
- Scripts batch : **Python 3** (log, reprise, throttle)
- Log format pipe-separated : `TIMESTAMP | STATUS | DURATION | PAGES | QUALITY | FILENAME`
- Indentation : 2 espaces (zsh et Python)
- Commentaires en français, noms de variables en anglais
- Commits atomiques en français (convention Conventional Commits)

## Convention de nommage des fichiers

Les fichiers convertis **héritent du nom source sans modification**. La convention s'applique donc en amont, au nommage des fichiers sources avant conversion.

Structure imposée aux sources :
```
{ID}_{DOMAINE}_{description}_{type}_{réf}_{année}.ext
```

Règles de casse :
- `{ID}` → première lettre **Majuscule** (ex: `Ant042`, `4100`)
- `{DOMAINE}` → **TOUT EN MAJUSCULES** (ex: `SSP`, `EAU`, `INFRA`)
- `{description}_{type}_{réf}_{année}` → **tout en minuscules**
- Séparateur : `_` (underscore) — compatible IA, bases de données, URLs
- Pas d'espaces, pas d'accents, pas de caractères spéciaux

Exemple : `Ant042_SSP_diagnostic-pollution-chlore_fiche_ref2024_2023.pptx`

Le fichier converti hérite du nom source : `Ant042_SSP_diagnostic-pollution-chlore_fiche_ref2024_2023.md`

## Règles batch

- Throttle max : **4 jobs parallèles** pour préserver la réactivité machine
- Priorité basse : `nice -n 10` sur tous les processus batch
- Log de reprise obligatoire : `batch/conversion_log.csv` — ne jamais retraiter un fichier déjà en statut `OK`
- **Jamais de suppression des fichiers source**
- Dossier de sortie = même dossier que le fichier source (cohérence avec PDFtoMD.sh)

## Brief projet

### Ordre de développement

| Priorité | Script | Statut |
|---|---|---|
| ✅ | `raycast/PPTtoMD.sh` — PPTX → MD via pandoc | ✅ Validé |
| ✅ | `raycast/DOCXtoMD.sh` — DOCX → MD via pandoc | ✅ Validé |
| ✅ | `batch/convert_batch.py` — batch multi-format | ✅ Validé |
| ✅ | `raycast/PDFtoMD.sh` — PDF → MD via marker-pdf | ✅ Validé |
| 4 | `raycast/PDFtoMD.sh` — révision script PDF (batch mode) | ⬜ À faire |

### Notes de conception

- **PPTtoMD** : pandoc extrait titres + corps texte des slides ; images perdues (comportement attendu)
- **DOCXtoMD** : pandoc `-t plain --wrap=none` + post-traitement Python (aplatissement tableaux Word)
- **Batch** : modes `--fast` (DOCX+PPTX, 4 workers), `--ai` (PDF via marker, 1-2 workers recommandés), `--all`
  - Fallback `.ppt` (vieux format binaire) via LibreOffice → pptx → pandoc
  - Manifest CSV reprise : `batch/conversion_log.csv` — jamais retraiter un OK
- **Branche de dev** : `feat/new-converters` — merge sur `main` après livraison script PDF révisé

### Questions ouvertes

- Gestion des fichiers protégés par mot de passe (DOCX/PDF) : skip silencieux ou erreur visible ?

## Skills à utiliser sur ce projet

| Tâche | Skill à déclencher |
|---|---|
| Nouveau script zsh (Raycast) | `code-review` — relire avant merge |
| Script Python batch | `python-refactor-lean` — épurer après première version |
| Script Python batch | `python-testing` — écrire tests de non-régression |
| Fonctions Python batch | `python-docstring` — documenter les fonctions |
| Messages de commit | `commit-conventions` — format Conventional Commits |
| README / doc utilisateur | `user-documentation` — mise à jour après chaque script |
