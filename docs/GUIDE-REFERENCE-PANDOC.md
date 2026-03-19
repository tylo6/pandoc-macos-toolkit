# 📚 Guide Complet Pandoc - macOS

> **Setup complet** : Terminal, Raycast, Sublime Text, VS Code  
> **Format de sortie** : DOCX, PDF, HTML, Pages  
> **Version** : markdown_strict (sans crochets parasites)  
> **Date** : 26 janvier 2026

---

## 🎯 Vue d'ensemble

Ce guide documente l'installation complète de Pandoc avec 4 méthodes d'accès :

1. **Terminal** → Fonctions shell directes
2. **Raycast** → Scripts Commands ultra-rapides
3. **Sublime Text** → Build System intégré
4. **VS Code** → Tasks Configuration

**Formats supportés** : DOCX, PDF, HTML, Pages (ouvre automatiquement)

---

## 📋 Prérequis

### Installés et fonctionnels

- ✅ **macOS** (Catalina ou supérieur)
- ✅ **Homebrew** (`/opt/homebrew/bin/brew`)
- ✅ **Pandoc** (`brew install pandoc`)
- ✅ **MacTeX** (`brew install --cask mactex`) - Pour PDF
- ✅ **zsh** (shell par défaut macOS)

### Vérification rapide

```bash
# Vérifier Pandoc
pandoc --version

# Vérifier LaTeX
which xelatex

# Vérifier zsh
echo $SHELL  # Devrait afficher /bin/zsh
```

---

## 🚀 Installation rapide (5 minutes)

### 1. Fonctions shell de base

```bash
# Installer les fonctions dans .zshrc
./install-pandoc-shell-fixed.sh

# Recharger
source ~/.zshrc

# Tester
md2docx --help
```

**Fonctions disponibles** :
- `md2docx` - Markdown → DOCX
- `md2pdf` - Markdown → PDF
- `md2html` - Markdown → HTML
- `md2pages` - Markdown → DOCX + ouvre Pages
- `md2all` - Génère tous les formats
- `md2docx-batch` - Conversion en batch

---

### 2. Raycast Scripts (recommandé)

```bash
# Installer les 4 scripts Raycast
./install-raycast-scripts.sh

# Configurer dans Raycast
# Raycast → Extensions → Script Commands → ⚙️
# Add Script Directory → ~/Documents/Raycast-Scripts
```

**Scripts installés** :
- `pandoc-docx.sh` - 📄 Markdown → DOCX
- `pandoc-pdf.sh` - 📕 Markdown → PDF
- `pandoc-html.sh` - 🌐 Markdown → HTML
- `pandoc-pages.sh` - 📃 Markdown → Pages

**Utilisation** :
1. Sélectionner un `.md` dans Finder
2. `Cmd+Space` (Raycast)
3. Taper "pandoc docx"
4. Enter → Converti !

---

### 3. Sublime Text

```bash
# Copier le Build System
cp Pandoc-Absolute.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/

# Redémarrer Sublime
# Tools → Build System → Pandoc-Absolute
```

**Utilisation** :
- **Cmd+B** → DOCX (par défaut)
- **Cmd+Shift+B** → Menu (PDF, HTML, Pages, All)

---

### 4. VS Code

```bash
# Dans ton projet
mkdir -p .vscode
cp vscode-tasks-absolute.json .vscode/tasks.json

# Recharger VS Code
# Cmd+Shift+P → "Reload Window"
```

**Utilisation** :
- **Cmd+Shift+B** → Menu des tâches
- Choisir : Pandoc: DOCX / PDF / HTML / Pages

**OU via Command Palette** :
- **Cmd+Shift+P** → "Tasks: Run Task" → Choisir format

---

## 📝 Commandes Terminal

### Conversions de base

```bash
# DOCX
md2docx rapport.md

# PDF
md2pdf rapport.md

# HTML
md2html rapport.md

# Pages (DOCX + ouvre Pages)
md2pages rapport.md

# Tous les formats
md2all rapport.md
```

### Conversions multiples

```bash
# Plusieurs fichiers
md2docx note1.md note2.md note3.md

# Tous les .md du dossier
md2docx *.md

# Batch avec compteur
md2docx-batch
```

### Commande Pandoc directe

