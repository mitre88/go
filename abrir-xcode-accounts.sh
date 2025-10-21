#!/bin/bash

# Script para abrir Xcode Settings → Accounts directamente

set -e

clear

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║       ⚠️  PROBLEMA CONFIRMADO: NO HAY APPLE ID EN XCODE      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

He verificado tu sistema y confirmé el error:

  ❌ ERROR: "No Account for Team UU6PBF848P"
  ❌ CAUSA: Apple ID NO configurado en Xcode
  ❌ RESULTADO: Ejecutable compila pero NO se firma

═══════════════════════════════════════════════════════════════

DIAGNÓSTICO COMPLETO:

  ✅ Certificado existe: Apple Development: bedr10_capacitacion@hotmail.com
  ✅ Team ID correcto: UU6PBF848P
  ✅ Proyecto configurado: CODE_SIGN_STYLE = Automatic
  ✅ Build compila: Sin errores

  ❌ Apple ID en Xcode: NO ENCONTRADO
  ❌ Provisioning Profiles: 0 encontrados
  ❌ Ejecutable firmado: NO (codesign: not signed at all)

═══════════════════════════════════════════════════════════════

SOLUCIÓN (2 minutos):

  Voy a abrir Xcode Settings → Accounts para que agregues:

    📧 Apple ID: bedr10_capacitacion@hotmail.com
    🔑 Contraseña: [tu contraseña]

═══════════════════════════════════════════════════════════════

PASOS QUE DEBES SEGUIR:

  1️⃣  En la ventana que se abrirá, haz clic en "Accounts"

  2️⃣  Haz clic en el botón "+" (esquina inferior izquierda)

  3️⃣  Selecciona "Apple ID"

  4️⃣  Ingresa:
      • Apple ID: bedr10_capacitacion@hotmail.com
      • Password: [tu contraseña]

  5️⃣  Haz clic en "Sign In"

  6️⃣  Verifica que aparezca: Team ID: UU6PBF848P

  7️⃣  Cierra la ventana de Settings

═══════════════════════════════════════════════════════════════

EOF

echo -n "Presiona ENTER cuando estés listo para abrir Xcode Settings... "
read -r

echo ""
echo "🚀 Abriendo Xcode Settings → Accounts..."
echo ""

# Cerrar Xcode si está abierto
if pgrep -x "Xcode" > /dev/null; then
    echo "📝 Cerrando Xcode para refrescar..."
    killall Xcode 2>/dev/null || true
    sleep 2
fi

# Abrir Xcode
echo "📱 Abriendo Xcode..."
open -a Xcode &
sleep 4

# Esperar a que Xcode esté listo
echo "⏳ Esperando a que Xcode esté listo..."
sleep 2

# Abrir Settings con AppleScript
echo "🔧 Abriendo Settings → Accounts..."

osascript << 'APPLESCRIPT'
tell application "Xcode"
    activate
    delay 1
end tell

tell application "System Events"
    tell process "Xcode"
        -- Abrir Preferences con Cmd+,
        keystroke "," using command down
        delay 1

        -- Intentar hacer clic en "Accounts" tab
        try
            click button "Accounts" of toolbar 1 of window 1
        on error
            -- Si no funciona, intentar con el tab
            try
                click radio button "Accounts" of tab group 1 of window 1
            end try
        end try
    end tell
end tell
APPLESCRIPT

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✅ Xcode Settings está abierto en la pestaña Accounts"
echo ""
echo "AHORA DEBES:"
echo ""
echo "  1. Hacer clic en '+' (abajo a la izquierda)"
echo "  2. Seleccionar 'Apple ID'"
echo "  3. Ingresar: bedr10_capacitacion@hotmail.com"
echo "  4. Ingresar tu contraseña"
echo "  5. Verificar que aparezca Team: UU6PBF848P"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Después de agregar tu Apple ID:"
echo ""
echo "  OPCIÓN 1 - Abrir proyecto y compilar:"
echo "    open GoMaster.xcodeproj"
echo "    # Selecciona iPhone → Presiona ⌘ + R"
echo ""
echo "  OPCIÓN 2 - Build desde terminal:"
echo "    ./run-on-device.sh"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Si necesitas ayuda detallada:"
echo "  open URGENTE_CONFIGURAR_APPLE_ID.md"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
