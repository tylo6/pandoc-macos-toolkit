#!/bin/zsh
# Script tout-en-un : Organisation + GitHub + Mise à jour tableaux

echo "🚀 Pandoc macOS Toolkit - Setup complet"
echo "========================================"
echo ""

# Détection du dossier actuel
CURRENT_DIR=$(pwd)
echo "📂 Dossier actuel : $CURRENT_DIR"
echo ""

# Demander confirmation
echo "Ce script va :"
echo "  1. Réorganiser les fichiers dans une structure propre"
echo "  2. Initialiser Git"
echo "  3. Mettre à jour Pandoc avec support tableaux"
echo "  4. Préparer pour GitHub (optionnel)"
echo ""
read "response?Continuer ? (o/n) "

if [[ ! "$response" =~ ^[oOyY]$ ]]; then
    echo "Annulé."
    exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Étape 1 : Organisation des fichiers"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Créer la structure
mkdir -p install raycast editors docs utils

# Déplacer les fichiers d'installation
echo "📁 Organisation install/..."
[ -f install-pandoc-shell-fixed.sh ] && mv install-pandoc-shell-fixed.sh install/
[ -f install-pandoc-shell.sh ] && mv install-pandoc-shell.sh install/
[ -f update-all-markdown-strict.sh ] && mv update-all-markdown-strict.sh install/
[ -f update-markdown-strict-plus-tables.sh ] && mv update-markdown-strict-plus-tables.sh install/
[ -f install-raycast-scripts.sh ] && mv install-raycast-scripts.sh install/

# Déplacer les scripts Raycast
echo "📁 Organisation raycast/..."
[ -f pandoc-docx.sh ] && mv pandoc-docx.sh raycast/
[ -f pandoc-pdf.sh ] && mv pandoc-pdf.sh raycast/
[ -f pandoc-html.sh ] && mv pandoc-html.sh raycast/
[ -f pandoc-pages.sh ] && mv pandoc-pages.sh raycast/

# Déplacer les configs éditeurs
echo "📁 Organisation editors/..."
[ -f Pandoc-Absolute.sublime-build ] && mv Pandoc-Absolute.sublime-build editors/
[ -f vscode-tasks-absolute.json ] && mv vscode-tasks-absolute.json editors/

# Déplacer la documentation
echo "📁 Organisation docs/..."
[ -f GUIDE-REFERENCE-PANDOC.md ] && mv GUIDE-REFERENCE-PANDOC.md docs/
[ -f GUIDE-RAYCAST-PANDOC.md ] && mv GUIDE-RAYCAST-PANDOC.md docs/
[ -f GUIDE-SUBLIME-VSCODE.md ] && mv GUIDE-SUBLIME-VSCODE.md docs/
[ -f FIX-TABLEAUX-CODE.md ] && mv FIX-TABLEAUX-CODE.md docs/
[ -f RECAPITULATIF-FINAL.md ] && mv RECAPITULATIF-FINAL.md docs/

# Déplacer les utils
echo "📁 Organisation utils/..."
[ -f debug-services.sh ] && mv debug-services.sh utils/

echo "✅ Fichiers organisés"
echo ""

# Créer un README principal
echo "📝 Création README.md..."
cat > README.md << 'EOFREADME'
# 🚀 Pandoc macOS Toolkit

**Conversion Markdown ultra-rapide** : DOCX, PDF, HTML, Pages  
**4 méthodes d'accès** : Terminal, Raycast, Sublime Text, VS Code  
**Format optimal** : `markdown_strict` + tableaux + code (sans crochets parasites)

---

## ⚡ Installation rapide (2 minutes)

### 1. Fonctions shell (Terminal)

```bash
cd install
./install-pandoc-shell-fixed.sh
source ~/.zshrc
```

### 2. Mise à jour avec support tableaux

```bash
cd install
./update-markdown-strict-plus-tables.sh
```

### 3. Raycast Scripts (recommandé)

```bash
# Copier les scripts
cp -r raycast ~/Documents/Raycast-Scripts

# Dans Raycast : Extensions → Script Commands → Add Directory
# Sélectionner ~/Documents/Raycast-Scripts
```

### 4. Éditeurs (optionnel)

**Sublime Text** :
```bash
cp editors/Pandoc-Absolute.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/
```

**VS Code** :
```bash
mkdir -p .vscode
cp editors/vscode-tasks-absolute.json .vscode/tasks.json
```

---

## 🎯 Utilisation

### Terminal
```bash
md2docx fichier.md     # DOCX
md2pdf fichier.md      # PDF
md2html fichier.md     # HTML
md2pages fichier.md    # Pages
md2all fichier.md      # Tous formats
```

### Raycast
1. Sélectionner `.md` dans Finder
2. `Cmd+Space` → "pandoc docx"
3. Enter → Converti !

### Sublime Text
- **Cmd+B** → DOCX
- **Cmd+Shift+B** → Menu (PDF, HTML, Pages)

### VS Code
- **Cmd+Shift+B** → Menu tâches

---

## 📚 Documentation

Voir le dossier `docs/` :
- **GUIDE-REFERENCE-PANDOC.md** - Documentation complète
- **FIX-TABLEAUX-CODE.md** - Support tableaux et code
- **RECAPITULATIF-FINAL.md** - Résumé du projet

---

## 🔧 Structure du projet

