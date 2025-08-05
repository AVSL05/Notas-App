#!/bin/bash

echo "🔧 Script de configuración para Notas App"
echo "=========================================="

# Configurar Android
echo "📱 Configurando Android..."

# Verificar si ANDROID_HOME está configurado
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  Configurando ANDROID_HOME..."
    export ANDROID_HOME=~/Library/Android/sdk
    echo 'export ANDROID_HOME=~/Library/Android/sdk' >> ~/.zshrc
    echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc
    echo "✅ ANDROID_HOME configurado"
fi

# Verificar command-line tools
if [ ! -d "$ANDROID_HOME/cmdline-tools/latest" ]; then
    echo "📥 Descargando Android command-line tools..."
    cd $ANDROID_HOME/cmdline-tools
    
    # Si ya existe el zip, no lo descargues de nuevo
    if [ ! -f "commandlinetools-mac-11076708_latest.zip" ]; then
        curl -O https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip
    fi
    
    echo "📦 Extrayendo command-line tools..."
    unzip -q commandlinetools-mac-11076708_latest.zip
    mv cmdline-tools latest
    rm commandlinetools-mac-11076708_latest.zip
    echo "✅ Command-line tools instalados"
fi

# Aceptar licencias de Android
echo "📋 Aceptando licencias de Android..."
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

# Verificar CocoaPods
echo "🍎 Verificando CocoaPods..."
if ! command -v pod &> /dev/null; then
    echo "📥 Instalando CocoaPods..."
    sudo gem install cocoapods
    echo "✅ CocoaPods instalado"
else
    echo "✅ CocoaPods ya está instalado"
fi

# Configurar CocoaPods
echo "⚙️  Configurando CocoaPods..."
pod setup

echo ""
echo "🎉 ¡Configuración completada!"
echo "💡 Ejecuta 'source ~/.zshrc' para recargar las variables de entorno"
echo "🔍 Luego ejecuta 'flutter doctor' para verificar"
