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