```bash
# DOCX avec markdown_strict
pandoc fichier.md -s --toc -f markdown_strict -o fichier.docx

# PDF avec LaTeX
pandoc fichier.md -s --toc --pdf-engine=xelatex \
  -f markdown_strict \
  -V geometry:margin=2.5cm \
  -V fontsize=12pt \
  -o fichier.pdf

# HTML standalone
pandoc fichier.md -s --toc --self-contained \
  -f markdown_strict \
  --metadata title="Mon document" \
  -o fichier.html
```

---

## ⚙️ Configuration avancée

### Template Word personnalisé

```bash
# Créer un dossier Templates
mkdir -p ~/Templates

# Générer un template de référence
pandoc -o ~/Templates/reference.docx --print-default-data-file reference.docx

# Modifier dans Word : styles, polices, marges, etc.

# Utiliser le template
pandoc fichier.md -s --toc \
  --reference-doc=~/Templates/reference.docx \
  -f markdown_strict \
  -o fichier.docx
```

### Modifier les fonctions shell

```bash
# Éditer .zshrc
nano ~/.zshrc

# Chercher la fonction (ex: md2docx)
# Modifier les options Pandoc selon tes besoins

# Exemples de personnalisation :
# - Ajouter --reference-doc pour template
# - Changer les marges PDF (-V geometry:margin=3cm)
# - Modifier la taille de police (-V fontsize=11pt)
# - Désactiver la table des matières (enlever --toc)

# Sauvegarder : Ctrl+O → Enter → Ctrl+X
# Recharger
source ~/.zshrc
```

---

## 🎨 Format Markdown supporté

### Syntaxe de base

```markdown
# Titre niveau 1
## Titre niveau 2
### Titre niveau 3

**Gras**
*Italique*
~~Barré~~

- Liste à puces
- Item 2

1. Liste numérotée
2. Item 2

[Lien](https://example.com)

![Image](chemin/image.png)
```

### Code

```markdown
`Code inline`

​```python
def fonction():
    return "Code block"
​```
```

### Tableaux

```markdown
| Colonne 1 | Colonne 2 |
|-----------|-----------|
| Valeur 1  | Valeur 2  |
```

### Notes de bas de page

```markdown
Texte avec note[^1]

[^1]: Contenu de la note
```

---

## 🐛 Dépannage

### "command not found: md2docx"

**Solution** :
```bash
# Recharger .zshrc
source ~/.zshrc

# Vérifier que les fonctions sont présentes
grep "md2docx" ~/.zshrc

# Réinstaller si nécessaire
./install-pandoc-shell-fixed.sh
```

---

### PDF ne se génère pas

**Solution** :
```bash
# Vérifier que LaTeX est installé
which xelatex

# Si absent, installer MacTeX
brew install --cask mactex

# Ajouter au PATH
echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

### Crochets parasites "]" dans DOCX

**Solution** : Utiliser `markdown_strict`

```bash
# Mettre à jour TOUTES les configurations
./update-all-markdown-strict.sh

