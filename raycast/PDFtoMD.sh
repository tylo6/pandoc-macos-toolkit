#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title PDF to MD
# @raycast.mode fullOutput
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📑
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .pdf (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir un PDF en Markdown via marker-pdf (IA — extraction pdftext + OCR surya)
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

VENV="/Users/marcou/Documents/Obsidian Vault/03-PROJETS/Dev/.venv-marker"
MARKER="$VENV/bin/marker_single"
LOG="$HOME/.marker_history.log"

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

BASENAME=$(basename "${FILE%.*}")
RESULT="$OUTPUT_DIR/$BASENAME/$BASENAME.md"
START=$(date +%s)

echo "📄 Fichier  : $(basename "$FILE")"
echo "📁 Sortie   : $OUTPUT_DIR"
echo "⏳ Chargement des modèles IA (1-3 min au premier lancement)…"

# Conversion — stderr affiché pour suivre la progression
"$MARKER" "$FILE" --output_dir "$OUTPUT_DIR" --disable_image_extraction 2>&1

DURATION=$(( $(date +%s) - START ))
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# Rapport qualité depuis le _meta.json
META="$OUTPUT_DIR/$BASENAME/${BASENAME}_meta.json"
PAGES="-"
QUALITY_LINE=""

if [[ -f "$META" ]]; then
    QUALITY=$(python3 - "$META" <<'PYEOF'
import json, sys

with open(sys.argv[1]) as f:
    d = json.load(f)

stats = d.get('page_stats', [])
total = len(stats)
ocr_pages = [s['page_id'] + 1 for s in stats if s.get('text_extraction_method') == 'surya-ocr']
pdf_pages = total - len(ocr_pages)
ocr_pct = round(len(ocr_pages) * 100 / total) if total else 0

print(f"PAGES={total}")
print(f"PDF_PAGES={pdf_pages}")
print(f"OCR_PAGES={len(ocr_pages)}")
print(f"OCR_PCT={ocr_pct}")
print(f"OCR_LIST={','.join(str(p) for p in ocr_pages[:10])}")
PYEOF
)
    # Récupérer les variables
    PAGES=$(echo "$QUALITY" | grep PAGES= | head -1 | cut -d= -f2)
    PDF_PAGES=$(echo "$QUALITY" | grep PDF_PAGES= | cut -d= -f2)
    OCR_PAGES=$(echo "$QUALITY" | grep OCR_PAGES= | cut -d= -f2)
    OCR_PCT=$(echo "$QUALITY" | grep OCR_PCT= | cut -d= -f2)
    OCR_LIST=$(echo "$QUALITY" | grep OCR_LIST= | cut -d= -f2)

    echo ""
    echo "📊 Rapport qualité :"
    echo "   Pages totales    : ${PAGES}p"
    printf "   pdftext (fiable) : %sp (%s%%)\n" "$PDF_PAGES" "$(( 100 - OCR_PCT ))"
    if [[ "$OCR_PAGES" -gt 0 ]]; then
        printf "   surya-ocr        : %sp (%s%%)  ← pages %s\n" "$OCR_PAGES" "$OCR_PCT" "$OCR_LIST"
        echo "   ⚠️  Vérifier manuellement les termes techniques sur ces pages"
        QUALITY_LINE="OCR:${OCR_PAGES}p(${OCR_PCT}%)"
    else
        echo "   ✅ 100% pdftext — extraction directe, termes fiables"
        QUALITY_LINE="pdftext:100%"
    fi
fi

if [[ -f "$RESULT" ]]; then
    echo ""
    echo "✅ Converti : $RESULT (${DURATION}s)"
    printf "%s | OK   | %4ds | %3sp | %-20s | %s\n" "$TIMESTAMP" "$DURATION" "$PAGES" "$QUALITY_LINE" "$(basename "$FILE")" >> "$LOG"
else
    echo "⚠️  Conversion terminée — vérifier : $OUTPUT_DIR/$BASENAME/"
    printf "%s | WARN | %4ds | %3sp | %-20s | %s\n" "$TIMESTAMP" "$DURATION" "$PAGES" "$QUALITY_LINE" "$(basename "$FILE")" >> "$LOG"
fi
