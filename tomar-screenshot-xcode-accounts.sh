#!/bin/bash

clear

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     📸 NECESITO VER TU CONFIGURACIÓN DE XCODE                ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

Los logs confirman que:
  ✅ Simulator builds funcionan
  ❌ Device builds fallan: "No Account for Team UU6PBF848P"

Esto significa que tu Apple ID NO está correctamente configurado.

═══════════════════════════════════════════════════════════════

VOY A ABRIR XCODE SETTINGS → ACCOUNTS

Por favor TOMA UN SCREENSHOT de lo que ves.

PASOS:

1. Voy a abrir Xcode Settings → Accounts
2. TÚ tomas screenshot: ⌘ + Shift + 4
3. Arrastra el cursor para seleccionar toda la ventana
4. El screenshot se guardará en Desktop

BUSCA EN LA PANTALLA:
  - ¿Hay alguna cuenta listada en el lado izquierdo?
  - ¿Dice "bedr10_capacitacion@hotmail.com"?
  - ¿O está vacío (sin cuentas)?

═══════════════════════════════════════════════════════════════

EOF

echo -n "Presiona ENTER para abrir Xcode Settings... "
read -r

# Cerrar Xcode si está abierto
if pgrep -x "Xcode" > /dev/null; then
    killall Xcode 2>/dev/null || true
    sleep 2
fi

# Abrir Xcode
open -a Xcode &
sleep 4

# Abrir Settings → Accounts
osascript << 'APPLESCRIPT'
tell application "Xcode"
    activate
    delay 2
end tell

tell application "System Events"
    tell process "Xcode"
        keystroke "," using command down
        delay 1
    end tell
end tell
APPLESCRIPT

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✅ Xcode Settings debería estar abierto"
echo ""
echo "AHORA:"
echo "  1. ⌘ + Shift + 4 para tomar screenshot"
echo "  2. Arrastra para seleccionar la ventana completa"
echo "  3. Dime qué ves:"
echo "     a) ¿Hay cuentas en el lado izquierdo?"
echo "     b) ¿Dice 'bedr10_capacitacion@hotmail.com'?"
echo "     c) ¿Está vacío?"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
