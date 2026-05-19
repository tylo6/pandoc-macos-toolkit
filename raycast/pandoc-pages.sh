#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → Pages
# @raycast.mode silent
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📃
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir Markdown en DOCX et ouvrir dans Pages
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

# =============================================================================
# BRIEF
# Projet  : pandoc-macos-toolkit
# Script  : pandoc-pages — conversion fichier unique MD → DOCX → ouverture Pages
# Moteur  : pandoc (md2docx si disponible) + open -a Pages
# Source  : fichier .md sélectionné dans Finder ou passé en argument
# Sortie  : même dossier que la source — <nom>.docx (ouvert dans Pages)
# Log     : aucun (mode silent Raycast)
# Statut  : validé (script existant)
# Export  : ./pandoc-pages.sh --brief > pandoc-pages-brief.md
# =============================================================================

if [[ "$1" == "--brief" ]]; then
  awk '/^# BRIEF/{f=1} f && /^# ==========/{exit} f{sub(/^# ?/,""); print}' "$0"
  exit 0
fi

# Source zsh pour charger les fonctions
source "$HOME/.zshrc"

# Récupérer le fichier
if [[ -n "$1" ]]; then
    FILE="$1"
else
    # Tenter de récupérer la sélection Finder
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

# Vérifier qu'on a un fichier
if [[ -z "$FILE" ]]; then
    echo "❌ Aucun fichier spécifié ou sélectionné"
    exit 1
fi

# Vérifier que c'est un fichier Markdown
if [[ ! "$FILE" =~ \.(md|markdown)$ ]]; then
    echo "⚠️  Pas un fichier Markdown : $FILE"
    exit 1
fi

# Convertir en DOCX d'abord
OUTPUT="${FILE%.*}.docx"

if type md2docx &>/dev/null; then
    md2docx "$FILE"
else
    # Fallback Pandoc direct
    pandoc "$FILE" -s --toc -o "$OUTPUT"
fi

# Ouvrir dans Pages
if [[ -f "$OUTPUT" ]]; then
    open -a Pages "$OUTPUT"
    echo "✅ Converti et ouvert dans Pages : $(basename "$OUTPUT")"
else
    echo "❌ Erreur lors de la conversion"
    exit 1
fi