```
pandoc-macos-toolkit/
├── README.md                    # Ce fichier
├── install/                     # Scripts d'installation
│   ├── install-pandoc-shell-fixed.sh
│   ├── update-markdown-strict-plus-tables.sh
│   └── install-raycast-scripts.sh
├── raycast/                     # Scripts Raycast
│   ├── pandoc-docx.sh
│   ├── pandoc-pdf.sh
│   ├── pandoc-html.sh
│   └── pandoc-pages.sh
├── editors/                     # Configurations éditeurs
│   ├── Pandoc-Absolute.sublime-build
│   └── vscode-tasks-absolute.json
├── docs/                        # Documentation
│   ├── GUIDE-REFERENCE-PANDOC.md
│   └── FIX-TABLEAUX-CODE.md
└── utils/                       # Utilitaires
    └── debug-services.sh
```

---

## ✨ Fonctionnalités

- ✅ Conversion < 1 seconde
- ✅ Tableaux pipe tables `| col |`
- ✅ Blocs de code ` ```python `
- ✅ Code inline `` `code` ``
- ✅ Pas de crochets parasites `]`
- ✅ Templates Word personnalisables
- ✅ Batch conversions

---

## 🐛 Dépannage

Voir `docs/GUIDE-REFERENCE-PANDOC.md` section Dépannage.

---

## 📄 Licence

MIT License - Libre d'utilisation et modification

---

## 🙏 Crédits

Basé sur [Pandoc](https://pandoc.org/) par John MacFarlane  
Setup optimisé pour macOS avec Raycast, Sublime Text et VS Code
EOFREADME

echo "✅ README.md créé"
echo ""

# Créer .gitignore
echo "📝 Création .gitignore..."
cat > .gitignore << 'EOFGITIGNORE'
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Backups
*.backup
*.backup-*
.zshrc.backup-*

# Logs
*.log

# Temporary files
*.tmp
*.temp

# ZIP archives (déjà sur GitHub)
*.zip

# Node modules si jamais
node_modules/

# VS Code settings locaux
.vscode/settings.json

# Obsidian
.obsidian/
EOFGITIGNORE

echo "✅ .gitignore créé"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Étape 2 : Initialisation Git"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Vérifier si Git est installé
if ! command -v git &> /dev/null; then
    echo "⚠️  Git n'est pas installé. Installation via Homebrew..."
    brew install git
fi

# Initialiser Git si pas déjà fait
if [ ! -d .git ]; then
    echo "📦 Initialisation du dépôt Git..."
    git init
    git add .
    git commit -m "Initial commit: Pandoc macOS Toolkit

- Fonctions shell avec markdown_strict + tableaux + code
- Scripts Raycast (DOCX, PDF, HTML, Pages)
- Configurations Sublime Text et VS Code
- Documentation complète
- Support tableaux pipe_tables
- Support blocs de code fenced_code_blocks
- Pas de crochets parasites"
    
    echo "✅ Premier commit créé"
else
    echo "✅ Git déjà initialisé"
    
    # Ajouter les modifications
    git add .
    git commit -m "Réorganisation : structure propre + support tableaux"
fi

echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Étape 3 : Mise à jour Pandoc (tableaux)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Lancer le script de mise à jour
if [ -f install/update-markdown-strict-plus-tables.sh ]; then
    echo "🚀 Lancement de la mise à jour..."
    chmod +x install/update-markdown-strict-plus-tables.sh
    cd install
    ./update-markdown-strict-plus-tables.sh
    cd ..
    echo ""
    echo "✅ Pandoc mis à jour avec support tableaux"
else
    echo "⚠️  Script de mise à jour non trouvé (skip)"
fi

echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📤 Étape 4 : Préparation GitHub (optionnel)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Pour publier sur GitHub :"
echo ""
echo "1️⃣  Créer un nouveau repo sur GitHub.com"
echo "   Nom suggéré : pandoc-macos-toolkit"
echo "   Description : Markdown conversion toolkit for macOS"
echo ""
echo "2️⃣  Connecter ce repo local :"
echo "   git remote add origin https://github.com/VOTRE_USERNAME/pandoc-macos-toolkit.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3️⃣  Pour les mises à jour futures :"
echo "   git add ."
echo "   git commit -m \"Description des changements\""
echo "   git push"
echo ""

# Demander si on veut configurer GitHub maintenant
read "github_response?Voulez-vous configurer GitHub maintenant ? (o/n) "

if [[ "$github_response" =~ ^[oOyY]$ ]]; then
    echo ""
    read "username?Entrez votre username GitHub : "
    
    if [ -n "$username" ]; then
        REPO_URL="https://github.com/$username/pandoc-macos-toolkit.git"
        
        echo ""
        echo "📝 Configuration de la remote..."
        git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"
        git branch -M main
        
        echo ""
        echo "✅ Remote configurée : $REPO_URL"
        echo ""
        echo "🚀 Pour pousser maintenant :"
        echo "   git push -u origin main"
        echo ""
        echo "⚠️  Assurez-vous d'avoir créé le repo sur github.com d'abord !"
    fi
else
    echo ""
    echo "✅ GitHub skip - Tu peux le configurer plus tard"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Setup terminé !"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📂 Structure créée :"
ls -la
echo ""
echo "✅ Git initialisé"
echo "✅ Pandoc mis à jour (tableaux + code)"
echo "✅ Prêt pour GitHub"
echo ""
echo "🧪 Test immédiat :"
echo "   md2docx votre-fichier.md"
echo ""
echo "📚 Documentation :"
echo "   cat docs/GUIDE-REFERENCE-PANDOC.md"
echo ""
echo "🚀 Enjoy your Pandoc toolkit !"
echo ""
