# 🚀 Raycast Scripts - Pandoc

## ✨ Scripts créés

| Script | Format | Icône | Description |
|--------|--------|-------|-------------|
| `pandoc-docx.sh` | DOCX | 📄 | Word/LibreOffice |
| `pandoc-pdf.sh` | PDF | 📕 | Document PDF |
| `pandoc-html.sh` | HTML | 🌐 | Page web |
| `pandoc-pages.sh` | Pages | 📃 | Ouvre dans Pages |

---

## 🎯 Installation (2 minutes)

### Étape 1 : Installer les scripts

```bash
# Rendre exécutable
chmod +x install-raycast-scripts.sh

# Installer
./install-raycast-scripts.sh
```

**Résultat** : Scripts copiés dans `~/Documents/Raycast-Scripts/`

---

### Étape 2 : Configurer Raycast

1. **Ouvrir Raycast** (Cmd+Space ou ton raccourci)
2. Taper **"extensions"** → Enter
3. **Script Commands** → Cliquer sur **⚙️** (en haut à droite)
4. **Add Script Directory**
5. Naviguer et sélectionner : `~/Documents/Raycast-Scripts`
6. ✅ **Done!**

Les scripts apparaissent automatiquement dans Raycast !

---

## ⚡ Utilisation

### Méthode 1 : Via Raycast Search (recommandé)

**Workflow complet** :

1. **Finder** → Sélectionner un fichier `.md`
2. **Raycast** (Cmd+Space)
3. Taper **"pandoc docx"** (ou pdf, html, pages)
4. **Enter**
5. ✅ **Fichier converti !**

**Astuce** : Raycast apprend tes commandes favorites. Après 2-3 utilisations, tu peux juste taper "pd" et il propose "pandoc docx".

---

### Méthode 2 : Raccourcis clavier (ultra-rapide)

**Configuration** :

1. **Raycast** → Extensions → Script Commands
2. Trouver **"Pandoc → DOCX"**
3. **⌘** (à droite) → **Record Hotkey**
4. Presser **Cmd+Shift+D**
5. ✅ Raccourci assigné !

**Répéter pour** :
- Pandoc → PDF : **Cmd+Shift+P**
- Pandoc → HTML : **Cmd+Shift+H**
- Pandoc → Pages : **Cmd+Shift+G**

**Workflow ultra-rapide** :
1. Sélectionner `.md` dans Finder
2. **Cmd+Shift+D**
3. ✅ Converti instantanément !

---

### Méthode 3 : Avec argument (fichier spécifique)

**Si le fichier n'est pas sélectionné** :

