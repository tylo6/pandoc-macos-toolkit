#!/bin/zsh
# Mise à jour : markdown_strict avec tableaux et blocs de code (VERSION CORRIGÉE)

echo "🔧 Mise à jour Pandoc → markdown_strict + extensions"
echo "===================================================="
echo ""
echo "Extensions ajoutées :"
echo "  • pipe_tables (tableaux | col |)"
echo "  • fenced_code_blocks (blocs \`\`\`)"
echo "  • backtick_code_blocks (code inline)"
echo ""

# Format Pandoc amélioré
PANDOC_FORMAT="markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks"

# Backup .zshrc
BACKUP="$HOME/.zshrc.backup-$(date +%Y%m%d-%H%M%S)"
cp ~/.zshrc "$BACKUP"
echo "✅ Backup : $BACKUP"
echo ""

# Supprimer les anciennes fonctions pandoc
echo "🗑️  Suppression anciennes fonctions..."
awk '/^# === FONCTIONS PANDOC/,/^# Aliases/{if (/^# Aliases/) print; next} {print}' ~/.zshrc > ~/.zshrc.tmp
mv ~/.zshrc.tmp ~/.zshrc

# Ajouter les nouvelles fonctions
cat >> ~/.zshrc << 'EOFFUNCTIONS'

# === FONCTIONS PANDOC (markdown_strict + extensions) ===

md2docx() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2docx fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.docx"
            pandoc "$file" -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

md2pdf() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2pdf fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.pdf"
            pandoc "$file" -s --toc --pdf-engine=xelatex \
                -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks \
                -V geometry:margin=2.5cm -V fontsize=12pt \
                -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

md2html() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2html fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.html"
            pandoc "$file" -s --toc --self-contained \
                -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks \
                --metadata title="$(basename "${file%.*}")" \
                -o "$output" && \
            echo "✅ Créé: $output"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

md2all() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2all fichier.md"
        return 1
    fi
    
    echo "🔄 Conversion tous formats..."
    md2docx "$1"
    md2pdf "$1"
    md2html "$1"
    echo "✅ Tous les formats créés!"
}

md2pages() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2pages fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.docx"
            pandoc "$file" -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o "$output" && \
            echo "✅ Créé: $output"
            open -a Pages "$output" && \
            echo "📄 Ouvert dans Pages"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

md2docx-batch() {
    local count=0
    for file in *.md; do
        if [ -f "$file" ]; then
            md2docx "$file"
            ((count++))
        fi
    done
    echo "✅ $count fichier(s) converti(s)"
}

# Aliases
alias pd2docx='md2docx'
alias md2page='md2pages'

EOFFUNCTIONS

echo "✅ Fonctions shell mises à jour"
echo ""

# Recharger
source ~/.zshrc
echo "✅ .zshrc rechargé"
echo ""

# Mise à jour Sublime Text
SUBLIME_PATH="$HOME/Library/Application Support/Sublime Text/Packages/User/Pandoc-Absolute.sublime-build"

if [ -f "$SUBLIME_PATH" ]; then
    echo "📝 Mise à jour Sublime Text..."
    
    cat > "$SUBLIME_PATH" << 'EOFSUBLIME'
{
    "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o '${file_path}/${file_base_name}.docx'",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "working_dir": "${file_path}",
    "selector": "text.html.markdown",
    
    "variants": [
        {
            "name": "PDF",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc --pdf-engine=xelatex -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -V geometry:margin=2.5cm -V fontsize=12pt -o '${file_path}/${file_base_name}.pdf'"
        },
        {
            "name": "HTML",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc --self-contained -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks --metadata title='${file_base_name}' -o '${file_path}/${file_base_name}.html'"
        },
        {
            "name": "Pages",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o '${file_path}/${file_base_name}.docx' && open -a Pages '${file_path}/${file_base_name}.docx'"
        },
        {
            "name": "All formats",
            "shell_cmd": "source /Users/marcou/.zshrc && md2all '$file'"
        }
    ]
}
EOFSUBLIME
    
    echo "✅ Sublime Text mis à jour"
else
    echo "⚠️  Sublime Build System non trouvé (skip)"
fi

echo ""

# Recherche du fichier VS Code tasks.json
echo "🔍 Recherche de tasks.json VS Code..."
VSCODE_TASKS=$(find "$HOME/Documents" -name "tasks.json" -path "*/.vscode/*" 2>/dev/null | head -1)

if [ -n "$VSCODE_TASKS" ]; then
    echo "📝 Mise à jour VS Code : $VSCODE_TASKS"
    
    cat > "$VSCODE_TASKS" << 'EOFVSCODE'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Pandoc: DOCX",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o '${fileDirname}/${fileBasenameNoExtension}.docx'",
            "group": "build",
            "presentation": {
                "reveal": "always",
                "panel": "shared",
                "showReuseMessage": false,
                "clear": true
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: PDF",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc --pdf-engine=xelatex -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -V geometry:margin=2.5cm -V fontsize=12pt -o '${fileDirname}/${fileBasenameNoExtension}.pdf'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: HTML",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc --self-contained -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks --metadata title='${fileBasenameNoExtension}' -o '${fileDirname}/${fileBasenameNoExtension}.html'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: Pages",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o '${fileDirname}/${fileBasenameNoExtension}.docx' && open -a Pages '${fileDirname}/${fileBasenameNoExtension}.docx'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: All formats",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && md2all '${file}'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        }
    ]
}
EOFVSCODE
    
    echo "✅ VS Code mis à jour"
