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

## Règles batch

- Throttle max : **4 jobs parallèles** pour préserver la réactivité machine
- Priorité basse : `nice -n 10` sur tous les processus batch
- Log de reprise obligatoire : `batch/conversion_log.csv` — ne jamais retraiter un fichier déjà en statut `OK`
- **Jamais de suppression des fichiers source**
- Dossier de sortie = même dossier que le fichier source (cohérence avec PDFtoMD.sh)

## Feuille de route

### Ordre de développement

| Priorité | Script | Statut |
|---|---|---|
| 1 | `raycast/PPTtoMD.sh` — PPTX → MD via pandoc | ⬜ À faire |
| 2 | `raycast/DOCXtoMD.sh` — DOCX → MD via pandoc | ⬜ À faire |
| 3 | `batch/convert_batch.py` — batch multi-format | ⬜ À faire |
| ✅ | `raycast/PDFtoMD.sh` — PDF → MD via marker-pdf | ✅ Validé |

### Notes de conception

- **PPTtoMD** : pandoc extrait titres + corps texte des slides ; les images sont perdues (comportement attendu et documenté)
- **DOCXtoMD** : pandoc natif, très fiable ; options `--wrap=none --extract-media` à évaluer
- **Batch** : deux modes — `--fast` (DOCX+PPTX via pandoc) et `--ai` (PDF via marker, plus lent)
- **Branche de dev** : `feat/new-converters` — merge sur `main` après validation des 3 scripts

## Questions ouvertes

- Nommage du dossier de sortie batch : sous-dossier par type (`md/`) ou côte à côte avec les sources ?
- Gestion des fichiers protégés par mot de passe (DOCX/PDF) : skip silencieux ou erreur visible ?
