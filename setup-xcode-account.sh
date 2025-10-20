#!/bin/bash

# GoMaster - Setup Xcode Account Helper
# Este script ayuda a configurar la cuenta de Apple ID en Xcode

set -e

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "   GoMaster - Configuración de Cuenta Apple ID"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar certificado
echo -e "${BLUE}📋 Verificando certificado de desarrollo...${NC}"
CERT=$(security find-identity -v -p codesigning | grep "Apple Development" | head -1)

if [ -z "$CERT" ]; then
    echo -e "${RED}❌ No se encontró certificado de desarrollo${NC}"
    echo ""
    echo "Necesitas un certificado de desarrollo para firmar apps."
    echo "Se creará automáticamente cuando agregues tu Apple ID en Xcode."
else
    echo -e "${GREEN}✅ Certificado encontrado:${NC}"
    echo "$CERT"
fi

echo ""
echo -e "${BLUE}📱 Información del proyecto:${NC}"
echo "  • Team ID: UU6PBF848P"
echo "  • Bundle ID: com.gomaster.app.dr.alexmitre"
echo "  • Apple ID esperado: bedr10_capacitacion@hotmail.com"
echo ""

# Verificar si Xcode está abierto
if pgrep -x "Xcode" > /dev/null; then
    echo -e "${YELLOW}⚠️  Xcode está abierto. Cerrándolo para refrescar configuración...${NC}"
    killall Xcode 2>/dev/null || true
    sleep 2
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "   INSTRUCCIONES"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Voy a abrir Xcode Settings para que agregues tu cuenta:"
echo ""
echo "  1️⃣  En la ventana que se abrirá, ve a 'Accounts'"
echo "  2️⃣  Haz clic en el botón '+' (abajo a la izquierda)"
echo "  3️⃣  Selecciona 'Apple ID'"
echo "  4️⃣  Ingresa:"
echo "      • Apple ID: bedr10_capacitacion@hotmail.com"
echo "      • Contraseña: [tu contraseña]"
echo "  5️⃣  Haz clic en 'Sign In'"
echo "  6️⃣  Verifica que aparezca el Team: UU6PBF848P"
echo "  7️⃣  Cierra Settings"
echo ""
echo -e "${GREEN}Presiona ENTER cuando estés listo para abrir Xcode Settings...${NC}"
read -r

# Abrir Xcode Settings
echo ""
echo -e "${BLUE}🚀 Abriendo Xcode Settings...${NC}"

# Primero abrir Xcode
open -a Xcode

# Esperar a que Xcode esté listo
sleep 3

# Abrir preferences con AppleScript
osascript <<EOF
tell application "Xcode"
    activate
end tell

tell application "System Events"
    tell process "Xcode"
        keystroke "," using command down
    end tell
end tell
EOF

echo ""
echo -e "${GREEN}✅ Xcode Settings abierto${NC}"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "Después de configurar tu cuenta en Xcode:"
echo ""
echo "  📖 Lee: CONFIGURAR_CUENTA.md (instrucciones detalladas)"
echo "  🎮 O ejecuta: ./run-on-device.sh (para probar en iPhone)"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
