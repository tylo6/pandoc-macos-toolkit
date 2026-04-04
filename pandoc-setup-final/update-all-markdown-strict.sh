#!/bin/zsh
# Mise à jour complète : markdown_strict partout

echo "🔧 Mise à jour Pandoc → markdown_strict"
echo "========================================"
echo ""

# Backup .zshrc
BACKUP="$HOME/.zshrc.backup-$(date +%Y%m%d-%H%M%S)"
cp ~/.zshrc "$BACKUP"
echo "✅ Backup : $BACKUP"
echo ""

# Nouvelles fonctions avec markdown_strict
cat >> ~/.zshrc << 'EOFFUNCTIONS'

# === FONCTIONS PANDOC (markdown_strict) ===

md2docx() {
    if [ $# -eq 0 ]; then
        echo "Usage: md2docx fichier.md [fichier2.md ...]"
        return 1
    fi
    
    for file in "$@"; do
        if [[ "$file" == *.md ]] || [[ "$file" == *.markdown ]]; then
            output="${file%.*}.docx"
            pandoc "$file" -s --toc -f markdown_strict -o "$output" && \
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
                -f markdown_strict \
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
                -f markdown_strict \
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
            pandoc "$file" -s --toc -f markdown_strict -o "$output" && \
            echo "✅ Créé: $output"
            open -a Pages "$output" && \
            echo "📄 Ouvert dans Pages"
        else
            echo "⚠️  Ignoré: $file"
        fi
    done
}

# Aliases
alias pd2docx='md2docx'
alias md2page='md2pages'

EOFFUNCTIONS

echo "✅ Fonctions shell mises à jour avec markdown_strict"
echo ""

# Recharger
source ~/.zshrc
echo "✅ .zshrc rechargé"
echo ""

# Mise à jour Sublime
SUBLIME_PATH="$HOME/Library/Application Support/Sublime Text/Packages/User/Pandoc-Absolute.sublime-build"

if [ -f "$SUBLIME_PATH" ]; then
    echo "📝 Mise à jour Sublime Text..."
    
    cat > "$SUBLIME_PATH" << 'EOFSUBLIME'
{
    "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc -f markdown_strict -o '${file_path}/${file_base_name}.docx'",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "working_dir": "${file_path}",
    "selector": "text.html.markdown",
    
    "variants": [
        {
            "name": "PDF",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc --pdf-engine=xelatex -f markdown_strict -V geometry:margin=2.5cm -V fontsize=12pt -o '${file_path}/${file_base_name}.pdf'"
        },
        {
            "name": "HTML",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc --self-contained -f markdown_strict --metadata title='${file_base_name}' -o '${file_path}/${file_base_name}.html'"
        },
        {
            "name": "Pages",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc -f markdown_strict -o '${file_path}/${file_base_name}.docx' && open -a Pages '${file_path}/${file_base_name}.docx'"
        },
        {
            "name": "All formats",
            "shell_cmd": "source /Users/marcou/.zshrc && pandoc '$file' -s --toc -f markdown_strict -o '${file_path}/${file_base_name}.docx' && pandoc '$file' -s --toc --pdf-engine=xelatex -f markdown_strict -V geometry:margin=2.5cm -o '${file_path}/${file_base_name}.pdf' && pandoc '$file' -s --toc --self-contained -f markdown_strict -o '${file_path}/${file_base_name}.html'"
        }
    ]
}
EOFSUBLIME
    
    echo "✅ Sublime Text mis à jour"
else
    echo "⚠️  Sublime Build System non trouvé (skip)"
fi

echo ""

# Mise à jour VS Code
VSCODE_PATH="$HOME/Documents/Obsidian Vault/03-PROJETS/Developpements/Claude Dev/.vscode/tasks.json"

if [ -f "$VSCODE_PATH" ]; then
    echo "📝 Mise à jour VS Code..."
    
    cat > "$VSCODE_PATH" << 'EOFVSCODE'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Pandoc: DOCX",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc -f markdown_strict -o '${fileDirname}/${fileBasenameNoExtension}.docx'",
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
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc --pdf-engine=xelatex -f markdown_strict -V geometry:margin=2.5cm -V fontsize=12pt -o '${fileDirname}/${fileBasenameNoExtension}.pdf'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: HTML",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc --self-contained -f markdown_strict --metadata title='${fileBasenameNoExtension}' -o '${fileDirname}/${fileBasenameNoExtension}.html'",
            "group": "build",
            "presentation": {
                "reveal": "always"
            },
            "problemMatcher": []
        },
        {
            "label": "Pandoc: Pages",
            "type": "shell",
            "command": "source /Users/marcou/.zshrc && pandoc '${file}' -s --toc -f markdown_strict -o '${fileDirname}/${fileBasenameNoExtension}.docx' && open -a Pages '${fileDirname}/${fileBasenameNoExtension}.docx'",
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
    echo "⚠️  VS Code tasks.json non trouvé (skip)"
fi

echo ""

# Mise à jour Raycast
RAYCAST_DIR="$HOME/Documents/Raycast-Scripts"

if [ -d "$RAYCAST_DIR" ]; then
    echo "📝 Mise à jour Raycast scripts..."
    
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
pandoc "$FILE" -s --toc -f markdown_strict -o "$OUTPUT"

if [[ -f "$OUTPUT" ]]; then
    echo "✅ Créé: $(basename "$OUTPUT")"
    open -R "$OUTPUT"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCAST
    
    chmod +x "$RAYCAST_DIR/pandoc-docx.sh"
    echo "   ✅ pandoc-docx.sh"
    
    # Script PDF (similaire)
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
pandoc "$(basename "$FILE")" -s --toc --pdf-engine=xelatex -f markdown_strict -V geometry:margin=2.5cm -V fontsize=12pt -o "$(basename "$OUTPUT")"

if [[ -f "$OUTPUT" ]]; then
    echo "✅ Créé: $(basename "$OUTPUT")"
    open -R "$OUTPUT"
else
    echo "❌ Échec"
    exit 1
fi
EOFRAYCASTPDF
    
    chmod +x "$RAYCAST_DIR/pandoc-pdf.sh"
    echo "   ✅ pandoc-pdf.sh"
    
    echo "✅ Raycast scripts mis à jour"
else
    echo "⚠️  Raycast Scripts non trouvé (skip)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Mise à jour complète terminée!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Fonctions shell : markdown_strict"
echo "✅ Sublime Text : markdown_strict"
echo "✅ VS Code : markdown_strict"
echo "✅ Raycast : markdown_strict"
echo ""
echo "🧪 Test immédiat :"
echo "   md2docx test-markdown-pandoc.md"
echo "   open test-markdown-pandoc.docx"
echo ""
echo "📝 Plus de crochets parasites ! ✅"
echo ""
