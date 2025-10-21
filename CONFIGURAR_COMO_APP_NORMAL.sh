#!/bin/bash

set -e

clear

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     ✅ CONFIGURACIÓN COMO APP iOS NORMAL                     ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

HE IDENTIFICADO EL PROBLEMA:

  El proyecto NO estaba configurado para seleccionar el Team
  automáticamente desde Xcode (como las apps normales).

HE CORREGIDO:

  ✅ Eliminé DEVELOPMENT_TEAM hardcoded del proyecto
  ✅ Ahora Xcode te pedirá seleccionar el Team (flujo normal)
  ✅ Como TODAS tus otras apps iOS

═══════════════════════════════════════════════════════════════

VOY A ABRIR EL PROYECTO EN XCODE

Vas a ver una ADVERTENCIA en amarillo que dice:
  "Signing for 'GoMaster' requires a development team"

Esto es NORMAL y ESPERADO. Así es como funcionan las apps iOS.

═══════════════════════════════════════════════════════════════

PASOS EXACTOS (30 SEGUNDOS):

1️⃣  Cuando se abra Xcode:
    → En el navegador izquierdo, haz clic en "GoMaster" (proyecto azul)

2️⃣  En el panel central:
    → Asegúrate de seleccionar el TARGET "GoMaster" (no el proyecto)

3️⃣  Haz clic en la pestaña "Signing & Capabilities"

4️⃣  Verás una advertencia:
    ⚠️  "Signing for 'GoMaster' requires a development team"

5️⃣  En el dropdown "Team":
    → Haz clic y SELECCIONA tu Apple ID de la lista
    → Aparecerá como "Tu Nombre (Personal Team)" o similar

    ⚠️  IMPORTANTE: NO escribas nada
                   SOLO selecciona de la lista dropdown

6️⃣  Automáticamente verás:
    ✅ Signing Certificate: Apple Development
    ✅ Provisioning Profile: Xcode Managed Profile
    ✅ Status: Ready to run on [tu iPhone]

7️⃣  Selecciona tu iPhone en el menú de dispositivos (arriba)

8️⃣  Presiona ⌘ + R (o botón Run ▶️)

9️⃣  ¡LA APP SE INSTALARÁ EN TU IPHONE!

═══════════════════════════════════════════════════════════════

SI NO APARECE TU APPLE ID EN EL DROPDOWN:

1. Ve a Xcode → Settings (⌘ + ,)
2. Pestaña "Accounts"
3. Si NO ves tu email, haz clic en "+"
4. Agrega tu Apple ID
5. Cierra Settings
6. Regresa a Signing & Capabilities
7. Ahora SÍ aparecerá en el dropdown

═══════════════════════════════════════════════════════════════

EOF

echo ""
echo "Presiona ENTER para abrir Xcode..."
read -r

echo ""
echo "🚀 Abriendo GoMaster.xcodeproj..."
echo ""

cd /Users/dr.alexmitre/Desktop/GO/GoMaster
open GoMaster.xcodeproj

sleep 5

cat << 'EOF'

═══════════════════════════════════════════════════════════════

✅ Xcode está abierto

RECUERDA:
  1. Clic en "GoMaster" proyecto (izquierda)
  2. Clic en "GoMaster" target (centro)
  3. Pestaña "Signing & Capabilities"
  4. Dropdown "Team" → Selecciona tu Apple ID
  5. ⌘ + R para ejecutar

Esto tomará 30 segundos.

═══════════════════════════════════════════════════════════════

Si ves la advertencia "Signing for 'GoMaster' requires a development team":

  → Esto es NORMAL
  → Solo selecciona tu Team del dropdown
  → La advertencia desaparecerá automáticamente

═══════════════════════════════════════════════════════════════

DESPUÉS DE SELECCIONAR EL TEAM:

  La app funcionará EXACTAMENTE como tus otras apps iOS.

  Podrás:
  • Presionar ⌘ + R para ejecutar
  • Instalar en tu iPhone directamente
  • Sin errores de firma
  • Sin problemas de provisioning

═══════════════════════════════════════════════════════════════

EOF
