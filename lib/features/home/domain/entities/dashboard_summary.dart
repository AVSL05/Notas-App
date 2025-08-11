import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'dashboard_summary.g.dart';

/// Niveles de productividad
@HiveType(typeId: 8)
enum ProductivityLevel {
  @HiveField(0)
  minimal,

  @HiveField(1)
  low,

  @HiveField(2)
  medium,

  @HiveField(3)
  high,

    @HiveField(4)
  excellent;

  String get displayName {
    switch (this) {
      case ProductivityLevel.minimal:
        return 'Minimal';
      case ProductivityLevel.low:
        return 'Bajo';
      case ProductivityLevel.medium:
        return 'Medio';
      case ProductivityLevel.high:
        return 'Alto';
      case ProductivityLevel.excellent:
        return 'Excelente';
    }
  }

  String get colorHex {
    switch (this) {
      case ProductivityLevel.minimal:
        return '#F44336'; // Rojo
      case ProductivityLevel.low:
        return '#FF9800'; // Naranja
      case ProductivityLevel.medium:
        return '#FFC107'; // Amarillo
      case ProductivityLevel.high:
        return '#4CAF50'; // Verde
      case ProductivityLevel.excellent:
        return '#2196F3'; // Azul
    }
  }

  String get description {
    switch (this) {
      case ProductivityLevel.minimal:
        return 'Necesitas motivación para empezar';
      case ProductivityLevel.low:
        return 'Hay espacio para mejorar';
      case ProductivityLevel.medium:
        return 'Progreso sólido y constante';
      case ProductivityLevel.high:
        return 'Excelente rendimiento';
      case ProductivityLevel.excellent:
        return 'Productividad excepcional';
    }
  }

  double get value {
    switch (this) {
      case ProductivityLevel.minimal:
        return 0.1;
      case ProductivityLevel.low:
        return 0.3;
      case ProductivityLevel.medium:
        return 0.5;
      case ProductivityLevel.high:
        return 0.7;
      case ProductivityLevel.excellent:
        return 0.9;
    }
  }
}/// Entidad que representa el resumen del dashboard
@HiveType(typeId: 5)
class DashboardSummary extends Equatable {
  @HiveField(0)
  final int totalNotes;

  @HiveField(1)
  final int completedTasks;

  @HiveField(2)
  final int totalCategories;

  @HiveField(3)
  final double productivityScore;

  @HiveField(4)
  final List<QuickAction> quickActions;

  @HiveField(5)
  final List<RecentActivity> recentActivities;

  @HiveField(6)
  final DateTime lastUpdated;

  const DashboardSummary({
    required this.totalNotes,
    required this.completedTasks,
    required this.totalCategories,
    required this.productivityScore,
    required this.quickActions,
    required this.recentActivities,
    required this.lastUpdated,
  });

  static final empty = DashboardSummary(
    totalNotes: 0,
    completedTasks: 0,
    totalCategories: 0,
    productivityScore: 0.0,
    quickActions: const [],
    recentActivities: const [],
    lastUpdated: DateTime.fromMillisecondsSinceEpoch(0),
  );

