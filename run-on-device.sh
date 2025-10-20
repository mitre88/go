#!/bin/bash

# GoMaster - Run on Physical Device
# Compila e instala la app en tu iPhone conectado

set -e

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "   GoMaster - Build & Run en iPhone"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_FILE="$PROJECT_DIR/GoMaster.xcodeproj"
SCHEME="GoMaster"
DEVICE_ID="00008130-0002512C1883401C"
DEVICE_NAME="iPhone de Dr Mitre"

cd "$PROJECT_DIR"

echo -e "${BLUE}📋 Configuración:${NC}"
echo "  • Proyecto: GoMaster.xcodeproj"
echo "  • Scheme: $SCHEME"
echo "  • Dispositivo: $DEVICE_NAME"
echo "  • Device ID: $DEVICE_ID"
echo ""

# Verificar que el dispositivo esté conectado
echo -e "${BLUE}📱 Verificando conexión del iPhone...${NC}"
if xcrun devicectl list devices | grep -q "$DEVICE_ID"; then
    echo -e "${GREEN}✅ iPhone conectado y reconocido${NC}"
else
    echo -e "${YELLOW}⚠️  Advertencia: iPhone no detectado${NC}"
    echo ""
    echo "Asegúrate de:"
    echo "  1. Conectar el iPhone con cable USB"
    echo "  2. Desbloquear el iPhone"
    echo "  3. Confiar en esta Mac (si aparece el mensaje)"
    echo ""
    echo -e "${YELLOW}¿Deseas continuar de todas formas? (y/n)${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Cancelado."
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}🧹 Limpiando build anterior...${NC}"
rm -rf ~/Library/Developer/Xcode/DerivedData/GoMaster-*
xcodebuild clean -project "$PROJECT_FILE" -scheme "$SCHEME" > /dev/null 2>&1 || true

echo ""
echo -e "${BLUE}🔨 Compilando para iPhone...${NC}"
echo ""

# Build con output en tiempo real
xcodebuild build \
    -project "$PROJECT_FILE" \
    -scheme "$SCHEME" \
    -destination "platform=iOS,id=$DEVICE_ID" \
    -allowProvisioningUpdates \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM=UU6PBF848P \
    2>&1 | while read line; do
        if echo "$line" | grep -q "error:"; then
            echo -e "${RED}$line${NC}"
        elif echo "$line" | grep -q "warning:"; then
            echo -e "${YELLOW}$line${NC}"
        elif echo "$line" | grep -q "BUILD SUCCEEDED"; then
            echo -e "${GREEN}$line${NC}"
        elif echo "$line" | grep -q "BUILD FAILED"; then
            echo -e "${RED}$line${NC}"
        elif echo "$line" | grep -qE "Compiling|Linking|Signing"; then
            echo -e "${BLUE}$line${NC}"
        fi
    done

# Verificar si el build fue exitoso
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ BUILD EXITOSO${NC}"
    echo ""

    # Buscar el .app generado
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/GoMaster-*/Build/Products/Debug-iphoneos -name "GoMaster.app" 2>/dev/null | head -1)

    if [ -n "$APP_PATH" ]; then
        echo -e "${BLUE}📦 App generada en:${NC}"
        echo "  $APP_PATH"
        echo ""

        # Información sobre el binario
        echo -e "${BLUE}ℹ️  Información del ejecutable:${NC}"
        EXECUTABLE="$APP_PATH/GoMaster"

        if [ -f "$EXECUTABLE" ]; then
            # Verificar firma
            echo -n "  • Firmado: "
            if codesign -v "$EXECUTABLE" 2>/dev/null; then
                echo -e "${GREEN}Sí ✅${NC}"

                # Mostrar identidad de firma
                SIGNING_ID=$(codesign -dvv "$EXECUTABLE" 2>&1 | grep "Authority=" | head -1 | cut -d= -f2)
                echo "  • Identidad: $SIGNING_ID"

                # Mostrar team ID
                TEAM_ID=$(codesign -dvv "$EXECUTABLE" 2>&1 | grep "TeamIdentifier=" | cut -d= -f2)
                echo "  • Team ID: $TEAM_ID"
            else
                echo -e "${RED}No ❌${NC}"
                echo ""
                echo -e "${RED}ERROR: El ejecutable no está firmado correctamente${NC}"
                exit 1
            fi

            # Verificar arquitectura
            ARCH=$(lipo -info "$EXECUTABLE" 2>/dev/null | grep "Non-fat file" | awk '{print $NF}' || lipo -info "$EXECUTABLE" 2>/dev/null)
            echo "  • Arquitectura: $ARCH"

            # Tamaño
            SIZE=$(du -h "$EXECUTABLE" | cut -f1)
            echo "  • Tamaño: $SIZE"
        fi

        echo ""
        echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}   ¡LISTO PARA INSTALAR EN TU IPHONE!${NC}"
        echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        echo "Opciones para instalar:"
        echo ""
        echo "  1️⃣  OPCIÓN RECOMENDADA - Desde Xcode:"
        echo "     • Abre: open GoMaster.xcodeproj"
        echo "     • Selecciona tu iPhone en el menú de dispositivos"
        echo "     • Presiona ⌘ + R (o botón Run ▶️)"
        echo ""
        echo "  2️⃣  Desde Xcode con este comando:"
        echo "     open GoMaster.xcodeproj"
        echo ""
        echo "NOTA: La primera vez que ejecutes la app en tu iPhone:"
        echo "  • Ve a Settings → General → VPN & Device Management"
        echo "  • Toca en 'Apple Development: bedr10_capacitacion@hotmail.com'"
        echo "  • Toca 'Trust' y confirma"
        echo ""
    else
        echo -e "${YELLOW}⚠️  No se encontró el archivo .app generado${NC}"
        echo ""
        echo "El build fue exitoso pero no se puede localizar la app."
        echo "Abre el proyecto en Xcode y ejecuta desde ahí:"
        echo "  open GoMaster.xcodeproj"
    fi
else
    echo ""
    echo -e "${RED}❌ BUILD FALLÓ${NC}"
    echo ""
    echo "Posibles causas:"
    echo ""
    echo "  1. No has agregado tu Apple ID en Xcode"
    echo "     → Ejecuta: ./setup-xcode-account.sh"
    echo "     → O lee: CONFIGURAR_CUENTA.md"
    echo ""
    echo "  2. Team ID incorrecto o expirado"
    echo "     → Verifica en Xcode Settings → Accounts"
    echo ""
    echo "  3. Certificado de desarrollo inválido"
    echo "     → Elimina y regenera en Xcode Settings → Accounts"
    echo ""
    echo "  4. Errores de compilación en el código"
    echo "     → Revisa los errores mostrados arriba"
    echo ""
    exit 1
fi

echo "═══════════════════════════════════════════════════════════"
echo ""
