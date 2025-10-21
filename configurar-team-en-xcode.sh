#!/bin/bash

clear

cat << 'EOF'

╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     🔧 CONFIGURAR TEAM MANUALMENTE EN XCODE                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

He detectado que aunque agregaste tu Apple ID, Xcode NO lo está
reconociendo correctamente.

CAUSA:
  El DEVELOPMENT_TEAM estaba hardcoded como string en el proyecto
  y Xcode no puede vincularlo a tu Apple ID automáticamente.

SOLUCIÓN:
  Voy a abrir el proyecto en Xcode para que MANUALMENTE selecciones
  el Team desde la interfaz gráfica.

═══════════════════════════════════════════════════════════════

INSTRUCCIONES - SIGUE ESTOS PASOS EXACTAMENTE:

1️⃣  Cuando se abra Xcode:
    - Espera a que cargue el proyecto completamente

2️⃣  En el navegador izquierdo:
    - Haz clic en "GoMaster" (el proyecto azul arriba)

3️⃣  En el panel central:
    - Asegúrate de seleccionar el TARGET "GoMaster" (no el proyecto)
    - Haz clic en la pestaña "Signing & Capabilities"

4️⃣  En la sección de Signing:
    - ✅ Verifica que "Automatically manage signing" ESTÉ MARCADO
    - 📋 En "Team": Haz clic en el dropdown
    - 👤 Selecciona tu nombre/email de la lista
        (Debe aparecer algo como "Personal Team" o tu nombre)

5️⃣  Verificar que aparezca:
    - ✅ "Signing Certificate: Apple Development"
    - ✅ "Provisioning Profile: Xcode Managed Profile"
    - ✅ Mensaje: "Ready to run on [tu iPhone]"

6️⃣  Si ves ERRORES o ADVERTENCIAS:
    - Haz clic en "Try Again" o "Download Manual Profiles"
    - O dime qué error específico aparece

═══════════════════════════════════════════════════════════════

ERRORES COMUNES Y SOLUCIONES:

❌ "No signing certificate found"
   → Haz clic en el Team dropdown y selecciona tu Apple ID
   → Xcode generará el certificado automáticamente

❌ "Failed to create provisioning profile"
   → Cambia el Bundle Identifier a algo único:
     com.tuapellido.gomaster

❌ "No teams available"
   → Regresa a Xcode Settings (⌘+,) → Accounts
   → Verifica que tu Apple ID esté ahí
   → Cierra y vuelve a abrir Xcode

═══════════════════════════════════════════════════════════════

EOF

echo -n "Presiona ENTER para abrir Xcode... "
read -r

echo ""
echo "🚀 Abriendo proyecto en Xcode..."
echo ""

cd /Users/dr.alexmitre/Desktop/GO/GoMaster
open GoMaster.xcodeproj

sleep 3

cat << 'EOF'

═══════════════════════════════════════════════════════════════

✅ Xcode está abierto

AHORA DEBES:
  1. Esperar a que cargue
  2. Clic en "GoMaster" (proyecto) en navegador izquierdo
  3. Clic en "GoMaster" (target)
  4. Clic en "Signing & Capabilities"
  5. Seleccionar tu Team en el dropdown

═══════════════════════════════════════════════════════════════

DESPUÉS de seleccionar el Team:

  - Si ves "Ready to run", presiona ⌘ + R para ejecutar
  - Si ves errores, dime cuáles son

═══════════════════════════════════════════════════════════════

EOF
