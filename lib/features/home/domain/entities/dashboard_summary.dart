import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'dashboard_summary.g.dart';

/// Niveles de productividad
@HiveType(typeId: 8)
enum ProductivityLevel {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,

  @HiveField(3)
  excellent;

  /// Nombre a mostrar del nivel de productividad
  String get displayName {
    if (this == ProductivityLevel.low) return 'Bajo';
    if (this == ProductivityLevel.medium) return 'Medio';
    if (this == ProductivityLevel.high) return 'Alto';
    if (this == ProductivityLevel.excellent) return 'Excelente';
    return 'Desconocido';
  }
}

/// Entidad que representa el resumen del dashboard
@HiveType(typeId: 5)
class DashboardSummary extends Equatable {
  @HiveField(0)
  final int totalNotes;

  @HiveField(1)
  final int totalTasks;

  @HiveField(2)
  final int completedTasks;

  @HiveField(3)
  final int totalReminders;

  @HiveField(4)
  final int overdueReminders;

  @HiveField(5)
  final ProductivityLevel productivityLevel;

  @HiveField(6)
  final double productivityScore;

  @HiveField(7)
  final List<QuickAction> quickActions;

  @HiveField(8)
  final List<RecentActivity> recentActivities;

  @HiveField(9)
  final DateTime lastUpdated;

  const DashboardSummary({
    required this.totalNotes,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalReminders,
    required this.overdueReminders,
    required this.productivityLevel,
    required this.productivityScore,
    required this.quickActions,
    required this.recentActivities,
    required this.lastUpdated,
  });

  /// Calcula el porcentaje de tareas completadas
  double get taskCompletionRate {
    if (totalTasks == 0) return 0.0;
    return (completedTasks / totalTasks) * 100;
  }

  /// Calcula el número de recordatorios activos
  int get activeReminders => totalReminders - overdueReminders;

  /// Crea una copia del resumen con valores modificados
  DashboardSummary copyWith({
    int? totalNotes,
    int? totalTasks,
    int? completedTasks,
    int? totalReminders,
    int? overdueReminders,
    ProductivityLevel? productivityLevel,
    double? productivityScore,
    List<QuickAction>? quickActions,
    List<RecentActivity>? recentActivities,
    DateTime? lastUpdated,
  }) {
    return DashboardSummary(
      totalNotes: totalNotes ?? this.totalNotes,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      totalReminders: totalReminders ?? this.totalReminders,
      overdueReminders: overdueReminders ?? this.overdueReminders,
      productivityLevel: productivityLevel ?? this.productivityLevel,
      productivityScore: productivityScore ?? this.productivityScore,
      quickActions: quickActions ?? this.quickActions,
      recentActivities: recentActivities ?? this.recentActivities,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        totalNotes,
        totalTasks,
        completedTasks,
        totalReminders,
        overdueReminders,
        productivityLevel,
        productivityScore,
        quickActions,
        recentActivities,
        lastUpdated,
      ];
}

/// Tipos de acciones rápidas disponibles en el dashboard
@HiveType(typeId: 6)
enum QuickActionType {
  @HiveField(0)
  newNote,

  @HiveField(1)
  newTask,

  @HiveField(2)
  newReminder,

  @HiveField(3)
  calendar,

  @HiveField(4)
  search,

  @HiveField(5)
  categories,

  @HiveField(6)
  settings,

  @HiveField(7)
  backup;

  /// Obtiene el icono para cada tipo de acción
  String get iconName {
    if (this == QuickActionType.newNote) return 'note_add';
    if (this == QuickActionType.newTask) return 'task_alt';
    if (this == QuickActionType.newReminder) return 'alarm_add';
    if (this == QuickActionType.calendar) return 'calendar_today';
    if (this == QuickActionType.search) return 'search';
    if (this == QuickActionType.categories) return 'category';
    if (this == QuickActionType.settings) return 'settings';
    if (this == QuickActionType.backup) return 'backup';
    return 'help_outline';
  }

  /// Obtiene la etiqueta para cada tipo de acción
  String get label {
    if (this == QuickActionType.newNote) return 'Nueva Nota';
    if (this == QuickActionType.newTask) return 'Nueva Tarea';
    if (this == QuickActionType.newReminder) return 'Nuevo Recordatorio';
    if (this == QuickActionType.calendar) return 'Calendario';
    if (this == QuickActionType.search) return 'Buscar';
    if (this == QuickActionType.categories) return 'Categorías';
    if (this == QuickActionType.settings) return 'Configuración';
    if (this == QuickActionType.backup) return 'Respaldo';
    return 'Desconocido';
  }

