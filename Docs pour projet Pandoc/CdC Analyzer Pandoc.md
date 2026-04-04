# Cahier des Charges — Intégration Pandoc Multicanal

**La structure est toujours la même, quel que soit le projet :**

1. Un **système prompt** qui porte le contexte permanent (le projet, le rôle, les contraintes)
2. Des **prompts atomiques** par section ou étape (générables dans l'ordre voulu)
3. Des **prompts transversaux** réutilisables (formaliser, auditer, synthétiser, reformuler)
4. Un **historique conversationnel** maintenu entre les étapes
---

# Section 1 : Contexte & Objectifs

## 1.1 Contexte du projet

### 1.1.1 Environnement technique

Le projet s'inscrit dans un environnement de travail professionnel basé sur macOS (architecture Apple Silicon M3) et structuré autour de l'écosystème Markdown pour la rédaction documentaire.

**Configuration matérielle et système :**
- Plateforme : macOS sur processeur Apple Silicon M3
- Gestionnaire de paquets : Homebrew (installation native ARM64)
- Moteur de conversion : Pandoc installé via Homebrew (`/opt/homebrew/bin/pandoc`)

**Écosystème applicatif :**
- Éditeur principal de notes : Obsidian
- Éditeurs de code/texte : Sublime Text, Visual Studio Code
- Lanceur d'applications et automatisation : Raycast
- Terminal : Zsh (shell par défaut macOS)

### 1.1.2 Problématique métier

L'utilisateur (Marcou) produit des contenus professionnels au format Markdown et doit fréquemment convertir ces documents vers différents formats de distribution selon le contexte de diffusion :

- **DOCX** : collaboration avec environnements Microsoft Office, relecture par tiers, intégration dans workflows bureautiques traditionnels
- **PDF** : archivage, diffusion officielle, préservation de la mise en forme
- **HTML** : publication web, documentation en ligne, intégration dans systèmes de gestion de contenu
- **Pages** : compatibilité avec l'écosystème Apple, édition collaborative macOS/iOS

**Contraintes identifiées :**
- Contextes de travail multiples nécessitant une accessibilité universelle de la fonction de conversion
- Formats d'export variés avec des spécifications techniques différentes
- Nécessité de préserver l'intégrité du formatage lors de la conversion
- Workflow interrompu par des changements d'interface ou des manipulations manuelles répétitives

### 1.1.3 Solution retenue

La stratégie d'intégration repose sur une architecture multicanale où Pandoc est accessible depuis quatre interfaces distinctes, permettant une conversion sans rupture de contexte de travail :

| Interface | Déclencheur | Cas d'usage typique |
|-----------|-------------|---------------------|
| Terminal Zsh | Fonctions dans `~/.zshrc` | Conversion par lots, automatisation, scripting |
| Raycast | Scripts dédiés | Conversion rapide depuis n'importe quelle application |
| Sublime Text | Build System (`Cmd+B`) | Conversion immédiate pendant l'édition |
| VS Code | Tasks (`Cmd+Shift+B`) | Intégration dans workflow de développement |

**Choix technique du format source :**
Le variant `markdown_strict` de Pandoc a été retenu pour éviter les artefacts de formatage liés aux extensions non standard de Markdown, garantissant une conversion prévisible et reproductible.

## 1.2 Objectifs du projet

### 1.2.1 Objectif principal

**Mettre en place un système de conversion documentaire Pandoc accessible de manière homogène depuis tout contexte de travail de l'utilisateur, permettant la génération de documents DOCX, PDF, HTML et Pages à partir de sources Markdown.**

### 1.2.2 Objectifs opérationnels

**OP-01 : Accessibilité universelle**
- Permettre la conversion depuis Terminal, Raycast, Sublime Text et VS Code sans changement d'application
- Critère de succès : délai maximum de 3 secondes entre le déclenchement de la conversion et l'obtention du fichier de sortie
- Indicateur mesurable : nombre de clics/commandes nécessaires ≤ 2 (raccourci clavier ou commande courte)

**OP-02 : Conformité des formats de sortie**
- DOCX : compatible Microsoft

---

# Section 2 : Périmètre fonctionnel

## 2.1 Fonctionnalités couvertes

### 2.1.1 Conversion via Terminal (macOS et Windows)

**macOS - Fonctions Zsh**

Intégration de fonctions dédiées dans le fichier de configuration `~/.zshrc` permettant la conversion en ligne de commande.

| Fonction | Syntaxe | Format de sortie | Description |
|----------|---------|------------------|-------------|
| `md2docx` | `md2docx fichier.md` | DOCX | Conversion Markdown → Word avec template personnalisé |
| `md2pdf` | `md2pdf fichier.md` | PDF | Conversion Markdown → PDF via moteur LaTeX |
| `md2html` | `md2html fichier.md` | HTML | Conversion Markdown → HTML autonome |
| `md2pages` | `md2pages fichier.md` | Pages | Conversion Markdown → Pages (macOS uniquement) |

**Spécifications techniques communes :**
- Format source : `markdown_strict` (sans extensions non standard)
- Template DOCX : référence obligatoire (`--reference-doc=template.docx`)
- Police : Palatino (définie dans le template)
- Marges : droite à 2 cm (spécifiée dans le template)
- Logs : enregistrement systématique à la racine du répertoire Pandoc (`/logs/conversion_YYYYMMDD_HHMMSS.log`)
- Gestion d'erreurs : affichage console + écriture dans le fichier de log

**Windows 11 - Scripts PowerShell**

Intégration de scripts PowerShell (`.ps1`) ou de fonctions dans le profil PowerShell (`$PROFILE`).

| Script/Fonction | Syntaxe | Format de sortie | Description |
|-----------------|---------|------------------|-------------|
| `Convert-MdToDocx` | `Convert-MdToDocx -Path fichier.md` | DOCX | Conversion Markdown → Word avec template |
| `Convert-MdToPdf` | `Convert-MdToPdf -Path fichier.md` | PDF | Conversion Markdown → PDF |
| `Convert-MdToHtml` | `Convert-MdToHtml -Path fichier.md` | HTML | Conversion Markdown → HTML |

**Spécifications techniques PowerShell :**
- Support des paramètres nommés PowerShell (`-Path`, `-OutputDir`, `-Template`)
- Gestion du pipeline PowerShell (`Get-ChildItem *.md | Convert-MdToDocx`)
- Logs : fichiers texte horodatés dans répertoire centralisé
- Intégration avec PowerShell 7+ (compatibilité Core)

**Fonctionnalités communes Terminal (macOS/Windows) :**
- Conversion par lots : traitement de plusieurs fichiers en une seule commande
- Paramétrage avancé : surcharge des options Pandoc via arguments optionnels
- Sortie console : progression, statut de conversion, chemin du fichier généré
- Code de retour : 0 (succès), 1 (erreur) pour intégration dans scripts automatisés

### 2.1.2 Conversion via Raycast (macOS)

**Scripts Raycast dédiés**

Création de scripts Raycast accessibles via le lanceur d'applications (raccourci configurable, par défaut `Cmd+Space` ou `Option+Space`).

| Script | Nom d'affichage | Déclenchement | Comportement |
|--------|-----------------|---------------|--------------|
| `pandoc-to-docx.sh` | "Convert MD → DOCX" | Recherche Raycast | Conversion du fichier Markdown actif/sélectionné |
| `pandoc-to-pdf.sh` | "Convert MD → PDF" | Recherche Raycast | Conversion vers PDF |
| `pandoc-to-html.sh` | "Convert MD →

---

# Section 3 : Architecture technique

## 3.1 Stack technologique

### 3.1.1 Environnement macOS

**Système d'exploitation**
- Plateforme : macOS (architecture Apple Silicon M3, ARM64)
- Version minimale requise : macOS 12.0 (Monterey) ou supérieure
- Shell par défaut : Zsh (version 5.8 ou supérieure)

**Gestionnaire de paquets**
- Homebrew (version 4.x ou supérieure)
- Architecture native ARM64 pour Apple Silicon
- Répertoire d'installation : `/opt/homebrew`
- Chemin des binaires : `/opt/homebrew/bin`

**Moteur de conversion**
- Pandoc installé via Homebrew
- Chemin absolu : `/opt/homebrew/bin/pandoc`
- Version requise : 3.x ou supérieure
- Dépendances : LaTeX (pour génération PDF), wkhtmltopdf (optionnel pour HTML→PDF)

**Format Markdown**
- Variant : `markdown_strict` (spécification CommonMark sans extensions propriétaires)
- Rationale : élimination des artefacts de formatage liés aux extensions non standard
- Compatibilité : garantie de conversion reproductible entre différentes versions de Pandoc

### 3.1.2 Environnement Windows 11

**Système d'exploitation**
- Plateforme : Windows 11 (architecture x64 ou ARM64)
- Version minimale requise : Windows 11 22H2 ou supérieure

**Shell et langage de script**
- PowerShell 7.x ou supérieur (PowerShell Core)
- Profil utilisateur : `$PROFILE` (généralement `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`)
- Encodage : UTF-8 avec BOM pour compatibilité

**Moteur de conversion**
- Pandoc installé via :
  - Gestionnaire de paquets : Chocolatey, Scoop ou Winget
  - Installeur MSI officiel (pandoc.org)
- Chemin d'installation recommandé : `C:\Program Files\Pandoc\pandoc.exe`
- Version requise : 3.x ou supérieure (synchronisation de version avec macOS)
- Variable d'environnement PATH : vérification de l'accessibilité globale

**Utilitaires système**
- PowerToys (Microsoft) : Run launcher, Keyboard Manager
- Format Markdown : `markdown_strict` (identique à macOS pour cohérence)

### 3.1.3 Composants transverses

**Template DOCX de référence**
- Localisation : répertoire racine Pandoc ou dossier dédié `/templates`
- Nom : `reference.docx` ou `template-palatino.docx`
- Contenu :
  - Police par défaut : Palatino (corps de texte, titres)
  - Marges : droite à 2 cm, autres marges selon standard Word
  - Styles : Normal, Heading 1-6, Code, Block Quote, List
- Maintenance : version unique partagée entre macOS et Windows (synchronisation via cloud)

**Système de logs**
- Répertoire : `<PANDOC_ROOT>/logs` ou `~/.pandoc/logs`
- Format de fichier : `conversion_YYYYMMDD_HHMMSS.log`
- Structure de log :
  ```
  [TIMESTAMP] [NIVEAU] [SOURCE] Message
  [2025-01-15 14:32:10] [INFO] [md2docx] Début conversion : document.md
  [2025-01-15 14:32:12] [SUCCESS] [md2docx] Fichier généré : document.docx
  [2025-01-15 14:32:12] [INFO] [md2docx] Durée : 2.3s
  ```
- Niveaux : INFO,

---

# Section 4 : Interfaces & UX

## 4.1 Vue d'ensemble des interfaces

Le système de conversion Pandoc est accessible via quatre interfaces distinctes, chacune optimisée pour un contexte d'utilisation spécifique. L'objectif est de permettre à l'utilisateur de déclencher une conversion sans rupture de flux de travail, quel que soit l'environnement actif.

| Interface | Plateforme | Déclencheur | Temps de réponse cible | Contexte d'usage |
|-----------|------------|-------------|------------------------|------------------|
| Terminal | macOS, Windows | Commande textuelle | < 3s | Automatisation, traitement par lots |
| Raycast | macOS | Recherche + Enter | < 2s | Conversion rapide hors éditeur |
| Sublime Text | macOS, Windows | `Cmd+B` / `Ctrl+B` | < 2s | Édition active dans Sublime |
| VS Code | macOS, Windows | `Cmd+Shift+B` / `Ctrl+Shift+B` | < 2s | Développement, édition Markdown |

**Principe d'homogénéité UX :**
- Feedback immédiat : notification de début de conversion (< 500ms)
- Affichage de progression : indicateur visuel ou textuel
- Notification de succès : chemin du fichier généré, durée de conversion
- Gestion d'erreurs : message explicite, suggestion de correction, référence au log

## 4.2 Interface Terminal

### 4.2.1 Commandes macOS (Zsh)

**Localisation des fonctions**
- Fichier de configuration : `~/.zshrc`
- Rechargement : automatique à l'ouverture d'un nouveau terminal, ou `source ~/.zshrc`

**Syntaxe des commandes**

```bash
# Conversion vers DOCX
md2docx fichier.md [options]

# Conversion vers PDF
md2pdf fichier.md [options]

# Conversion vers HTML
md2html fichier.md [options]

# Conversion vers Pages (macOS uniquement)
md2pages fichier.md [options]
```

**Options communes (facultatives)**
- `-o <chemin>` : spécifier le répertoire de sortie (défaut : même répertoire que source)
- `-t <template>` : utiliser un template DOCX alternatif (pour DOCX uniquement)
- `--verbose` : afficher les détails de conversion dans le terminal
- `--no-log` : désactiver l'écriture dans le fichier de log

**Expérience utilisateur - Scénario nominal**

1. **Commande initiale :** utilisateur tape `md2docx rapport.md` et presse Enter
2. **Feedback immédiat (< 500ms) :**
   ```
   🔄 Conversion en cours : rapport.md → rapport.docx
   📄 Format source : markdown_strict
   📋 Template : reference.docx
   ```
3. **Traitement :** barre de progression ASCII ou spinner animé pendant la conversion
4. **Notification de succès (après 1-3s) :**
   ```
   ✅ Conversion terminée avec succès
   📁 Fichier généré : /Users/marcou/Documents/rapport.docx
   ⏱️  Durée : 1.8s
   📝 Log : ~/.pandoc/logs/conversion_20250115_143210.log
   ```
5. **Code de retour :** 0 (utilisable dans scripts d'automatisation)

**Expérience utilisateur - Scénario d'erreur**

1. **Commande avec fichier inexistant :** `md2docx absent.md`
2. **Feedback d'erreur (< 500ms) :**
   ```
   ❌ Erreur : fichier source introuvable
   📂 Chemin recherché : /Users/marcou

---

# Section 5 : Formats de sortie

## 5.1 Vue d'ensemble des formats

Le système de conversion prend en charge quatre formats de sortie principaux, chacun optimisé pour un cas d'usage spécifique et des exigences de distribution particulières.

| Format | Extension | Moteur de conversion | Cas d'usage prioritaire | Support plateforme |
|--------|-----------|----------------------|-------------------------|-------------------|
| DOCX | `.docx` | Pandoc natif | Collaboration Office, édition tierce | macOS, Windows |
| PDF | `.pdf` | LaTeX (principal) ou wkhtmltopdf (alternatif) | Archivage, diffusion officielle | macOS, Windows |
| HTML | `.html` | Pandoc natif | Publication web, documentation en ligne | macOS, Windows |
| Pages | `.pages` | DOCX → ouverture automatique dans Pages | Écosystème Apple, édition macOS/iOS | macOS uniquement |

**Principes communs à tous les formats :**
- Format source : `markdown_strict` (sans extensions propriétaires)
- Préservation de la structure sémantique : titres, listes, citations, code
- Cohérence typographique : police Palatino (DOCX, PDF), fonte système (HTML)
- Gestion des métadonnées : titre, auteur, date (via YAML front matter si présent)

## 5.2 Format DOCX (Microsoft Word)

### 5.2.1 Caractéristiques techniques

**Moteur de conversion**
- Pandoc natif (writer `docx`)
- Version Office Open XML : Office 2007 et supérieures
- Compatibilité : Microsoft Word (Windows/macOS), LibreOffice Writer, Google Docs, Pages (import)

**Template de référence**
- Fichier : `reference.docx` ou `template-palatino.docx`
- Localisation : `~/.pandoc/templates/` (macOS) ou `%APPDATA%\pandoc\templates\` (Windows)
- Contenu minimal requis :
  - Police corps de texte : Palatino, 12pt
  - Police titres : Palatino Bold, 14-24pt selon niveau
  - Marge droite : 2 cm (spécification stricte)
  - Marges autres : gauche 2.5 cm, haut/bas 2 cm (standard)
  - Styles : Normal, Heading 1-6, Code, Block Quote, List Paragraph

### 5.2.2 Options Pandoc

**Commande de base**
```bash
pandoc input.md \
  --from=markdown_strict \
  --to=docx \
  --reference-doc=~/.pandoc/templates/reference.docx \
  --output=output.docx
```

**Options obligatoires**
- `--from=markdown_strict` : format source strict, évite extensions non standard
- `--reference-doc=<chemin>` : application du template personnalisé
- `--output=<fichier.docx>` : spécification du fichier de sortie

**Options recommandées (à intégrer dans les fonctions)**
- `--standalone` : génération d'un document autonome complet
- `--toc` : génération d'une table des matières (si document > 5 pages)
- `--toc-depth=3` : profondeur de la table des matières (niveaux 1 à 3)
- `--number-sections` : numérotation automatique des sections
- `--highlight-style=pygments` : coloration syntaxique pour blocs de code

**Options avancées (paramétrage optionnel)**
- `--metadata title="<titre>"` : définition du titre du document
- `--metadata author="<auteur>"` : définition de l'auteur
- `--metadata date="<date>"` : définition de la date
- `--resource-path=<répertoire>` : chemin de recherche pour images et ressources

###

---

# Section 6 : Contraintes & Prérequis

## 6.1 Prérequis système

### 6.1.1 Environnement macOS

**Système d'exploitation**
- macOS 12.0 (Monterey) ou supérieur
- Architecture : Apple Silicon (M1, M2, M3) ou Intel x86_64
- Droits administrateur : requis pour installation des dépendances via Homebrew

**Shell**
- Zsh version 5.8 ou supérieure (shell par défaut depuis macOS Catalina)
- Fichier de configuration : `~/.zshrc` accessible en lecture/écriture
- Rechargement automatique : terminal doit sourcer `~/.zshrc` à l'ouverture

**Gestionnaire de paquets**
- Homebrew version 4.0 ou supérieure
- Installation native ARM64 pour Apple Silicon (répertoire `/opt/homebrew`)
- Installation Intel pour architectures x86_64 (répertoire `/usr/local`)
- Accès réseau : requis pour téléchargement et mise à jour des paquets

**Vérification de l'installation Homebrew**
```bash
# Commande de vérification
brew --version

# Sortie attendue (exemple)
Homebrew 4.2.0
```

### 6.1.2 Environnement Windows 11

**Système d'exploitation**
- Windows 11 version 22H2 ou supérieure
- Architecture : x64 ou ARM64
- Droits administrateur : requis pour installation PowerShell et Pandoc

**Shell et environnement de script**
- PowerShell 7.4 ou supérieur (PowerShell Core)
- Profil utilisateur : `$PROFILE` accessible en lecture/écriture
  - Chemin typique : `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
- Politique d'exécution : `RemoteSigned` ou `Unrestricted` pour scripts locaux

**Vérification PowerShell**
```powershell
# Commande de vérification
$PSVersionTable.PSVersion

# Sortie attendue (exemple)
Major  Minor  Patch  PreReleaseLabel BuildLabel
-----  -----  -----  --------------- ----------
7      4      1
```

**Gestionnaire de paquets (au choix)**
- Winget (intégré Windows 11) : `winget install Pandoc`
- Chocolatey : `choco install pandoc`
- Scoop : `scoop install pandoc`
- Installeur MSI officiel : téléchargement depuis pandoc.org

### 6.1.3 Moteur de conversion Pandoc

**Installation macOS via Homebrew**
```bash
# Installation Pandoc
brew install pandoc

# Vérification de l'installation
/opt/homebrew/bin/pandoc --version

# Sortie attendue (version minimale)
pandoc 3.1.x
```

**Chemin d'installation obligatoire (Apple Silicon)**
- Binaire Pandoc : `/opt/homebrew/bin/pandoc`
- Contrainte architecturale : toutes les fonctions doivent référencer ce chemin absolu
- Rationale : éviter les conflits avec d'autres installations Pandoc (MacPorts, installation manuelle)

**Installation Windows**
```powershell
# Installation via Winget (recommandé)
winget install --id JohnMacFarlane.Pandoc

# Vérification
pandoc --version
```

**Chemin d'installation Windows (recommandé)**
- Répertoire : `C:\Program Files\Pandoc\`
- Binaire : `C:\Program Files\Pandoc\pandoc.exe`
- Variable PATH : ajout automatique lors de l'installation, vérification requise

### 6.1.4 Dépendances pour génération PDF

**macOS - Distribution LaTeX**

Option 1

---

# Section 7 : Validation & Recette

## 7.1 Stratégie de validation

### 7.1.1 Principes généraux

La validation du système de conversion Pandoc multicanal repose sur trois axes principaux :

1. **Validation fonctionnelle :** vérification de la capacité de chaque interface à produire les formats de sortie attendus
2. **Validation qualitative :** contrôle de la conformité des documents générés (formatage, structure, métadonnées)
3. **Validation de performance :** mesure des temps de réponse et de conversion selon les critères définis

**Environnements de recette**
- Plateforme macOS : macOS 14.x (Sonoma) sur Apple Silicon M3
- Plateforme Windows : Windows 11 23H2 sur architecture x64
- Fichiers de test : corpus de 5 documents Markdown de complexité croissante

**Corpus de test standardisé**

| Fichier | Description | Taille | Éléments clés |
|---------|-------------|--------|---------------|
| `test_simple.md` | Document basique | ~500 mots | Titres (H1-H3), paragraphes, listes à puces |
| `test_formatage.md` | Formatage riche | ~1000 mots | Gras, italique, code inline, citations |
| `test_code.md` | Blocs de code | ~800 mots | Blocs de code avec syntaxe (Python, JavaScript, Bash) |
| `test_images.md` | Ressources externes | ~600 mots | Images locales et URLs, légendes |
| `test_complexe.md` | Document complet | ~3000 mots | Tous éléments précédents + tableaux, notes de bas de page, métadonnées YAML |

## 7.2 Critères d'acceptation par interface

### 7.2.1 Interface Terminal (macOS - Zsh)

**VA-TERM-MAC-01 : Disponibilité des commandes**
- Critère : les 4 fonctions (`md2docx`, `md2pdf`, `md2html`, `md2pages`) sont accessibles dans tout nouveau terminal
- Procédure de test :
  1. Ouvrir un nouveau terminal
  2. Exécuter `type md2docx md2pdf md2html md2pages`
  3. Vérifier que chaque commande renvoie "is a shell function"
- Résultat attendu : 4/4 fonctions reconnues
- Statut : ☐ Conforme / ☐ Non conforme

**VA-TERM-MAC-02 : Conversion DOCX fonctionnelle**
- Critère : conversion réussie avec template Palatino et marges conformes
- Procédure de test :
  1. Exécuter `md2docx test_simple.md`
  2. Vérifier la génération de `test_simple.docx` dans le même répertoire
  3. Ouvrir le fichier dans Microsoft Word ou Pages
  4. Contrôler police (Palatino), marge droite (2 cm exactement)
- Résultat attendu : fichier généré, police conforme, marge droite = 2.0 cm (± 0.1 cm tolérance)
- Statut : ☐ Conforme / ☐ Non conforme

**VA-TERM-MAC-03 : Conversion PDF fonctionnelle**
- Critère : génération PDF sans erreur LaTeX
- Procédure de test :
  1. Exécuter `md2pdf test_formatage.md`
  2. Vérifier la génération de `test_formatage.pdf`
  3. Ouvrir le PDF et contrôler : police Palatino, rendu des blocs de code, italique/gras
- Résultat attendu : PDF conforme, formatage préservé, aucune erreur

---

# Section 8 : Livrables

## 8.1 Vue d'ensemble des livrables

Le projet de mise en place du système de conversion Pandoc multicanal comprend l'ensemble des fichiers de configuration, scripts, templates et documentation nécessaires au déploiement et à l'exploitation du système sur les plateformes macOS et Windows 11.

**Classification des livrables**

| Catégorie | Nombre de fichiers | Plateformes concernées |
|-----------|-------------------|------------------------|
| Configuration Shell | 2 | macOS (Zsh), Windows (PowerShell) |
| Scripts Raycast | 4 | macOS uniquement |
| Configuration Sublime Text | 1 | macOS, Windows |
| Configuration VS Code | 1 | macOS, Windows |
| Templates Pandoc | 1 | macOS, Windows (synchronisé) |
| Scripts utilitaires | 2 | macOS, Windows |
| Documentation | 3 | macOS, Windows |
| **Total** | **14** | - |

## 8.2 Livrables macOS

### 8.2.1 Configuration Terminal Zsh

**LIV-MAC-01 : Fichier de fonctions Zsh**
- Nom : `pandoc-functions.zsh` ou intégration directe dans `~/.zshrc`
- Localisation : `~/.zshrc` (intégration) ou `~/.config/zsh/functions/` (fichier séparé sourcé)
- Contenu :
  - Fonction `md2docx` : conversion Markdown → DOCX
  - Fonction `md2pdf` : conversion Markdown → PDF
  - Fonction `md2html` : conversion Markdown → HTML
  - Fonction `md2pages` : conversion Markdown → Pages (via DOCX)
  - Fonction `md2all` : conversion vers tous les formats simultanément
  - Fonction `pandoc-check` : vérification de l'installation et des dépendances
- Format : UTF-8, LF (Unix line endings)
- Commentaires : documentation inline pour chaque fonction (syntaxe, options, exemples)
- Taille estimée : ~200-300 lignes

**Exemple de structure (extrait)**
```zsh
# Fonction de conversion Markdown vers DOCX avec template Palatino
# Usage: md2docx fichier.md [-o répertoire] [-t template]
md2docx() {
    local input="$1"
    local output_dir="${2:-.}"
    local template="${3:-$HOME/.pandoc/templates/reference.docx}"
    
    # Validation du fichier source
    if [[ ! -f "$input" ]]; then
        echo "❌ Erreur : fichier source introuvable : $input"
        return 1
    fi
    
    # [... code de conversion ...]
}
```

**LIV-MAC-02 : Script d'installation Zsh**
- Nom : `install-zsh-functions.sh`
- Localisation : racine du dépôt du projet
- Fonction : automatisation de l'intégration des fonctions dans `~/.zshrc`
- Comportement :
  1. Sauvegarde de `~/.zshrc` existant (`~/.zshrc.backup.YYYYMMDD`)
  2. Vérification de l'absence de doublons (fonctions déjà présentes)
  3. Ajout du bloc de fonctions Pandoc avec délimiteurs commentés
  4. Rechargement du shell (`source ~/.zshrc`)
  5. Validation post-installation (test des commandes)
- Format : shell script exécutable (`chmod +x`)
- Taille estimée : ~100 lignes

### 8.2.2 Scripts Raycast

**LIV-MAC-03 : Script Raycast DOCX**
- Nom : `pandoc-to-docx.sh`
- Localisation : `~/.config/raycast/scripts/` ou répertoire personn

---

