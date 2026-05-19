#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title PPT to MD
# @raycast.mode fullOutput
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📊
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .pptx (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir un fichier PowerPoint (.pptx) en Markdown via pandoc — texte et titres extraits, images non incluses
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

# =============================================================================
# BRIEF
# Projet  : pandoc-macos-toolkit
# Script  : PPTtoMD — conversion fichier unique PPTX → Markdown
# Moteur  : pandoc (texte + titres des slides ; images non extraites)
# Source  : fichier .pptx sélectionné dans Finder ou passé en argument
# Sortie  : /Volumes/Andromede/fiches_de_cas_antea/markdown/<nom>.md
# Log     : ~/.pandoc_history.log (format pipe-separated, cohérent PDFtoMD)
# Branche : feat/new-converters — à merger sur main après validation
# Ordre   : 1/3 (PPTtoMD → DOCXtoMD → batch)
# Export  : ./PPTtoMD.sh --brief > PPTtoMD-brief.md
# =============================================================================

if [[ "$1" == "--brief" ]]; then
  awk '/^# BRIEF/{f=1} f && /^# ==========/{exit} f{sub(/^# ?/,""); print}' "$0"
  exit 0
fi

LOG="$HOME/.pandoc_history.log"

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

if [[ ! "$FILE" =~ \.(pptx|ppt)$ ]]; then
  echo "⚠️  Pas un fichier PowerPoint : $FILE"
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "❌ Fichier introuvable : $FILE"
  exit 1
fi

if ! command -v pandoc &>/dev/null; then
  echo "❌ pandoc introuvable — installer via : brew install pandoc"
  exit 1
fi

OUTPUT_DIR=$(dirname "$FILE")
BASENAME=$(basename "${FILE%.*}")
RESULT="$OUTPUT_DIR/${BASENAME}.md"
START=$(date +%s)

echo "📊 Fichier  : $(basename "$FILE")"
echo "📁 Sortie   : $OUTPUT_DIR"
echo "⏳ Conversion en cours…"

# Conversion — --wrap=none évite les retours à la ligne artificiels dans le MD
pandoc "$FILE" --wrap=none -o "$RESULT" 2>&1

# Post-traitement : suppression des artefacts pandoc pour améliorer la qualité IA
# - <!-- --> : balises vides issues des placeholders PowerPoint vides
# - lignes "- " seules : items de liste vides
# - références images cassées : remplacées par [image] (chemin ppt/media/ non résolu)
if [[ -f "$RESULT" ]]; then
  python3 - "$RESULT" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path) as f:
  text = f.read()

text = re.sub(r'<!--.*?-->', '', text, flags=re.DOTALL)
def keep_alt(m):
  alt = m.group(1).strip()
  return alt if alt else ''

text = re.sub(r'!\[(.*?)\]\(ppt/media/[^)]+\)', keep_alt, text, flags=re.DOTALL)
text = re.sub(r'^- $', '', text, flags=re.MULTILINE)
text = re.sub(r'\n{3,}', '\n\n', text)

with open(path, 'w') as f:
  f.write(text.strip() + '\n')
PYEOF
fi

DURATION=$(( $(date +%s) - START ))
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# Comptage des slides via le ZIP interne du .pptx
SLIDES=$(python3 - "$FILE" <<'PYEOF'
import zipfile, sys
try:
  with zipfile.ZipFile(sys.argv[1]) as z:
    count = sum(1 for n in z.namelist() if n.startswith('ppt/slides/slide') and n.endswith('.xml'))
  print(count)
except Exception:
  print('-')
PYEOF
)

if [[ -f "$RESULT" ]]; then
  echo ""
  echo "✅ Converti : $RESULT (${DURATION}s)"
  echo "   Slides traités : ${SLIDES}"
  echo "   ℹ️  Images non incluses — texte et titres uniquement"
  printf "%s | OK   | %4ds | %3s slides | pandoc | %s\n" "$TIMESTAMP" "$DURATION" "$SLIDES" "$(basename "$FILE")" >> "$LOG"
else
  echo "❌ Échec de la conversion — vérifier que le fichier n'est pas protégé"
  printf "%s | FAIL | %4ds | %3s slides | pandoc | %s\n" "$TIMESTAMP" "$DURATION" "$SLIDES" "$(basename "$FILE")" >> "$LOG"
  exit 1
fi
