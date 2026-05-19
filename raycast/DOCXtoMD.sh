#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title DOCX to MD
# @raycast.mode fullOutput
# @raycast.packageName Pandoc

# Optional parameters:
# @raycast.icon 📝
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .docx (ou sélection Finder)", "optional": true }

# Documentation:
# @raycast.description Convertir un fichier Word (.docx) en Markdown via pandoc — texte, titres et tableaux extraits, images décrites
# @raycast.author Marcou
# @raycast.authorURL https://github.com/marcou

# =============================================================================
# BRIEF
# Projet  : pandoc-macos-toolkit
# Script  : DOCXtoMD — conversion fichier unique DOCX → Markdown
# Moteur  : pandoc --wrap=none (texte, titres, tableaux ; images décrites)
# Source  : fichier .docx sélectionné dans Finder ou passé en argument
# Sortie  : /Volumes/Andromede/fiches_de_cas_antea/markdown/<nom>.md
# Log     : ~/.pandoc_history.log (format pipe-separated, cohérent PPTtoMD)
# Branche : feat/new-converters — à merger sur main après validation
# Ordre   : 2/3 (PPTtoMD → DOCXtoMD → batch)
# Export  : ./DOCXtoMD.sh --brief > DOCXtoMD-brief.md
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

if [[ ! "$FILE" =~ \.docx$ ]]; then
  echo "⚠️  Pas un fichier Word : $FILE"
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

OUTPUT_DIR="/Volumes/Andromede/fiches_de_cas_antea/markdown"
BASENAME=$(basename "${FILE%.*}")
RESULT="$OUTPUT_DIR/${BASENAME}.md"
START=$(date +%s)

if [[ ! -d "$OUTPUT_DIR" ]]; then
  echo "❌ Dossier de sortie introuvable — volume Andromede monté ?"
  exit 1
fi

echo "📝 Fichier  : $(basename "$FILE")"
echo "📁 Sortie   : $OUTPUT_DIR"
echo "⏳ Conversion en cours…"

# Conversion — -t plain : texte brut sans markup, optimal pour RAG/embeddings
pandoc "$FILE" -t plain --wrap=none -o "$RESULT" 2>&1

DURATION=$(( $(date +%s) - START ))
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

# Comptage des pages via docProps/app.xml dans le ZIP interne du .docx
PAGES=$(python3 - "$FILE" <<'PYEOF'
import zipfile, xml.etree.ElementTree as ET, sys
try:
  with zipfile.ZipFile(sys.argv[1]) as z:
    with z.open('docProps/app.xml') as f:
      tree = ET.parse(f)
      ns = {'ep': 'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties'}
      pages = tree.find('.//ep:Pages', ns)
      print(pages.text if pages is not None else '-')
except Exception:
  print('-')
PYEOF
)

# Post-traitement : aplatissement des tables Word + nettoyage artefacts pandoc
# Les fiches DOCX sont entièrement structurées en tableaux — pandoc les rend
# en grilles ASCII même avec -t plain. On extrait le texte des cellules.
if [[ -f "$RESULT" ]]; then
  python3 - "$RESULT" <<'PYEOF'
import re, sys

path = sys.argv[1]
with open(path) as f:
  lines = f.readlines()

out = []
for line in lines:
  # Lignes de séparation de grille (+---+ ou +===+) → ignorées
  if re.match(r'^\s*[+|][+\-=|: ]+$', line):
    continue
  # Cellules de tableau multi-colonnes → splitter sur | et garder les cellules non vides
  if line.startswith('|'):
    cells = [c.strip() for c in line.split('|') if c.strip() and c.strip() not in ('[]', '[ ]')]
    if cells:
      out.extend(c + '\n' for c in cells)
    continue
  # Références images : conserver l'alt text, supprimer la syntaxe
  line = re.sub(r'!\[(.*?)\]\([^)]+\)', lambda m: m.group(1).strip(), line, flags=re.DOTALL)
  # Listes vides et balises HTML
  if re.match(r'^- $', line.strip()):
    continue
  line = re.sub(r'<!--.*?-->', '', line, flags=re.DOTALL)
  out.append(line)

text = ''.join(out)
text = re.sub(r'\n{3,}', '\n\n', text)

with open(path, 'w') as f:
  f.write(text.strip() + '\n')
PYEOF
fi

if [[ -f "$RESULT" ]]; then
  echo ""
  echo "✅ Converti : $RESULT (${DURATION}s)"
  echo "   Pages    : ${PAGES}"
  printf "%s | OK   | %4ds | %3s pages | pandoc | %s\n" "$TIMESTAMP" "$DURATION" "$PAGES" "$(basename "$FILE")" >> "$LOG"
else
  echo "❌ Échec de la conversion — vérifier que le fichier n'est pas protégé"
  printf "%s | FAIL | %4ds | %3s pages | pandoc | %s\n" "$TIMESTAMP" "$DURATION" "$PAGES" "$(basename "$FILE")" >> "$LOG"
  exit 1
fi