  /// Crea una copia con valores modificados
  DashboardSummary copyWith({
    int? totalNotes,
    int? completedTasks,
    int? totalCategories,
    double? productivityScore,
    List<QuickAction>? quickActions,
    List<RecentActivity>? recentActivities,
    DateTime? lastUpdated,
  }) {
    return DashboardSummary(
      totalNotes: totalNotes ?? this.totalNotes,
      completedTasks: completedTasks ?? this.completedTasks,
      totalCategories: totalCategories ?? this.totalCategories,
      productivityScore: productivityScore ?? this.productivityScore,
      quickActions: quickActions ?? this.quickActions,
      recentActivities: recentActivities ?? this.recentActivities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        totalNotes,
        completedTasks,
        totalCategories,
        productivityScore,
        quickActions,
        recentActivities,
        lastUpdated,
      ];

  ProductivityLevel get productivityLevel {
    if (productivityScore >= 0.9) return ProductivityLevel.excellent;
    if (productivityScore >= 0.7) return ProductivityLevel.high;
    if (productivityScore >= 0.4) return ProductivityLevel.medium;
    if (productivityScore > 0) return ProductivityLevel.low;
    return ProductivityLevel.minimal;
  }

  double get completionPercentage => productivityScore * 100;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  String get motivationalMessage {
    switch (productivityLevel) {
      case ProductivityLevel.excellent:
        return '¡Estás imparable! Sigue así.';
      case ProductivityLevel.high:
        return 'Gran progreso. ¡Estás en racha!';
      case ProductivityLevel.medium:
        return 'Vas por buen camino. ¡Sigue adelante!';
      case ProductivityLevel.low:
        return 'Un pequeño paso cada día hace la diferencia.';
      case ProductivityLevel.minimal:
      default:
        return '¿Listo para empezar un día productivo?';
    }
  }

  bool get hasData => totalNotes > 0 || completedTasks > 0;

  // Propiedades adicionales para métricas detalladas
  int get totalTasks => completedTasks > 0 ? (completedTasks / 0.7).round() : 0; // Asume 70% completadas
  int get pendingTasks => totalTasks - completedTasks;
  int get favoriteNotes => (totalNotes * 0.15).round(); // Estimación
  int get pinnedNotes => (totalNotes * 0.1).round(); // Estimación
  int get archivedNotes => (totalNotes * 0.05).round(); // Estimación
  int get upcomingReminders => 5; // Placeholder - se debe implementar lógica real
  int get todayEvents => 3; // Placeholder - se debe implementar lógica real
}

/// Entidad para acciones rápidas en el dashboard
@HiveType(typeId: 7)
class QuickAction extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconData;

  @HiveField(4)
  final String route;

  @HiveField(5)
  final bool isEnabled;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final int? sortOrder;

  const QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.route,
    required this.isEnabled,
    required this.createdAt,
    this.sortOrder,
  });

  QuickAction copyWith({
    String? id,
    String? title,
    String? description,
    String? iconData,
    String? route,
    bool? isEnabled,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return QuickAction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconData: iconData ?? this.iconData,
      route: route ?? this.route,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  static List<QuickAction> getDefaultActions() {
    return [
      QuickAction(
        id: 'create_note',
        title: 'Create Note',
        description: 'Create a new note',
        iconData: '0xe145',
        route: '/notes/create',
        sortOrder: 1,
        isEnabled: true,
        createdAt: DateTime.now(),
      ),
      QuickAction(
        id: 'create_task',
        title: 'Create Task',
        description: 'Create a new task',
        iconData: '0xe876',
        route: '/tasks/create',
        sortOrder: 2,
        isEnabled: true,
        createdAt: DateTime.now(),
      ),
      QuickAction(
        id: 'view_calendar',
        title: 'Calendar',
        description: 'View calendar',
        iconData: '0xe878',
        route: '/calendar',
        sortOrder: 3,
        isEnabled: true,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconData,
        route,
        isEnabled,
        createdAt,
        sortOrder,
      ];

  /// Obtiene el código del icono (alias para iconData)
  String get iconCodePoint => iconData;

  /// Obtiene el color asociado a la acción
  String get colorHex {
    switch (id) {
      case 'create_note':
        return '#4CAF50';
      case 'create_task':
        return '#2196F3';
      case 'view_calendar':
        return '#FF9800';
      case 'search_notes':
        return '#9C27B0';
      case 'view_favorites':
        return '#E91E63';
      case 'view_archived':
        return '#607D8B';
      case 'settings':
        return '#795548';
      case 'backup':
        return '#FF5722';
      default:
        return '#6200EE';
    }
  }

  /// Obtiene el tipo de acción basado en el id
  QuickActionType get type {
    switch (id) {
      case 'create_note':
        return QuickActionType.createNote;
      case 'create_task':
        return QuickActionType.createTaskList;
      case 'view_calendar':
        return QuickActionType.viewCalendar;
      case 'search_notes':
        return QuickActionType.searchNotes;
      case 'view_favorites':
        return QuickActionType.viewFavorites;
      case 'view_archived':
        return QuickActionType.viewArchived;
      case 'settings':
        return QuickActionType.settings;
      case 'backup':
        return QuickActionType.backup;
      default:
        return QuickActionType.createNote;
    }
  }
}

/// Entidad para actividades recientes
@HiveType(typeId: 9)
class RecentActivity extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ActivityType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String entityId;

  @HiveField(6)
  final Map<String, dynamic> metadata;

  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.entityId,
    required this.metadata,
  });

  RecentActivity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    DateTime? timestamp,
    String? entityId,
    Map<String, dynamic>? metadata,
  }) {
    return RecentActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      entityId: entityId ?? this.entityId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        timestamp,
        entityId,
        metadata,
      ];

  /// Obtiene un string con el tiempo transcurrido desde la actividad
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return 'Hace ${(difference.inDays / 7).floor()}sem';
    }
  }

  /// Verifica si la actividad fue hoy
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
           timestamp.month == now.month &&
           timestamp.day == now.day;
  }

  /// Obtiene el ID del elemento relacionado (alias para entityId)
  String? get relatedItemId => entityId.isNotEmpty ? entityId : null;
}

