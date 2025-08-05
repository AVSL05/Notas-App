# Notas App - Aplicación de Notas con Calendario

Una aplicación móvil completa de notas con integración de calendario, desarrollada en Flutter usando Clean Architecture y BLoC pattern.

## 🚀 Características Principales

- ✅ **Editor de texto enriquecido** - Formato de texto con negritas, cursivas, listas
- 📅 **Calendario integrado** - Organización visual con etiquetas de colores
- 🔔 **Notificaciones inteligentes** - Recordatorios programables con días de antelación
- ✏️ **Gestión de tareas** - Listas de tareas con checkboxes interactivos
- 🏷️ **Sistema de etiquetas** - Clasificación por colores y categorías
- 📱 **Widgets de pantalla principal** - Vista previa rápida de notas importantes
- 🌙 **Tema claro/oscuro** - Adaptable a las preferencias del usuario

## 🏗️ Arquitectura

### Clean Architecture con 3 capas:

```
lib/
├── core/                    # Servicios compartidos
│   ├── di/                 # Inyección de dependencias
│   ├── theme/              # Temas y estilos
│   ├── routes/             # Navegación
│   └── notifications/      # Servicio de notificaciones
├── features/               # Módulos de funcionalidad
│   ├── notes/              # Gestión de notas
│   │   ├── domain/         # Entidades y casos de uso
│   │   ├── data/           # Repositorios e implementaciones
│   │   └── presentation/   # UI y BLoC
│   ├── calendar/           # Módulo de calendario
│   ├── tasks/              # Gestión de tareas
│   └── notifications/      # Gestión de recordatorios
```

### Tecnologías Principales:

- **Flutter 3.24+** - Framework UI multiplataforma
- **BLoC** - Gestión de estado reactiva
- **Hive** - Base de datos local NoSQL
- **GetIt** - Inyección de dependencias
- **Go Router** - Navegación declarativa

## 🛠️ Configuración del Entorno

### Prerequisitos:

1. **Instalar Flutter SDK** (versión 3.13+):

   ```bash
   # macOS con Homebrew
   brew install --cask flutter

   # O descargar desde: https://flutter.dev/docs/get-started/install
   ```

2. **Configurar PATH** (agregar a ~/.zshrc):

   ```bash
   export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
   ```

3. **Verificar instalación**:
   ```bash
   flutter doctor
   ```

### Instalación del Proyecto:

```bash
# 1. Navegar al directorio del proyecto
cd "Notas App"

# 2. Instalar dependencias
flutter pub get

# 3. Generar código (adapters Hive, etc.)
flutter packages pub run build_runner build

# 4. Ejecutar en desarrollo
flutter run
```

## 🧪 Cómo Probar la Aplicación

### 1. **Simuladores/Emuladores:**

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d [device-id]

# Ejecutar en modo debug con hot reload
flutter run --debug
```

### 2. **Testing Automatizado:**

```bash
# Ejecutar todos los tests
flutter test

# Tests con coverage
flutter test --coverage

# Tests de integración
flutter test integration_test/
```

### 3. **Builds de Producción:**

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requiere macOS y Xcode)
flutter build ios --release
```

## 📱 Funcionalidades por Implementar

### Fase 1 - MVP (Mínimo Producto Viable):

- [ ] CRUD básico de notas
- [ ] Editor de texto simple
- [ ] Lista de notas con búsqueda
- [ ] Persistencia local con Hive

### Fase 2 - Características Avanzadas:

- [ ] Editor de texto enriquecido (flutter_quill)
- [ ] Sistema de tareas con checkboxes
- [ ] Integración con calendario (table_calendar)
- [ ] Notificaciones locales programadas

### Fase 3 - Características Premium:

- [ ] Etiquetas de colores y categorías
- [ ] Widgets de pantalla principal
- [ ] Sincronización en la nube
- [ ] Exportación a PDF/Markdown

## 🔧 Comandos de Desarrollo

```bash
# Hot reload durante desarrollo
r  # En el terminal de flutter run

# Hot restart
R  # En el terminal de flutter run

# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Limpar build cache
flutter clean && flutter pub get
```

## 📚 Estructura de Datos

### Note Entity:

```dart
class Note {
  final String id;
  final String title;
  final String content;
  final List<Task> tasks;
  final DateTime createdAt;
  final DateTime? reminderDate;
  final String colorTag;
  final bool isPinned;
}
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama de feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -m 'Add nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

---

**Desarrollado con ❤️ usando Flutter**