  /// Obtiene el color para cada tipo de acción
  int get colorValue {
    if (this == QuickActionType.newNote) return 0xFF2196F3;
    if (this == QuickActionType.newTask) return 0xFF4CAF50;
    if (this == QuickActionType.newReminder) return 0xFFF44336;
    if (this == QuickActionType.calendar) return 0xFF9C27B0;
    if (this == QuickActionType.search) return 0xFF607D8B;
    if (this == QuickActionType.categories) return 0xFFFF9800;
    if (this == QuickActionType.settings) return 0xFF795548;
    if (this == QuickActionType.backup) return 0xFF009688;
    return 0xFF9E9E9E;
  }
}

/// Entidad que representa una acción rápida en el dashboard
@HiveType(typeId: 7)
class QuickAction extends Equatable {
  /// Tipo de acción rápida
  @HiveField(0)
  final QuickActionType type;

  /// Si la acción está habilitada
  @HiveField(1)
  final bool isEnabled;

  /// Orden de la acción en el grid
  @HiveField(2)
  final int order;

  /// Fecha de última modificación
  @HiveField(3)
  final DateTime lastModified;

  const QuickAction({
    required this.type,
    this.isEnabled = true,
    required this.order,
    required this.lastModified,
  });

  /// Crea una copia de la acción rápida con valores modificados
  QuickAction copyWith({
    QuickActionType? type,
    bool? isEnabled,
    int? order,
    DateTime? lastModified,
  }) {
    return QuickAction(
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      order: order ?? this.order,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  List<Object?> get props => [type, isEnabled, order, lastModified];
}

/// Tipos de actividades recientes
@HiveType(typeId: 9)
enum ActivityType {
  @HiveField(0)
  noteCreated,

  @HiveField(1)
  noteUpdated,

  @HiveField(2)
  noteDeleted,

  @HiveField(3)
  taskCreated,

  @HiveField(4)
  taskCompleted,

  @HiveField(5)
  taskDeleted,

  @HiveField(6)
  reminderCreated,

  @HiveField(7)
  reminderTriggered,

  @HiveField(8)
  reminderDeleted;

  /// Obtiene el icono para cada tipo de actividad
  String get iconName {
    if (this == ActivityType.noteCreated) return 'note_add';
    if (this == ActivityType.noteUpdated) return 'edit_note';
    if (this == ActivityType.noteDeleted) return 'delete';
    if (this == ActivityType.taskCreated) return 'add_task';
    if (this == ActivityType.taskCompleted) return 'task_alt';
    if (this == ActivityType.taskDeleted) return 'delete';
    if (this == ActivityType.reminderCreated) return 'alarm_add';
    if (this == ActivityType.reminderTriggered) return 'alarm';
    if (this == ActivityType.reminderDeleted) return 'alarm_off';
    return 'info';
  }

  /// Obtiene la descripción para cada tipo de actividad
  String get description {
    if (this == ActivityType.noteCreated) return 'Nota creada';
    if (this == ActivityType.noteUpdated) return 'Nota actualizada';
    if (this == ActivityType.noteDeleted) return 'Nota eliminada';
    if (this == ActivityType.taskCreated) return 'Tarea creada';
    if (this == ActivityType.taskCompleted) return 'Tarea completada';
    if (this == ActivityType.taskDeleted) return 'Tarea eliminada';
    if (this == ActivityType.reminderCreated) return 'Recordatorio creado';
    if (this == ActivityType.reminderTriggered) return 'Recordatorio activado';
    if (this == ActivityType.reminderDeleted) return 'Recordatorio eliminado';
    return 'Actividad desconocida';
  }
}

/// Entidad que representa una actividad reciente
@HiveType(typeId: 10)
class RecentActivity extends Equatable {
  /// Identificador único de la actividad
  @HiveField(0)
  final String id;

  /// Tipo de actividad
  @HiveField(1)
  final ActivityType type;

  /// Título del elemento afectado
  @HiveField(2)
  final String title;

  /// Descripción adicional de la actividad
  @HiveField(3)
  final String? description;

  /// Fecha y hora de la actividad
  @HiveField(4)
  final DateTime timestamp;

  /// ID del elemento relacionado (nota, tarea, recordatorio)
  @HiveField(5)
  final String? relatedId;

  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.timestamp,
    this.relatedId,
  });

  /// Crea una copia de la actividad con valores modificados
  RecentActivity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    DateTime? timestamp,
    String? relatedId,
  }) {
    return RecentActivity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      relatedId: relatedId ?? this.relatedId,
    );
  }

  @override
  List<Object?> get props => [id, type, title, description, timestamp, relatedId];
}
