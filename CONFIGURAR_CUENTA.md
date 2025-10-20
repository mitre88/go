# Configurar Cuenta de Apple ID en Xcode

## El problema que encontramos

Tu proyecto está correctamente configurado, pero Xcode necesita que agregues tu cuenta de Apple ID para poder firmar la app automáticamente.

## Información detectada

- **Certificado de desarrollo encontrado**: Apple Development: bedr10_capacitacion@hotmail.com (UU6PBF848P)
- **Team ID**: UU6PBF848P
- **Bundle ID**: com.gomaster.app.dr.alexmitre

## Pasos para configurar (2 minutos)

### 1. Abrir Xcode Settings

```bash
# Opción 1: Desde terminal
open -a Xcode
```

Luego en Xcode:
- Presiona `⌘ + ,` (Command + Coma) para abrir Settings
- O ve a menú: **Xcode → Settings...**

### 2. Agregar tu Apple ID

1. En Settings, selecciona la pestaña **Accounts**
2. Haz clic en el botón **+** (abajo a la izquierda)
3. Selecciona **Apple ID**
4. Ingresa tus credenciales:
   - **Apple ID**: bedr10_capacitacion@hotmail.com
   - **Contraseña**: [tu contraseña]
5. Haz clic en **Sign In**

### 3. Verificar el Team

Después de iniciar sesión:
1. Selecciona tu cuenta en la lista
2. En el panel derecho verás tu **Team**
3. Verifica que aparezca el Team ID: **UU6PBF848P**

### 4. Abrir el proyecto

```bash
cd ~/Desktop/GO/GoMaster
open GoMaster.xcodeproj
```

### 5. Verificar Signing en el proyecto

En Xcode, con el proyecto abierto:
1. Selecciona el proyecto **GoMaster** en el navegador (izquierda)
2. Selecciona el target **GoMaster**
3. Ve a la pestaña **Signing & Capabilities**
4. Verifica:
   - ✅ **Automatically manage signing** debe estar marcado
   - ✅ **Team** debe mostrar tu nombre y (UU6PBF848P)
   - ✅ **Bundle Identifier**: com.gomaster.app.dr.alexmitre
   - ✅ **Signing Certificate**: Apple Development: bedr10_capacitacion@hotmail.com
   - ✅ **Provisioning Profile**: Xcode Managed Profile

Si todo está correcto, deberías ver **"Ready to run on [nombre de tu iPhone]"**.

### 6. Conectar tu iPhone y ejecutar

1. Conecta tu iPhone con el cable USB
2. Desbloquea el iPhone
3. Si aparece un mensaje "Trust This Computer", toca **Trust**
4. En Xcode, selecciona tu iPhone en el menú de dispositivos (arriba, junto a "GoMaster")
5. Presiona `⌘ + R` o el botón **Run** ▶️

### 7. Primera vez en el dispositivo

La primera vez que ejecutes una app de desarrollo en tu iPhone:
1. La app se instalará pero no se abrirá
2. En tu iPhone, ve a: **Settings → General → VPN & Device Management**
3. Toca en **Apple Development: bedr10_capacitacion@hotmail.com**
4. Toca **Trust "Apple Development..."**
5. Confirma
6. Regresa a Xcode y presiona `⌘ + R` de nuevo

## Troubleshooting

### Error: "Failed to register bundle identifier"
- Ve a Signing & Capabilities
- Cambia el Bundle ID a algo único, por ejemplo:
  `com.tuapellido.gomaster`

### Error: "Your maximum App ID limit has been reached"
- Con una cuenta gratuita de Apple Developer solo puedes tener 10 App IDs
- Puedes eliminar IDs antiguos en: https://developer.apple.com/account
- O usa el script `cleanup-old-profiles.sh` (si está disponible)

### Error: Certificado expirado
```bash
# Verificar fecha de expiración
security find-certificate -c "Apple Development" -p | openssl x509 -noout -dates
```

### Error: iPhone no aparece en Xcode
1. Desconecta y reconecta el iPhone
2. Desbloquea el iPhone
3. Reinicia Xcode: `killall Xcode && open -a Xcode`
4. Verifica que el iPhone confíe en la Mac

## Verificación final

Una vez configurada la cuenta, puedes verificar que todo esté listo desde terminal:

```bash
cd ~/Desktop/GO/GoMaster

# Verificar build settings
xcodebuild -project GoMaster.xcodeproj -showBuildSettings | grep CODE_SIGN

# Intentar build (requiere cuenta configurada)
xcodebuild build \
  -project GoMaster.xcodeproj \
  -scheme GoMaster \
  -destination "platform=iOS,id=00008130-0002512C1883401C" \
  -allowProvisioningUpdates
```

## Siguiente paso: Build para App Store

Una vez que la app funcione en tu dispositivo, para subirla a la App Store necesitarás:

1. **Cuenta de Apple Developer** (99 USD/año)
2. **Certificado de distribución** (Distribution Certificate)
3. **App Store provisioning profile**

Usa el archivo [BUILD_FOR_APPSTORE.md](BUILD_FOR_APPSTORE.md) cuando estés listo.

---

## Resumen de cambios realizados

He realizado las siguientes correcciones en tu proyecto:

1. ✅ Creado Assets.xcassets con AppIcon y AccentColor
2. ✅ Reorganizado estructura de archivos (GoMaster/ subdirectory)
3. ✅ Actualizado project.pbxproj para incluir Assets
4. ✅ Simplificado entitlements (removido push notifications temporalmente)
5. ✅ Corregido rutas de Info.plist y entitlements

**El proyecto está listo para compilar**, solo necesitas agregar tu cuenta de Apple ID en Xcode Settings → Accounts.
