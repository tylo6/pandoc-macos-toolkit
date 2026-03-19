# 📦 Pandoc Setup - Package complet

**Version** : 1.0  
**Date** : 26 janvier 2026  
**Formats supportés** : DOCX, PDF, HTML, Pages  
**Compatible** : macOS (Catalina+), Terminal, Raycast, Sublime Text, VS Code

---

## 📋 Contenu du package

### 📚 Documentation

- **`GUIDE-REFERENCE-PANDOC.md`** - Guide complet (à importer dans Obsidian)

### 🔧 Scripts shell de base

- **`install-pandoc-shell-fixed.sh`** - Installation des fonctions dans .zshrc
- **`update-all-markdown-strict.sh`** - Mise à jour markdown_strict (anti-crochets)
- **`debug-services.sh`** - Script de diagnostic

### ⚡ Scripts Raycast

- **`install-raycast-scripts.sh`** - Installation automatique
- **`pandoc-docx.sh`** - Conversion DOCX
- **`pandoc-pdf.sh`** - Conversion PDF  
- **`pandoc-html.sh`** - Conversion HTML
- **`pandoc-pages.sh`** - Conversion + ouvre Pages

### 🎨 Configurations éditeurs

- **`Pandoc-Absolute.sublime-build`** - Build System pour Sublime Text
- **`vscode-tasks-absolute.json`** - Tasks pour VS Code

---

## 🚀 Installation rapide

### 1. Fonctions shell (Terminal)

```bash
./install-pandoc-shell-fixed.sh
source ~/.zshrc
```

### 2. Raycast Scripts

```bash
./install-raycast-scripts.sh
# Puis dans Raycast: Extensions → Script Commands → Add Directory
```

### 3. Sublime Text

```bash
cp Pandoc-Absolute.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/
```

### 4. VS Code

```bash
mkdir -p .vscode
cp vscode-tasks-absolute.json .vscode/tasks.json
```

---

## 🎯 Utilisation

### Terminal
```bash
md2docx fichier.md     # DOCX
md2pdf fichier.md      # PDF
md2html fichier.md     # HTML
md2pages fichier.md    # Pages
```

### Raycast
1. Sélectionner `.md` dans Finder
2. Cmd+Space → "pandoc docx"
3. Enter

### Sublime Text
- **Cmd+B** → DOCX
- **Cmd+Shift+B** → Menu (PDF, HTML, Pages)

### VS Code
- **Cmd+Shift+B** → Menu
- **Cmd+Shift+P** → "Tasks: Run Task"

---

## 📖 Documentation complète

Consulter **`GUIDE-REFERENCE-PANDOC.md`** pour :
- Installation détaillée
- Configuration avancée
- Dépannage
- Workflows recommandés
- Tips & astuces

---

## ✅ Ce qui fonctionne

- ✅ Conversions ultra-rapides (<1 sec)
- ✅ 4 méthodes d'accès
- ✅ 4 formats de sortie
- ✅ Format `markdown_strict` (sans crochets parasites)
- ✅ Templates Word personnalisables
- ✅ Batch conversions

---

## 🎉 Profite de ton nouveau workflow Pandoc !

**Questions ?** Consulte le guide complet ou la documentation Pandoc officielle : https://pandoc.org/
