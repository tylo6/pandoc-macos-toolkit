# 🎯 Sublime Text + VS Code - Intégration Pandoc

## 📋 Vue d'ensemble

| Éditeur | Fichier | Emplacement | Raccourci |
|---------|---------|-------------|-----------|
| **Sublime** | `Pandoc.sublime-build` | `~/Library/Application Support/Sublime Text/Packages/User/` | **Cmd+B** |
| **VS Code** | `tasks.json` | `.vscode/` (dossier projet) | **Cmd+Shift+B** |

---

## 🎨 Sublime Text (2 minutes)

### Installation

**Étape 1 : Copier le fichier**

```bash
# Copier le Build System
cp Pandoc.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/

# Vérifier
ls -l ~/Library/Application\ Support/Sublime\ Text/Packages/User/Pandoc.sublime-build
```

**C'est tout !** ✅

---

### Utilisation

**Workflow complet** :

1. **Ouvrir** un fichier `.md` dans Sublime
2. **Tools** → **Build System** → **Pandoc** (une seule fois)
3. **Cmd+B** → Conversion DOCX (par défaut)
4. ✅ Fichier créé dans le même dossier

**Choisir un format différent** :

1. **Cmd+Shift+B** → Affiche le menu
2. Choisir :
   - **Pandoc** → DOCX (défaut)
   - **Pandoc - PDF** → PDF
   - **Pandoc - HTML** → HTML
   - **Pandoc - Pages** → DOCX + ouvre dans Pages
   - **Pandoc - All formats** → DOCX + PDF + HTML

**Astuce** : Après avoir choisi un variant, **Cmd+B** utilisera le dernier choisi.

---

### Raccourcis clavier personnalisés (optionnel)

**Ajouter dans** `Preferences → Key Bindings` :

```json
[
    { "keys": ["super+shift+d"], "command": "build" },
    { "keys": ["super+shift+p"], "command": "build", "args": {"variant": "PDF"} },
    { "keys": ["super+shift+h"], "command": "build", "args": {"variant": "HTML"} }
]
```

Maintenant :
- **Cmd+Shift+D** → DOCX direct
- **Cmd+Shift+P** → PDF direct
- **Cmd+Shift+H** → HTML direct

---

## 💻 VS Code (2 minutes)

### Installation

**Méthode 1 : Projet spécifique**

```bash
# Dans le dossier de ton projet
mkdir -p .vscode
cp tasks.json .vscode/

# Vérifier
ls -l .vscode/tasks.json
```

**Méthode 2 : Global (tous les projets)**

1. **VS Code** → `Cmd+Shift+P`
2. Taper **"Tasks: Open User Tasks"**
3. Copier le contenu de `tasks.json`
4. Sauvegarder

---

### Utilisation

**Workflow complet** :

1. **Ouvrir** un fichier `.md` dans VS Code
2. **Cmd+Shift+B** → Menu des tâches
3. Choisir :
   - **Pandoc: DOCX** (défaut)
   - **Pandoc: PDF**
   - **Pandoc: HTML**
   - **Pandoc: Pages**
   - **Pandoc: All formats**
4. ✅ Terminal s'ouvre avec le résultat

**Astuce** : La première tâche (DOCX) est marquée comme défaut. Après l'avoir lancée une fois, **Cmd+Shift+B** l'exécutera directement sans menu.

---

### Raccourcis clavier personnalisés (optionnel)

**Ajouter dans** `Preferences → Keyboard Shortcuts` (JSON) :

```json
[
    {
        "key": "cmd+shift+d",
        "command": "workbench.action.tasks.runTask",
        "args": "Pandoc: DOCX",
        "when": "editorLangId == markdown"
    },
    {
        "key": "cmd+shift+p",
        "command": "workbench.action.tasks.runTask",
        "args": "Pandoc: PDF",
        "when": "editorLangId == markdown"
    },
    {
        "key": "cmd+shift+h",
        "command": "workbench.action.tasks.runTask",
        "args": "Pandoc: HTML",
        "when": "editorLangId == markdown"
    }
]
```

---

## 🎯 Workflows par éditeur

### Sublime Text

**Avantages** :
- ✅ Super rapide
- ✅ Build System simple
- ✅ Cmd+B ultra-pratique

**Utilisation typique** :
1. Rédiger en Markdown
2. Cmd+B → DOCX créé
3. Continuer à rédiger
4. Cmd+Shift+B → PDF pour version finale

