# 📋 Guía de Configuración del Entorno de Desarrollo

## 🚀 Configuración Automática

### 1. Ejecutar Script de Configuración

```bash
# Desde el directorio del proyecto
./setup.sh
```

### 2. Recargar Variables de Entorno

```bash
source ~/.zshrc
```

## 📱 Configuración Manual por Plataforma

### Android (Requerido)

✅ **Android Studio:** Ya instalado  
🔧 **Pendiente:** Command-line tools y licencias

**Pasos manuales si el script falla:**

```bash
# 1. Configurar variables de entorno
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# 2. Aceptar licencias
flutter doctor --android-licenses
```

### iOS (Opcional pero recomendado)

❌ **Xcode:** Requiere instalación completa

**Para desarrollo iOS:**

1. **Instalar Xcode desde App Store** (Gratis, ~15GB)

   - Abrir App Store
   - Buscar "Xcode"
   - Instalar (toma 30-60 minutos)

2. **Configurar Xcode:**

   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **CocoaPods** se instalará automáticamente con el script

## 🚦 Verificación Final

```bash
flutter doctor
```

## 📱 Opciones de Desarrollo

### Opción 1: Solo Android (Más rápido)

- ✅ Desarrollo más rápido
- ✅ Menos espacio en disco
- ❌ No puedes probar en iOS

### Opción 2: Android + iOS (Completo)

- ✅ Desarrollo completo
- ✅ Pruebas en ambas plataformas
- ❌ Requiere más tiempo y espacio

### Opción 3: Web (Inmediato)

- ✅ No requiere configuración adicional
- ✅ Desarrollo rápido
- ❌ Funcionalidad limitada (sin notificaciones nativas)

## 🎯 Recomendación

**Para empezar:** Configura solo Android y usa el navegador web para desarrollo rápido. Instala iOS más tarde si es necesario.

**Comando para ejecutar en web:**

```bash
flutter run -d chrome
```
