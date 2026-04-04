#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → PDF
# @raycast.mode silent
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📕
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir Markdown en PDF
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

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
if type md2pdf &>/dev/null; then
    md2pdf "$FILE"
    echo "✅ Converti : $(basename "${FILE%.*}").pdf"
else
    # Fallback Pandoc direct
    OUTPUT="${FILE%.*}.pdf"
    pandoc "$FILE" -s --toc --pdf-engine=xelatex -V geometry:margin=2.5cm -V fontsize=12pt -o "$OUTPUT"
    echo "✅ Converti : $(basename "$OUTPUT")"
fi
