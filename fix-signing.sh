#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║      GoMaster - Auto-Configuración de Code Signing       ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Detectar el Team ID automáticamente
echo "🔍 Buscando tu Apple Developer Team..."

# Buscar el primer Team ID disponible
TEAM_ID=$(security find-identity -v -p codesigning | grep "Apple Development" | head -1 | sed 's/.*(\([^)]*\)).*/\1/' | tr -d ' ')

if [ -z "$TEAM_ID" ]; then
    echo ""
    echo "⚠️  No se encontró un certificado de desarrollo."
    echo ""
    echo "SOLUCIÓN RÁPIDA:"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "1. Abre Xcode"
    echo "2. Presiona: ⌘ + , (Cmd + coma)"
    echo "3. Ve a: Accounts"
    echo "4. Si no ves tu Apple ID:"
    echo "   - Click en '+'"
    echo "   - Agrega tu Apple ID"
    echo ""
    echo "5. Si ya está tu Apple ID:"
    echo "   - Selecciónalo"
    echo "   - Click 'Manage Certificates'"
    echo "   - Click '+' → 'Apple Development'"
    echo ""
    echo "6. Vuelve a ejecutar este script:"
    echo "   ./fix-signing.sh"
    echo ""
    exit 1
fi

echo "✅ Team encontrado!"
echo ""

# Generar un Bundle ID único basado en el usuario
BUNDLE_ID="com.gomaster.app.$(whoami | tr -d ' ')"

echo "📱 Configurando proyecto..."
echo "   Team ID: $TEAM_ID"
echo "   Bundle ID: $BUNDLE_ID"
echo ""

# Modificar el proyecto usando PlistBuddy y sed
PROJECT_FILE="GoMaster.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: No se encuentra el archivo del proyecto"
    exit 1
fi

# Backup del proyecto original
cp "$PROJECT_FILE" "${PROJECT_FILE}.backup"

# Reemplazar DEVELOPMENT_TEAM vacío con el Team ID encontrado
sed -i '' "s/DEVELOPMENT_TEAM = \"\";/DEVELOPMENT_TEAM = \"$TEAM_ID\";/g" "$PROJECT_FILE"

# Reemplazar Bundle ID
sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = com.gomaster.app;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;/g" "$PROJECT_FILE"

echo "✅ Proyecto configurado correctamente!"
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                    CONFIGURACIÓN COMPLETA                 ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Ahora puedes:"
echo ""
echo "1. Abrir el proyecto:"
echo "   open GoMaster.xcodeproj"
echo ""
echo "2. Conecta tu iPhone con cable USB"
echo ""
echo "3. Selecciona tu iPhone en la barra superior de Xcode"
echo ""
echo "4. Presiona: ⌘ + R"
echo ""
echo "5. En tu iPhone (primera vez):"
echo "   Settings → General → VPN & Device Management"
echo "   → Trust tu desarrollador"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "✅ Tu app funcionará en CUALQUIER iPhone que conectes!"
echo ""
