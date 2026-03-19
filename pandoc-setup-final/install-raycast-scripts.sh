#!/bin/zsh
# Installation des scripts Raycast pour Pandoc

echo "🚀 Installation Scripts Raycast - Pandoc"
echo "========================================"
echo ""

# Créer le dossier Raycast Scripts s'il n'existe pas
RAYCAST_DIR="$HOME/Documents/Raycast-Scripts"

if [ ! -d "$RAYCAST_DIR" ]; then
    echo "📁 Création du dossier Raycast Scripts..."
    mkdir -p "$RAYCAST_DIR"
    echo "✅ Dossier créé : $RAYCAST_DIR"
else
    echo "✅ Dossier existant : $RAYCAST_DIR"
fi

echo ""
echo "📝 Installation des scripts..."
echo ""

# Copier les scripts
SCRIPTS=(
    "pandoc-docx.sh"
    "pandoc-pdf.sh"
    "pandoc-html.sh"
    "pandoc-pages.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        cp "$script" "$RAYCAST_DIR/"
        chmod +x "$RAYCAST_DIR/$script"
        echo "   ✅ $(basename "$script" .sh)"
    else
        echo "   ⚠️  $script non trouvé (skip)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Installation terminée!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Scripts installés :"
echo "   • Pandoc → DOCX"
echo "   • Pandoc → PDF"
echo "   • Pandoc → HTML"
echo "   • Pandoc → Pages"
echo ""
echo "🎯 Configuration Raycast :"
echo ""
echo "1️⃣  Ouvrir Raycast (Cmd+Space ou ton raccourci)"
echo "2️⃣  Taper 'extensions'"
echo "3️⃣  Script Commands → ⚙️"
echo "4️⃣  Add Script Directory → Choisir :"
echo "    $RAYCAST_DIR"
echo "5️⃣  ✅ Scripts détectés automatiquement!"
echo ""
echo "⚡ Utilisation :"
echo ""
echo "   Méthode 1 (recommandée) :"
echo "   • Sélectionner un .md dans Finder"
echo "   • Cmd+Space (Raycast)"
echo "   • Taper 'pandoc docx' (ou pdf, html, pages)"
echo "   • Enter → Converti !"
echo ""
echo "   Méthode 2 (raccourci direct) :"
echo "   • Raycast → Extensions → Script Commands"
echo "   • Clic sur 'Pandoc → DOCX'"
echo "   • Record Hotkey → Assigner Cmd+Shift+D"
echo "   • Maintenant : Sélectionner .md → Cmd+Shift+D → Converti !"
echo ""
echo "💡 Raccourcis suggérés :"
echo "   • Pandoc → DOCX  : Cmd+Shift+D"
echo "   • Pandoc → PDF   : Cmd+Shift+P"
echo "   • Pandoc → HTML  : Cmd+Shift+H"
echo "   • Pandoc → Pages : Cmd+Shift+G"
echo ""
