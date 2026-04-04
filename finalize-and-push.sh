#!/bin/zsh
# Finalisation : Copie fichiers + Push GitHub

echo "🔧 Finalisation Pandoc Toolkit"
echo "=============================="
echo ""

# Vérifier qu'on est dans le bon dossier
if [ ! -d "raycast" ] || [ ! -d "install" ]; then
    echo "❌ Erreur : Lancer ce script depuis '2026-01-26 Projet Final Pandoc/'"
    exit 1
fi

echo "📂 Copie des fichiers depuis pandoc-setup-final/..."
echo ""

# Copier les scripts d'installation
if [ -d "pandoc-setup-final" ]; then
    echo "📁 install/..."
    cp pandoc-setup-final/install-pandoc-shell-fixed.sh install/ 2>/dev/null && echo "  ✅ install-pandoc-shell-fixed.sh"
    cp pandoc-setup-final/update-markdown-strict-plus-tables.sh install/ 2>/dev/null && echo "  ✅ update-markdown-strict-plus-tables.sh"
    cp pandoc-setup-final/install-raycast-scripts.sh install/ 2>/dev/null && echo "  ✅ install-raycast-scripts.sh"
    cp pandoc-setup-final/update-all-markdown-strict.sh install/ 2>/dev/null && echo "  ✅ update-all-markdown-strict.sh"
    
    echo ""
    echo "📁 raycast/..."
    cp pandoc-setup-final/pandoc-docx.sh raycast/ 2>/dev/null && echo "  ✅ pandoc-docx.sh"
    cp pandoc-setup-final/pandoc-pdf.sh raycast/ 2>/dev/null && echo "  ✅ pandoc-pdf.sh"
    cp pandoc-setup-final/pandoc-html.sh raycast/ 2>/dev/null && echo "  ✅ pandoc-html.sh"
    cp pandoc-setup-final/pandoc-pages.sh raycast/ 2>/dev/null && echo "  ✅ pandoc-pages.sh"
    
    echo ""
    echo "📁 editors/..."
    cp pandoc-setup-final/Pandoc-Absolute.sublime-build editors/ 2>/dev/null && echo "  ✅ Pandoc-Absolute.sublime-build"
    cp pandoc-setup-final/vscode-tasks-absolute.json editors/ 2>/dev/null && echo "  ✅ vscode-tasks-absolute.json"
    
    echo ""
    echo "📁 docs/..."
    cp pandoc-setup-final/GUIDE-REFERENCE-PANDOC.md docs/ 2>/dev/null && echo "  ✅ GUIDE-REFERENCE-PANDOC.md"
    
    echo ""
    echo "📁 utils/..."
    cp pandoc-setup-final/debug-services.sh utils/ 2>/dev/null && echo "  ✅ debug-services.sh"
    
    # Copier aussi depuis le dossier scripts/ s'il existe
    if [ -d "scripts" ]; then
        echo ""
        echo "📁 Copie depuis scripts/..."
        cp scripts/*.sh install/ 2>/dev/null
        echo "  ✅ Scripts copiés"
    fi
else
    echo "⚠️  Dossier pandoc-setup-final non trouvé"
    echo "   Copie depuis scripts/ si disponible..."
    
    if [ -d "scripts" ]; then
        cp scripts/*.sh install/ 2>/dev/null
        echo "  ✅ Scripts d'installation copiés"
    fi
fi

echo ""
echo "✅ Fichiers copiés"
echo ""

# Rendre les scripts exécutables
echo "🔧 Configuration des permissions..."
chmod +x install/*.sh 2>/dev/null
chmod +x raycast/*.sh 2>/dev/null
chmod +x utils/*.sh 2>/dev/null
echo "✅ Scripts rendus exécutables"
echo ""

# Vérifier que les fichiers sont bien là
echo "🔍 Vérification raycast/..."
if [ -f "raycast/pandoc-docx.sh" ]; then
    echo "✅ Scripts Raycast présents"
    ls -l raycast/
else
    echo "⚠️  Scripts Raycast manquants"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Mise à jour Pandoc (tableaux)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "install/update-markdown-strict-plus-tables.sh" ]; then
    chmod +x install/update-markdown-strict-plus-tables.sh
    cd install
    ./update-markdown-strict-plus-tables.sh
    cd ..
    echo ""
    echo "✅ Pandoc mis à jour avec support tableaux"
else
    echo "⚠️  Script de mise à jour non trouvé"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📤 Push sur GitHub"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Vérifier que Git est initialisé
if [ ! -d ".git" ]; then
    echo "📦 Initialisation Git..."
    git init
    git add .
    git commit -m "Initial commit: Pandoc macOS Toolkit"
fi

# Ajouter les changements
echo "📝 Ajout des fichiers à Git..."
git add .

# Compter les changements
CHANGES=$(git status --porcelain | wc -l)

if [ $CHANGES -gt 0 ]; then
    echo "📊 $CHANGES fichier(s) modifié(s)"
    
    # Commit
    git commit -m "Add all Pandoc scripts and documentation

- Shell functions with markdown_strict + pipe_tables + fenced_code_blocks
- Raycast scripts (DOCX, PDF, HTML, Pages)  
- Sublime Text and VS Code configurations
- Complete documentation in docs/
- Utils and debug scripts"
    
    echo "✅ Commit créé"
else
    echo "ℹ️  Aucun changement à committer"
fi

echo ""

# Vérifier la remote
if ! git remote | grep -q "origin"; then
    echo "🔗 Configuration de la remote GitHub..."
    read "username?Entrez votre username GitHub : "
    
    if [ -n "$username" ]; then
        git remote add origin "https://github.com/$username/pandoc-macos-toolkit.git"
        echo "✅ Remote configurée"
    else
        echo "⚠️  Username vide, skip remote"
    fi
fi

# Afficher la remote
echo ""
echo "📍 Remote configurée :"
git remote -v

echo ""
echo "🚀 Pour pousser sur GitHub :"
echo "   git push -u origin main"
echo ""

read "push_response?Pousser maintenant ? (o/n) "

if [[ "$push_response" =~ ^[oOyY]$ ]]; then
    echo ""
    echo "📤 Push en cours..."
    git branch -M main
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Push réussi !"
        echo "🌐 Voir ton repo : https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')"
    else
        echo ""
        echo "⚠️  Erreur lors du push"
        echo "Vérifie que le repo existe sur github.com"
    fi
else
    echo ""
    echo "✅ Push skip - Tu peux le faire plus tard avec :"
    echo "   git push -u origin main"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Finalisation terminée !"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Structure complète :"
tree -L 2 -I '.git' 2>/dev/null || ls -la
echo ""
echo "🧪 Test immédiat :"
echo "   md2docx CapSatory_Synthese_Consolidee_v3.md"
echo ""
echo "🚀 Enjoy your Pandoc Toolkit!"
echo ""
