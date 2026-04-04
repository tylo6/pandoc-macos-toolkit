#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Marker → Markdown
# @raycast.mode fullOutput
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📑
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .pdf (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir un PDF en Markdown via marker-pdf (IA)
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

VENV="/Users/marcou/Documents/Obsidian Vault/03-PROJETS/Dev/.venv-marker"
MARKER="$VENV/bin/marker_single"

# Récupérer le fichier
if [[ -n "$1" ]]; then
    FILE="$1"
else
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

if [[ -z "$FILE" ]]; then
    echo "❌ Aucun fichier spécifié ou sélectionné"
    exit 1
fi

if [[ ! "$FILE" =~ \.pdf$ ]]; then
    echo "⚠️  Pas un fichier PDF : $FILE"
    exit 1
fi

if [[ ! -f "$MARKER" ]]; then
    echo "❌ marker_single introuvable — venv : $VENV"
    exit 1
fi

# Dossier de sortie = même dossier que le PDF
OUTPUT_DIR=$(dirname "$FILE")

echo "📄 Fichier  : $(basename "$FILE")"
echo "📁 Sortie   : $OUTPUT_DIR"
echo "⏳ Chargement des modèles IA (1-3 min au premier lancement)…"

# Conversion — stderr affiché pour suivre la progression
"$MARKER" "$FILE" --output_dir "$OUTPUT_DIR" --disable_image_extraction 2>&1

# marker_single crée un sous-dossier portant le nom du fichier
BASENAME=$(basename "${FILE%.*}")
RESULT="$OUTPUT_DIR/$BASENAME/$BASENAME.md"

if [[ -f "$RESULT" ]]; then
    echo "✅ Converti : $RESULT"
else
    echo "⚠️  Conversion terminée — vérifier : $OUTPUT_DIR/$BASENAME/"
fi