else
    echo "⚠️  tasks.json VS Code non trouvé (skip)"
fi

echo ""

# Mise à jour scripts Raycast
RAYCAST_DIR="$HOME/Documents/Raycast-Scripts"

if [ -d "$RAYCAST_DIR" ]; then
    echo "📝 Mise à jour scripts Raycast..."
    
    # Script DOCX
    cat > "$RAYCAST_DIR/pandoc-docx.sh" << 'EOFRAYCAST'
#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → DOCX
# @raycast.mode fullOutput
# @raycast.packageName Pandoc
# @raycast.icon 📄
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md", "optional": true }

export PATH="/Library/TeX/texbin:$PATH"
source "$HOME/.zshrc"

if [[ -n "$1" ]]; then
    FILE="$1"
else
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(md|markdown)$ ]]; then
    echo "❌ Fichier Markdown requis"
    exit 1
fi

OUTPUT="${FILE%.*}.docx"
pandoc "$FILE" -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o "$OUTPUT"

if [[ -f "$OUTPUT" ]]; then
    echo "✅ Créé: $(basename "$OUTPUT")"
    open -R "$OUTPUT"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCAST
    
    chmod +x "$RAYCAST_DIR/pandoc-docx.sh"
    
    # Script PDF
    cat > "$RAYCAST_DIR/pandoc-pdf.sh" << 'EOFRAYCASTPDF'
#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → PDF
# @raycast.mode fullOutput
# @raycast.packageName Pandoc
# @raycast.icon 📕
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md", "optional": true }

export PATH="/Library/TeX/texbin:$PATH"
source "$HOME/.zshrc"

if [[ -n "$1" ]]; then
    FILE="$1"
else
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(md|markdown)$ ]]; then
    echo "❌ Fichier Markdown requis"
    exit 1
fi

OUTPUT="${FILE%.*}.pdf"
cd "$(dirname "$FILE")"
pandoc "$(basename "$FILE")" -s --toc --pdf-engine=xelatex -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -V geometry:margin=2.5cm -V fontsize=12pt -o "$(basename "$OUTPUT")"

if [[ -f "$OUTPUT" ]]; then
    echo "✅ Créé: $(basename "$OUTPUT")"
    open -R "$OUTPUT"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCASTPDF
    
    chmod +x "$RAYCAST_DIR/pandoc-pdf.sh"
    
    # Script HTML
    cat > "$RAYCAST_DIR/pandoc-html.sh" << 'EOFRAYCASTHTML'
#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → HTML
# @raycast.mode fullOutput
# @raycast.packageName Pandoc
# @raycast.icon 🌐
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md", "optional": true }

export PATH="/Library/TeX/texbin:$PATH"
source "$HOME/.zshrc"

if [[ -n "$1" ]]; then
    FILE="$1"
else
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(md|markdown)$ ]]; then
    echo "❌ Fichier Markdown requis"
    exit 1
fi

OUTPUT="${FILE%.*}.html"
pandoc "$FILE" -s --toc --self-contained -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks --metadata title="$(basename "${FILE%.*}")" -o "$OUTPUT"

if [[ -f "$OUTPUT" ]]; then
    echo "✅ Créé: $(basename "$OUTPUT")"
    open -R "$OUTPUT"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCASTHTML
    
    chmod +x "$RAYCAST_DIR/pandoc-html.sh"
    
    # Script Pages
    cat > "$RAYCAST_DIR/pandoc-pages.sh" << 'EOFRAYCASTPAGES'
#!/bin/zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pandoc → Pages
# @raycast.mode fullOutput
# @raycast.packageName Pandoc
# @raycast.icon 📃
# @raycast.argument1 { "type": "text", "placeholder": "Fichier .md", "optional": true }

export PATH="/Library/TeX/texbin:$PATH"
source "$HOME/.zshrc"

if [[ -n "$1" ]]; then
    FILE="$1"
else
    FILE=$(osascript -e 'tell application "Finder" to get POSIX path of (selection as alias)' 2>/dev/null)
fi

if [[ -z "$FILE" ]] || [[ ! "$FILE" =~ \.(md|markdown)$ ]]; then
    echo "❌ Fichier Markdown requis"
    exit 1
fi

OUTPUT="${FILE%.*}.docx"
pandoc "$FILE" -s --toc -f markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks -o "$OUTPUT"

if [[ -f "$OUTPUT" ]]; then
    open -a Pages "$OUTPUT"
    echo "✅ Créé et ouvert dans Pages: $(basename "$OUTPUT")"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCASTPAGES
    
    chmod +x "$RAYCAST_DIR/pandoc-pages.sh"
    
    echo "✅ 4 scripts Raycast mis à jour"
else
    echo "⚠️  Dossier Raycast-Scripts non trouvé (skip)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Mise à jour complète terminée!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Format Pandoc : markdown_strict+pipe_tables+fenced_code_blocks+backtick_code_blocks"
echo ""
echo "🆕 Fonctionnalités activées :"
echo "   • ✅ Tableaux pipe tables | col |"
echo "   • ✅ Blocs de code \`\`\`"
echo "   • ✅ Code inline \`code\`"
echo "   • ✅ Pas de crochets parasites"
echo ""
echo "🧪 Test immédiat :"
echo "   md2docx votre-fichier-avec-tableaux.md"
echo ""
echo "📝 Les tableaux devraient maintenant être convertis correctement !"
echo ""