/// Tipos de actividades que pueden registrarse
@HiveType(typeId: 10)
enum ActivityType {
  @HiveField(0)
  noteCreated,
  @HiveField(1)
  taskCompleted,
  @HiveField(2)
  categoryCreated,
  @HiveField(3)
  searchPerformed,
  @HiveField(4)
  noteUpdated,
  @HiveField(5)
  taskCreated,
  @HiveField(6)
  reminderSet,
  @HiveField(7)
  notePinned,
}

/// Extensión para ActivityType
extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.noteCreated:
        return 'Nota creada';
      case ActivityType.taskCompleted:
        return 'Tarea completada';
      case ActivityType.categoryCreated:
        return 'Categoría creada';
      case ActivityType.searchPerformed:
        return 'Búsqueda realizada';
      case ActivityType.noteUpdated:
        return 'Nota actualizada';
      case ActivityType.taskCreated:
        return 'Tarea creada';
      case ActivityType.reminderSet:
        return 'Recordatorio establecido';
      case ActivityType.notePinned:
        return 'Nota fijada';
    }
  }

  String get iconCodePoint {
    switch (this) {
      case ActivityType.noteCreated:
        return '0xe30e'; // Icons.note_add
      case ActivityType.taskCompleted:
        return '0xe86c'; // Icons.task_alt
      case ActivityType.categoryCreated:
        return '0xe2bc'; // Icons.category
      case ActivityType.searchPerformed:
        return '0xe8b6'; // Icons.search
      case ActivityType.noteUpdated:
        return '0xe3c9'; // Icons.edit_note
      case ActivityType.taskCreated:
        return '0xe145'; // Icons.add_task
      case ActivityType.reminderSet:
        return '0xe8ad'; // Icons.schedule
      case ActivityType.notePinned:
        return '0xe8c4'; // Icons.push_pin
    }
  }

  String get colorHex {
    switch (this) {
      case ActivityType.noteCreated:
        return '#4CAF50'; // Verde
      case ActivityType.taskCompleted:
        return '#2196F3'; // Azul
      case ActivityType.categoryCreated:
        return '#FF9800'; // Naranja
      case ActivityType.searchPerformed:
        return '#9C27B0'; // Púrpura
      case ActivityType.noteUpdated:
        return '#607D8B'; // Gris azulado
      case ActivityType.taskCreated:
        return '#00BCD4'; // Cian
      case ActivityType.reminderSet:
        return '#FF5722'; // Rojo-naranja
      case ActivityType.notePinned:
        return '#795548'; // Marrón
    }
  }
}

/// Tipos de acciones rápidas
@HiveType(typeId: 11)
enum QuickActionType {
  @HiveField(0)
  createNote,
  @HiveField(1)
  createTaskList,
  @HiveField(2)
  viewCalendar,
  @HiveField(3)
  searchNotes,
  @HiveField(4)
  viewArchived,
  @HiveField(5)
  viewFavorites,
  @HiveField(6)
  viewReminders,
  @HiveField(7)
  settings,
  @HiveField(8)
  backup,
}
