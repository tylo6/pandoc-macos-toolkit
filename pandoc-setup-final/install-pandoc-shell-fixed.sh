#!/bin/zsh
# Installation ultra-rapide de Pandoc dans le shell
# Version corrigée pour macOS - Force zsh

set -e

echo "🚀 Installation Pandoc Shell Functions"
echo "======================================"
echo ""

# Forcer zsh sur macOS
SHELL_RC="$HOME/.zshrc"
SHELL_NAME="zsh"

echo "✓ Shell: $SHELL_NAME (macOS default)"
echo "✓ Fichier de config: $SHELL_RC"
echo ""

# Créer .zshrc s'il n'existe pas
if [ ! -f "$SHELL_RC" ]; then
    echo "ℹ️  Création de $SHELL_RC (première fois)"
    touch "$SHELL_RC"
fi

# Vérifier Pandoc
if ! command -v pandoc &> /dev/null; then
    echo "❌ Pandoc non installé!"
    echo "   Installation: brew install pandoc"
    exit 1
fi

PANDOC_PATH=$(which pandoc)
echo "✓ Pandoc: $PANDOC_PATH"
echo ""

# Créer backup du RC file (seulement s'il existe et n'est pas vide)
if [ -s "$SHELL_RC" ]; then
    BACKUP_FILE="$SHELL_RC.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$SHELL_RC" "$BACKUP_FILE"
    echo "✓ Backup créé: $BACKUP_FILE"
else
    echo "ℹ️  Pas de backup (fichier vide ou nouveau)"
fi
echo ""

# Vérifier si déjà installé
if grep -q "# Pandoc Functions - Installation auto" "$SHELL_RC" 2>/dev/null; then
    echo "⚠️  Les fonctions Pandoc semblent déjà installées!"
    echo ""
    read -r "response?Réinstaller quand même ? (y/n): "
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Installation annulée"
        exit 0
    fi
fi

echo "📝 Ajout des fonctions Pandoc..."

# Ajouter les fonctions
cat >> "$SHELL_RC" << 'EOFUNCTIONS'

# ============================================
# 📝 Pandoc Functions - Installation auto
# ============================================

# Conversion Markdown → DOCX
md2docx() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2docx fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.docx"
            pandoc "$file" -s --toc -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file (pas un fichier .md)"
        fi
    done
}

# Conversion Markdown → PDF
md2pdf() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2pdf fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.pdf"
            pandoc "$file" -s --toc \
                --pdf-engine=xelatex \
                -V geometry:margin=2.5cm \
                -V fontsize=12pt \
                -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

# Conversion Markdown → HTML
md2html() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2html fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.html"
            pandoc "$file" -s --toc \
                --self-contained \
                --metadata title="$(basename "${file%.*}")" \
                -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

# Conversion Markdown → tous les formats
md2all() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2all fichier.md"
        return 1
    fi
    
    echo "🔄 Conversion vers tous les formats..."
    md2docx "$1"
    md2pdf "$1"
    md2html "$1"
    echo "✅ Terminé!"
}

# Conversion batch de tous les .md du dossier courant
md2docx-batch() {
    local count=0
    for file in *.md; do
        [ -e "$file" ] || continue
        md2docx "$file"
        ((count++))
    done
    echo "✅ $count fichiers convertis"
}

# Fonction avec options avancées
mdconv() {
    local format="docx"
    local output=""
    local input=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--format)
                format="$2"
                shift 2
                ;;
            -o|--output)
                output="$2"
                shift 2
                ;;
            *)
                input="$1"
                shift
                ;;
        esac
    done
    
    if [ -z "$input" ]; then
        echo "Usage: mdconv [-f format] [-o output] fichier.md"
        echo "Formats: docx, pdf, html, epub, odt"
        return 1
    fi
    
    [ -z "$output" ] && output="${input%.*}.$format"
    
    pandoc "$input" -s --toc -o "$output" && \
    echo "✅ Créé: $output"
}

# Alias courts
alias pd2docx='md2docx'
alias pd2pdf='md2pdf'
alias pd2html='md2html'

EOFUNCTIONS

echo "✅ Fonctions ajoutées à $SHELL_RC"
echo ""

# Créer fichier de test
TEST_FILE="$HOME/Desktop/test-pandoc.md"
cat > "$TEST_FILE" << 'EOFTEST'
# Test Pandoc

Ceci est un **test** de conversion ultra-rapide.

## Features

- Conversion instantanée
- Pas de GUI
- 100% terminal
- Optimisé Brew

## Code

```python
def convert():
    print("Fast conversion!")
```

---

*Généré automatiquement*
EOFTEST

echo "✅ Fichier de test créé: $TEST_FILE"
echo ""

echo "🎯 Prochaines étapes:"
echo ""
echo "1️⃣  Recharger zsh:"
echo "   source ~/.zshrc"
echo ""
echo "2️⃣  Tester:"
echo "   cd ~/Desktop"
echo "   md2docx test-pandoc.md"
echo ""

echo "📚 Commandes disponibles après rechargement:"
echo "   md2docx fichier.md    → Convertir en DOCX"
echo "   md2pdf fichier.md     → Convertir en PDF"
echo "   md2html fichier.md    → Convertir en HTML"
echo "   md2all fichier.md     → Tous les formats"
echo "   md2docx-batch         → Tous les .md du dossier"
echo "   mdconv -f pdf file.md → Conversion avancée"
echo ""

echo "🎉 Installation terminée!"
echo ""
echo "⚡ N'oublie pas de recharger:"
echo "   source ~/.zshrc"
