# 🔐 Guía de Configuración de Code Signing - GoMaster

## ❌ Error que Estás Viendo

```
The executable is not codesigned.
Domain: LaunchExecutableValidationErrorDomain
Code: 1
```

Este error significa que necesitas firmar la app antes de instalarla en un dispositivo físico iOS.

---

## ✅ Solución Rápida: Usa el Simulador

**La forma MÁS RÁPIDA de probar la app:**

1. En Xcode, en la barra superior, click en el selector de dispositivo
2. Busca **iPhone 16 Pro** con el icono del simulador (📱)
3. Selecciónalo
4. Presiona `⌘ + R`
5. ¡Listo! La app se abrirá en el simulador

**Ventajas:**
- ✅ No requiere configuración
- ✅ No necesita Apple Developer account
- ✅ 100% gratis
- ✅ Funciona inmediatamente

---

## 🔧 Solución Completa: Configurar Code Signing

Si **necesitas** probarlo en tu iPhone físico, sigue estos pasos:

### Requisitos Previos

- [ ] Apple Developer Account (Individual: $99/año o Team)
- [ ] iPhone conectado por USB
- [ ] iPhone desbloqueado y confiando en tu Mac

### Paso 1: Configurar Apple Developer Account

#### 1.1 Registrarse (si no tienes cuenta)

```bash
# Abre el navegador en la página de registro
open "https://developer.apple.com/programs/"
```

- Click en **"Enroll"**
- Sigue el proceso de registro
- Paga $99/año (individual) o únete a un team
- Espera aprobación (24-48 horas)

#### 1.2 Agregar Apple ID en Xcode

1. Abre Xcode
2. Menú: **Xcode → Settings** (o presiona `⌘ + ,`)
3. Ve a la pestaña **"Accounts"**
4. Click en **"+"** (esquina inferior izquierda)
5. Selecciona **"Apple ID"**
6. Ingresa tu Apple ID y contraseña
7. Click **"Next"**
8. Autenticación de dos factores (si la tienes)
9. Click **"Done"**

### Paso 2: Descargar Certificados

1. En **Xcode → Settings → Accounts**
2. Selecciona tu Apple ID en la lista
3. Click en **"Manage Certificates..."** (abajo derecha)
4. Click en **"+"** (abajo izquierda)
5. Selecciona **"Apple Development"**
6. Espera a que se descargue
7. Click **"Done"**

### Paso 3: Configurar el Proyecto

#### 3.1 Abrir Configuración del Target

1. En Xcode, en el navegador izquierdo (Project Navigator)
2. Click en el proyecto **"GoMaster"** (el azul de arriba)
3. En la sección TARGETS, selecciona **"GoMaster"**
4. Ve a la pestaña **"Signing & Capabilities"**

#### 3.2 Habilitar Automatic Signing

```
☑️ Automatically manage signing
```

Marca esta casilla. Xcode manejará todo automáticamente.

#### 3.3 Seleccionar Team

En el dropdown **"Team"**:
- Selecciona tu nombre (Personal Team) o
- Selecciona tu equipo de organización

Si no aparece ningún team:
- Ve a Paso 1 y verifica que agregaste tu Apple ID
- Asegúrate de tener una cuenta de Developer válida

#### 3.4 Configurar Bundle Identifier

El Bundle ID debe ser **único** en el mundo:

```
Formato: com.TU_NOMBRE.gomaster

Ejemplos:
- com.alexmitre.gomaster
- com.tuempresa.gomaster
- com.tunombre.go
```

**Cambiar el Bundle ID:**
1. En "Signing & Capabilities"
2. Busca "Bundle Identifier"
3. Cámbialo a tu ID único
4. Presiona Enter

#### 3.5 Verificar Signing Certificate

Después de configurar, deberías ver:

```
✅ Signing Certificate: Apple Development
✅ Provisioning Profile: Xcode Managed Profile
✅ Team: Tu Nombre (Personal Team)
```

Si ves errores en rojo, lee el mensaje y corrige.

### Paso 4: Configurar el iPhone

#### 4.1 Conectar iPhone

1. Conecta tu iPhone al Mac con cable USB
2. Desbloquea el iPhone
3. Si aparece "Trust This Computer?", tap **"Trust"**
4. Ingresa el passcode del iPhone

#### 4.2 Verificar en Xcode

En Xcode, en el selector de dispositivo, deberías ver tu iPhone:
```
iPhone de [Tu Nombre]
iOS 26.1
```

### Paso 5: Build y Deploy

#### 5.1 Limpiar Build Anterior

```
⌘ + Shift + K
```

O menú: **Product → Clean Build Folder**

#### 5.2 Build

```
⌘ + B
```

O menú: **Product → Build**

Espera a que termine (verás progreso en la barra superior).