---

### VS Code

**Avantages** :
- ✅ Terminal intégré (voir la sortie)
- ✅ Git intégré
- ✅ Extensions Markdown riches

**Utilisation typique** :
1. Rédiger avec preview Markdown
2. Cmd+Shift+B → Choisir format
3. Voir la sortie dans le terminal
4. Git commit avec les exports

---

## 📊 Comparaison complète

| Méthode | Vitesse | Setup | Contexte |
|---------|---------|-------|----------|
| **Terminal** | ⚡⚡⚡⚡⚡ | 0 min | Batch, scripts |
| **Raycast** | ⚡⚡⚡⚡⚡ | 2 min | Finder, n'importe où |
| **Sublime** | ⚡⚡⚡⚡⚡ | 2 min | Édition focus |
| **VS Code** | ⚡⚡⚡⚡ | 2 min | Projets complexes |

---

## 🔧 Personnalisation avancée

### Sublime : Ajouter un template Word

Éditer `Pandoc.sublime-build` :

```json
{
    "shell_cmd": "source $HOME/.zshrc && pandoc '$file' -s --toc --reference-doc=$HOME/Templates/reference.docx -o '${file_path}/${file_base_name}.docx'",
    // ...
}
```

### VS Code : Ouvrir automatiquement le fichier

Modifier une tâche :

```json
{
    "label": "Pandoc: DOCX + Open",
    "command": "source $HOME/.zshrc && md2docx '${file}' && open '${fileDirname}/${fileBasenameNoExtension}.docx'"
}
```

---

## 🐛 Dépannage

### Sublime : "Build System not found"

**Solution** :
```bash
# Vérifier l'emplacement
ls ~/Library/Application\ Support/Sublime\ Text/Packages/User/*.sublime-build

# Si absent, recopier
cp Pandoc.sublime-build ~/Library/Application\ Support/Sublime\ Text/Packages/User/
```

### VS Code : "Task not found"

**Solution** :
```bash
# Vérifier que tasks.json existe
ls .vscode/tasks.json

# Si absent, créer le dossier et copier
mkdir -p .vscode
cp tasks.json .vscode/
```

### "command not found: md2docx"

Les deux éditeurs sourcent `.zshrc` explicitement. Si ça ne marche pas :

```bash
# Vérifier que les fonctions sont dans .zshrc
grep "md2docx" ~/.zshrc

# Tester en terminal
source ~/.zshrc
md2docx --help
```

---

## ✅ Validation

### Sublime Text

- ⬜ `Pandoc.sublime-build` copié
- ⬜ Build System "Pandoc" visible dans Tools → Build System
- ⬜ Test Cmd+B sur un .md → DOCX créé
- ⬜ Test Cmd+Shift+B → Menu avec variants
- ⬜ Test variant PDF réussi

### VS Code

- ⬜ `tasks.json` copié dans `.vscode/`
- ⬜ Cmd+Shift+B ouvre le menu des tâches
- ⬜ Test "Pandoc: DOCX" réussi
- ⬜ Test "Pandoc: PDF" réussi
- ⬜ Terminal affiche la sortie correctement

---

## 🎉 Récapitulatif final

**Tu as maintenant Pandoc disponible via** :

1. ✅ **Terminal** → `md2docx`, `md2pdf`, etc.
2. ✅ **Raycast** → Cmd+Space → "pandoc"
3. ✅ **Sublime** → Cmd+B
4. ✅ **VS Code** → Cmd+Shift+B

**Choisis selon le contexte** :
- 📝 **En train d'écrire** → Sublime/VS Code
- 📂 **Fichier dans Finder** → Raycast
- 🔄 **Batch/scripts** → Terminal
- ⚡ **Le plus rapide** → Raycast avec raccourci clavier

---

## 💡 Workflow optimal suggéré

**Pour toi (vu ton setup)** :

1. **Rédaction quotidienne** → Sublime Text (Cmd+B)
2. **Quick convert depuis Finder** → Raycast (Cmd+Shift+D)
3. **Projets complexes** → VS Code (Cmd+Shift+B)
4. **Batch operations** → Terminal (`md2docx-batch`)

**Temps total de setup** : 4 minutes (2 min chacun)  
**Gain de temps** : Énorme ! 🚀

---

*C'était fastidieux mais maintenant tu as une solution complète et robuste !*