1. **Raycast**
2. Taper **"pandoc docx"**
3. **Tab** (pour remplir l'argument)
4. Glisser-déposer le fichier `.md`
5. **Enter**

**Ou taper le chemin** :
```
pandoc docx ~/Documents/rapport.md
```

---

## 🎨 Personnalisation

### Changer l'icône

Éditer le script (ex: `~/Documents/Raycast-Scripts/pandoc-docx.sh`) :

```bash
# @raycast.icon 📄
```

**Autres icônes** : 📝 📋 📑 📘 📗 📙 📓 ✍️ 🖊️

---

### Changer les options Pandoc

Exemple pour ajouter une marge personnalisée au PDF :

```bash
# Dans pandoc-pdf.sh, modifier :
pandoc "$FILE" -s --toc \
    --pdf-engine=xelatex \
    -V geometry:margin=3cm \     # ← Changer ici
    -V fontsize=11pt \            # ← Et ici
    -o "$OUTPUT"
```

---

### Ajouter un template Word

```bash
# Dans pandoc-docx.sh, ajouter :
TEMPLATE="$HOME/Templates/reference.docx"

pandoc "$FILE" -s --toc \
    --reference-doc="$TEMPLATE" \
    -o "$OUTPUT"
```

---

## 🔥 Workflows avancés

### Workflow 1 : Conversion rapide depuis Obsidian

1. **Obsidian** → Vue du fichier
2. **Cmd+Tab** → Finder (le fichier est sélectionné)
3. **Cmd+Shift+D** (Raycast)
4. ✅ DOCX créé dans le même dossier

### Workflow 2 : Batch conversion

Sélectionner plusieurs `.md` ne fonctionne pas directement, mais :

**Terminal** :
```bash
cd ~/Documents/Notes
md2docx-batch
```

**Ou créer un script Raycast batch** :
```bash
# pandoc-batch-docx.sh
for file in ~/Documents/Notes/*.md; do
    md2docx "$file"
done
```

### Workflow 3 : Conversion + partage

**Dans le script, ajouter** :
```bash
# Après conversion
osascript -e "tell application \"Finder\" to reveal POSIX file \"$OUTPUT\""
```

Le fichier converti s'affiche dans Finder, prêt à partager.

---

## 📊 Comparaison des méthodes

| Méthode | Vitesse | Praticité | Contexte |
|---------|---------|-----------|----------|
| **Raycast** | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐⭐ | Partout, toujours |
| Terminal | ⚡⚡⚡⚡⚡ | ⭐⭐⭐ | Si déjà en terminal |
| Services macOS | ⚡⚡⚡ | ⭐⭐ | Problèmes permissions |
| Raccourcis macOS | ⚡⚡⚡⚡ | ⭐⭐⭐⭐ | Si pas Raycast |

**Gagnant** : **Raycast** (si installé)

---

## 🐛 Dépannage

### Scripts n'apparaissent pas dans Raycast

**Solution** :
1. Raycast → Extensions → Script Commands
2. ⚙️ → Reload All Scripts
3. Vérifier que le répertoire est bien ajouté

### "Permission denied"

```bash
# Rendre exécutables
chmod +x ~/Documents/Raycast-Scripts/*.sh
```

### "command not found: md2docx"

Les scripts chargent `.zshrc` automatiquement. Si ça ne marche pas :

```bash
# Vérifier que les fonctions sont dans .zshrc
grep "md2docx" ~/.zshrc
```

### Notifications ne s'affichent pas

Les scripts Raycast n'utilisent pas de notifications par défaut (mode `silent`).

Pour activer :
```bash
# Changer dans le script :
# @raycast.mode silent
# ↓
# @raycast.mode fullOutput
```

---

## ✅ Validation

**Coche quand c'est fait** :

- ⬜ Scripts installés dans `~/Documents/Raycast-Scripts/`
- ⬜ Répertoire ajouté dans Raycast
- ⬜ Scripts visibles dans Raycast
- ⬜ Test "Pandoc → DOCX" réussi
- ⬜ Test "Pandoc → PDF" réussi
- ⬜ Test "Pandoc → Pages" réussi
- ⬜ Raccourcis clavier assignés (optionnel)

**Toutes cochées ?** 🎉 → Raycast opérationnel !

---

## 🎯 Prochaine étape

Une fois Raycast configuré, on passe à **C) Sublime Text + VS Code** pour l'intégration dans les éditeurs !

---

## 💡 Astuces pro

### Astuce 1 : Alias Raycast courts

Raycast apprend tes habitudes. Après quelques usages :
- "pd" → Pandoc → DOCX
- "pp" → Pandoc → PDF
- "pg" → Pandoc → Pages

### Astuce 2 : Glisser-déposer

Tu peux glisser un `.md` directement dans Raycast :
1. Raycast (Cmd+Space)
2. Glisser `.md` dans la fenêtre
3. Choisir "Pandoc → DOCX"

### Astuce 3 : Quicklinks

Créer un Quicklink Raycast :
- Nom : "Convert MD"
- Lien : `raycast://script-commands/pandoc-docx`

Partage avec ton équipe !

---

**Temps total d'installation** : 2 minutes  
**Temps de conversion** : <1 seconde  

**Raycast + Pandoc = Combo gagnant** 🚀