#### 5.3 Confiar en el Desarrollador (Primera Vez)

Después del primer build en tu iPhone:

1. **En el iPhone**, ve a:
   ```
   Settings (Ajustes)
   → General
   → VPN & Device Management
   ```

2. Busca tu Apple ID o nombre de desarrollador

3. Tap en él

4. Tap **"Trust [Tu Nombre]"**

5. Confirma **"Trust"**

#### 5.4 Run

```
⌘ + R
```

O menú: **Product → Run**

La app se instalará y abrirá en tu iPhone.

---

## 🐛 Troubleshooting

### Error: "No signing certificate found"

**Solución:**
1. Ve a Xcode → Settings → Accounts
2. Selecciona tu Apple ID
3. Click "Manage Certificates"
4. Click "+" → "Apple Development"

### Error: "Failed to register bundle identifier"

**Solución:**
1. Cambia el Bundle ID a algo único
2. Ejemplo: `com.tunombre.gomaster123`

### Error: "iPhone is locked"

**Solución:**
1. Desbloquea tu iPhone
2. Mantén la pantalla encendida durante el deploy

### Error: "This device is not registered"

**Solución:**
1. Si tienes cuenta Individual Developer ($99):
   - Ve a https://developer.apple.com/account
   - Devices → Register New Device
   - Agrega tu iPhone's UDID

2. Si usas "Personal Team" (gratis):
   - Solo puedes tener 3 dispositivos
   - Borra uno viejo si necesitas

### Error: "Provisioning profile doesn't match"

**Solución:**
1. En Signing & Capabilities
2. Desmarca "Automatically manage signing"
3. Vuelve a marcar "Automatically manage signing"
4. Espera que Xcode regenere el profile

### Error: "The maximum number of apps has been installed"

**Solución:**
1. Con cuenta gratuita (Personal Team):
   - Solo 3 apps simultáneas
   - Borra una app del iPhone
   
2. Con cuenta Developer ($99):
   - Sin límite

---

## 📋 Checklist Completo

Antes de hacer Run, verifica:

- [ ] Apple ID agregado en Xcode Settings → Accounts
- [ ] Certificado "Apple Development" descargado
- [ ] Project → Target → Signing & Capabilities configurado
- [ ] "Automatically manage signing" está marcado
- [ ] Team seleccionado
- [ ] Bundle ID único configurado
- [ ] iPhone conectado y desbloqueado
- [ ] "Trust This Computer" aceptado en iPhone
- [ ] Desarrollador confiado en iPhone (Settings → General → VPN & Device Management)
- [ ] Build limpio (⌘ + Shift + K)
- [ ] No hay errores en rojo en Signing & Capabilities

---

## 🚀 Alternativas

### Opción 1: TestFlight (Recomendado para Testing)

1. Crea un archive (Product → Archive)
2. Distribute → App Store Connect
3. Súbelo a TestFlight
4. Invítate a ti mismo como tester
5. Instala desde TestFlight app en iPhone

**Ventajas:**
- No necesita cable USB
- Funciona over-the-air
- Múltiples testers
- Versión de producción

### Opción 2: Simulador (Más Rápido)

Simplemente usa el simulador de iPhone:
- iPhone 16 Pro (simulador)
- ⌘ + R
- Listo

**Ventajas:**
- Cero configuración
- Gratis
- Rápido
- Ideal para desarrollo

---

## 📞 Ayuda Adicional

### Recursos Oficiales

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [Xcode Help](https://help.apple.com/xcode/)

### Si Sigues Teniendo Problemas

1. **Revisa el console de Xcode:**
   - View → Debug Area → Show Debug Area
   - Lee los mensajes de error completos

2. **Limpia TODO:**
   ```bash
   # En terminal, desde el directorio del proyecto
   rm -rf ~/Library/Developer/Xcode/DerivedData/GoMaster-*
   ```

3. **Reinicia Xcode:**
   - Quit Xcode completamente
   - Vuelve a abrirlo

4. **Reinicia el iPhone:**
   - A veces ayuda

---

## ✅ Resumen Rápido

**Para desarrollo (recomendado):**
```
Use el SIMULADOR → Selecciona "iPhone 16 Pro" → ⌘ + R
```

**Para dispositivo físico:**
```
1. Xcode Settings → Accounts → Agregar Apple ID
2. Target → Signing & Capabilities → Automatic Signing
3. Seleccionar Team
4. Cambiar Bundle ID a único
5. iPhone: Settings → Trust Developer
6. ⌘ + Shift + K (Clean)
7. ⌘ + R (Run)
```

---

**¿Necesitas más ayuda?** Corre el script helper:

```bash
./setup-signing.sh
```

---

*Última actualización: 2025-01-20*
