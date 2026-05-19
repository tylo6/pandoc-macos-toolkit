#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → DOCX
# @raycast.mode silent
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📄
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir Markdown en DOCX
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

# =============================================================================
# BRIEF
# Projet  : pandoc-macos-toolkit
# Script  : pandoc-docx — conversion fichier unique MD → DOCX
# Moteur  : pandoc (md2docx si disponible, sinon pandoc direct)
# Source  : fichier .md sélectionné dans Finder ou passé en argument
# Sortie  : même dossier que la source — <nom>.docx
# Log     : aucun (mode silent Raycast)
# Statut  : validé (script existant)
# Export  : ./pandoc-docx.sh --brief > pandoc-docx-brief.md
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

# Convertir
if type md2docx &>/dev/null; then
    md2docx "$FILE"
    echo "✅ Converti : $(basename "${FILE%.*}").docx"
else
    # Fallback Pandoc direct
    OUTPUT="${FILE%.*}.docx"
    pandoc "$FILE" -s --toc -o "$OUTPUT"
    echo "✅ Converti : $(basename "$OUTPUT")"
fi
