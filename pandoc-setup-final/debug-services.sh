#!/bin/zsh
# Script de debug pour les services Pandoc

echo "🔍 Debug Services Pandoc"
echo "======================="
echo ""

# Test 1 : Vérifier les scripts
echo "1️⃣ Vérification des scripts dans ~/bin/"
echo ""

if [ -f "$HOME/bin/pandoc-service-docx" ]; then
    echo "✅ pandoc-service-docx trouvé"
    ls -lh "$HOME/bin/pandoc-service-docx"
else
    echo "❌ pandoc-service-docx NOT FOUND"
fi

if [ -f "$HOME/bin/pandoc-service-pdf" ]; then
    echo "✅ pandoc-service-pdf trouvé"
    ls -lh "$HOME/bin/pandoc-service-pdf"
else
    echo "❌ pandoc-service-pdf NOT FOUND"
fi

if [ -f "$HOME/bin/pandoc-service-html" ]; then
    echo "✅ pandoc-service-html trouvé"
    ls -lh "$HOME/bin/pandoc-service-html"
else
    echo "❌ pandoc-service-html NOT FOUND"
fi

echo ""
echo "2️⃣ Vérification des permissions"
echo ""

for script in ~/bin/pandoc-service-*; do
    if [ -x "$script" ]; then
        echo "✅ $(basename $script) : exécutable"
    else
        echo "❌ $(basename $script) : NON exécutable"
    fi
done

echo ""
echo "3️⃣ Test d'exécution manuelle"
echo ""

# Créer un fichier de test temporaire
TEST_FILE="/tmp/test-service-debug.md"
cat > "$TEST_FILE" << 'EOFTEST'
# Test Debug

Fichier de test pour debug.
EOFTEST

echo "📝 Fichier de test créé: $TEST_FILE"
echo ""

echo "🧪 Test du script DOCX..."
echo "Commande: ~/bin/pandoc-service-docx $TEST_FILE"
echo ""

# Exécuter avec sortie visible
~/bin/pandoc-service-docx "$TEST_FILE" 2>&1

echo ""
echo "4️⃣ Vérification du résultat"
echo ""

if [ -f "/tmp/test-service-debug.docx" ]; then
    echo "✅ Fichier DOCX créé!"
    ls -lh /tmp/test-service-debug.docx
else
    echo "❌ Fichier DOCX NON créé"
fi

echo ""
echo "5️⃣ Vérification des workflows"
echo ""

if [ -d "$HOME/Library/Services/Pandoc → DOCX.workflow" ]; then
    echo "✅ Workflow DOCX trouvé"
    ls -lh "$HOME/Library/Services/Pandoc → DOCX.workflow"
else
    echo "❌ Workflow DOCX NOT FOUND"
fi

echo ""
echo "6️⃣ Test de la fonction md2docx directement"
echo ""

if type md2docx &>/dev/null; then
    echo "✅ Fonction md2docx disponible"
    echo "Test direct de la fonction:"
    md2docx "$TEST_FILE" 2>&1
else
    echo "❌ Fonction md2docx non disponible"
    echo "Test Pandoc direct:"
    pandoc "$TEST_FILE" -s --toc -o /tmp/test-direct.docx && echo "✅ Pandoc fonctionne directement"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Résumé du diagnostic"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Si tu vois des ❌, copie-moi TOUTE la sortie de ce script."
echo "Je pourrai identifier précisément le problème."
echo ""