# Ou manuellement
pandoc fichier.md -s --toc -f markdown_strict -o fichier.docx
```

---

### Sublime Text : "Build System not found"

**Solution** :
```bash
# Vérifier l'emplacement
ls ~/Library/Application\ Support/Sublime\ Text/Packages/User/*.sublime-build

# Recopier si absent
cp Pandoc-Absolute.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/

# Redémarrer Sublime (Cmd+Q)
```

---

### VS Code : Tasks non trouvées

**Solution** :
```bash
# Vérifier le fichier
ls .vscode/tasks.json

# Recopier si absent
mkdir -p .vscode
cp vscode-tasks-absolute.json .vscode/tasks.json

# Recharger VS Code
# Cmd+Shift+P → "Reload Window"
```

---

### Raycast : Scripts n'apparaissent pas

**Solution** :
```bash
# Vérifier les permissions
chmod +x ~/Documents/Raycast-Scripts/*.sh

# Dans Raycast
# Extensions → Script Commands → ⚙️ → Reload All Scripts

# Vérifier le répertoire
ls -l ~/Documents/Raycast-Scripts/
```

---

## ⚡ Workflows recommandés

### Workflow 1 : Rédaction quotidienne

**Contexte** : Écriture de documents en Markdown

1. **Rédiger** dans Sublime Text / VS Code
2. **Cmd+B** (Sublime) ou **Cmd+Shift+B** (VS Code)
3. DOCX généré instantanément
4. Continuer à rédiger

**Avantage** : Aucun changement de contexte

---

### Workflow 2 : Quick convert depuis Finder

**Contexte** : Fichier déjà écrit, besoin de convertir rapidement

1. **Finder** → Sélectionner le `.md`
2. **Cmd+Space** (Raycast)
3. Taper "pandoc docx"
4. Enter

**Avantage** : Ultra-rapide, fonctionne de partout

---

### Workflow 3 : Batch conversion

**Contexte** : Convertir plusieurs fichiers d'un coup

```bash
# Terminal
cd ~/Documents/Notes
md2docx *.md

# Ou avec compteur
md2docx-batch
```

**Avantage** : Automatise les conversions multiples

---

### Workflow 4 : Génération rapport complet

**Contexte** : Document final avec tous les formats

```bash
# Générer DOCX + PDF + HTML
md2all rapport-final.md

# Résultat :
# - rapport-final.docx
# - rapport-final.pdf
# - rapport-final.html
```

**Avantage** : Un fichier source, tous les formats de sortie

---

## 📊 Comparaison des méthodes

| Méthode | Vitesse | Setup | Contexte idéal |
|---------|---------|-------|----------------|
| **Terminal** | ⚡⚡⚡⚡⚡ | 0 min | Batch, scripts, automation |
| **Raycast** | ⚡⚡⚡⚡⚡ | 2 min | Finder, n'importe où (⭐ recommandé) |
| **Sublime** | ⚡⚡⚡⚡⚡ | 1 min | Édition rapide, focus |
| **VS Code** | ⚡⚡⚡⚡ | 1 min | Projets complexes, Git |

**Recommandation personnelle** :
- 📝 **En train d'écrire** → Sublime Text (Cmd+B)
- 📂 **Fichier dans Finder** → Raycast (Cmd+Space)
- 🔄 **Batch/automation** → Terminal (`md2docx-batch`)
- 💼 **Projets complexes** → VS Code (Cmd+Shift+B)

---

## 🔧 Scripts inclus

### Scripts shell de base

| Script | Description |
|--------|-------------|
| `install-pandoc-shell-fixed.sh` | Installation fonctions .zshrc |
| `update-all-markdown-strict.sh` | Mise à jour markdown_strict partout |
| `debug-services.sh` | Debug si problèmes |

### Scripts Raycast

| Script | Format | Icône |
|--------|--------|-------|
| `pandoc-docx.sh` | DOCX | 📄 |
| `pandoc-pdf.sh` | PDF | 📕 |
| `pandoc-html.sh` | HTML | 🌐 |
| `pandoc-pages.sh` | Pages | 📃 |

### Configurations éditeurs

| Fichier | Éditeur |
|---------|---------|
| `Pandoc-Absolute.sublime-build` | Sublime Text |
| `vscode-tasks-absolute.json` | VS Code |

---

## 📚 Ressources

### Documentation Pandoc

- **Site officiel** : https://pandoc.org/
- **Manuel** : https://pandoc.org/MANUAL.html
- **Demos** : https://pandoc.org/demos.html

### Extensions Markdown

- **markdown_strict** : Markdown pur (utilisé ici)
- **gfm** : GitHub Flavored Markdown
- **markdown_mmd** : MultiMarkdown
- **commonmark** : CommonMark standard

### Templates Word

- **Générer un template** : `pandoc -o reference.docx --print-default-data-file reference.docx`
- **Documentation** : https://pandoc.org/MANUAL.html#option--reference-doc

---

## 🎯 Checklist de validation

### Installation de base

- [ ] Pandoc installé (`pandoc --version`)
- [ ] MacTeX installé (`which xelatex`)
- [ ] Fonctions shell dans .zshrc
- [ ] Test `md2docx` fonctionne
- [ ] Test `md2pdf` fonctionne

### Raycast

- [ ] Scripts dans `~/Documents/Raycast-Scripts/`
- [ ] Répertoire ajouté dans Raycast
- [ ] Test "Pandoc → DOCX" depuis Finder
- [ ] Pas de crochets parasites dans DOCX

### Sublime Text

- [ ] Build System copié
- [ ] "Pandoc-Absolute" visible dans Tools → Build System
- [ ] Test Cmd+B → DOCX créé
- [ ] Test Cmd+Shift+B → Menu avec variants

### VS Code

- [ ] `tasks.json` dans `.vscode/`
- [ ] Test Cmd+Shift+B → Menu tâches
- [ ] Test "Pandoc: DOCX" fonctionne
- [ ] Terminal affiche le résultat

---

## 💡 Tips & Astuces

### Tip 1 : Raccourcis Raycast personnalisés

Dans Raycast, assigner des hotkeys :
- **Cmd+Shift+D** → Pandoc → DOCX
- **Cmd+Shift+P** → Pandoc → PDF
- **Cmd+Shift+H** → Pandoc → HTML

**Résultat** : Sélectionner `.md` → Raccourci → Converti !

---

### Tip 2 : Alias rapides

Ajouter dans `.zshrc` :
```bash
alias pd='md2docx'
alias pp='md2pdf'
alias ph='md2html'
```

**Utilisation** : `pd rapport.md` au lieu de `md2docx rapport.md`

---

### Tip 3 : Automatisation Git

Créer un Git hook pour auto-générer les exports :

```bash
# .git/hooks/pre-commit
#!/bin/bash
md2docx-batch
git add *.docx
```

**Résultat** : Chaque commit génère automatiquement les DOCX

---

### Tip 4 : Watch mode

Surveiller un fichier et reconvertir automatiquement :

```bash
# Installer fswatch
brew install fswatch

# Surveiller et reconvertir
fswatch -o rapport.md | xargs -n1 -I{} md2docx rapport.md
```

**Résultat** : DOCX mis à jour à chaque sauvegarde

---

## 📝 Notes importantes

### Format markdown_strict

**Pourquoi `markdown_strict` ?**
- ✅ Pas de crochets parasites dans DOCX
- ✅ Compatibilité maximale
- ✅ Résultat prévisible

**Limitations** :
- ⚠️ Pas de task lists `- [ ]`
- ⚠️ Pas d'attributs étendus `{#id .class}`
- ⚠️ Syntaxe Markdown pure uniquement

**Alternative** : Si tu as besoin de fonctionnalités avancées, utilise `gfm` :
```bash
pandoc fichier.md -s --toc -f gfm -o fichier.docx
```

---

### Avertissements shell

**Messages normaux** (à ignorer) :
```
autoload: command not found
compinit: command not found
```

Ces warnings apparaissent dans Sublime/VS Code car ils utilisent bash et non zsh. **Ils n'empêchent pas la conversion** - tant que le fichier est créé, tout va bien !

---

### Performances

**Vitesse moyenne** :
- DOCX : < 1 seconde
- PDF : 1-3 secondes (LaTeX)
- HTML : < 1 seconde

**Taille des fichiers** :
- DOCX : ~50 Ko pour 10 pages
- PDF : ~100 Ko pour 10 pages
- HTML : ~20 Ko pour 10 pages

---

## 🎉 Conclusion

**Tu as maintenant un setup complet** pour convertir tes fichiers Markdown :
- ⚡ Ultra-rapide (<1 seconde)
- 🎯 4 méthodes d'accès (Terminal, Raycast, Sublime, VS Code)
- 📄 4 formats de sortie (DOCX, PDF, HTML, Pages)
- 🔧 100% personnalisable
- ✅ Sans crochets parasites

**Workflow recommandé** :
1. **Rédiger** en Markdown (Sublime/VS Code/Obsidian)
2. **Convertir** via Raycast (le plus rapide)
3. **Finaliser** dans Word/Pages si nécessaire

**Enjoy your super-powered Markdown workflow!** 🚀

---

## 📞 Support & Maintenance

### Mise à jour Pandoc

```bash
# Via Homebrew
brew upgrade pandoc

# Vérifier la version
pandoc --version
```

### Mise à jour MacTeX

```bash
# Via Homebrew
brew upgrade --cask mactex
```

### Réinstallation complète

```bash
# 1. Sauvegarder .zshrc
cp ~/.zshrc ~/.zshrc.backup

# 2. Réinstaller les fonctions
./install-pandoc-shell-fixed.sh

# 3. Mettre à jour vers markdown_strict
./update-all-markdown-strict.sh

# 4. Réinstaller Raycast
./install-raycast-scripts.sh
```

---

**Version** : 1.0  
**Date** : 26 janvier 2026  
**Status** : ✅ Opérationnel à 100%
