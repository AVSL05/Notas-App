import 'package:equatable/equatable.dart';

/// Entidad principal para representar una tarea
class Task extends Equatable {
  
  final String id;
  
  
  final String title;
  
  
  final String description;
  
  
  final bool isCompleted;
  
  
  final DateTime createdAt;
  
  
  final DateTime? dueDate;
  
  
  final DateTime? completedAt;
  
  
  final TaskPriority priority;
  
  
  final String? categoryId;
  
  
  final List<String> tags;
  
  
  final List<TaskStep> steps;
  
  
  final bool hasReminder;
  
  
  final DateTime? reminderTime;
  
  
  final TaskStatus status;
  
  
  final String? noteId; // Vinculación con notas
  
  
  final int? estimatedMinutes;
  
  
  final int? actualMinutes;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.priority,
    this.categoryId,
    required this.tags,
    required this.steps,
    required this.hasReminder,
    this.reminderTime,
    required this.status,
    this.noteId,
    this.estimatedMinutes,
    this.actualMinutes,
  });

  /// Crea una nueva tarea con valores por defecto
  factory Task.create({
    required String id,
    required String title,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    String? categoryId,
    List<String> tags = const [],
    DateTime? dueDate,
    bool hasReminder = false,
    DateTime? reminderTime,
    String? noteId,
    int? estimatedMinutes,
  }) {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      completedAt: null,
      priority: priority,
      categoryId: categoryId,
      tags: tags,
      steps: [],
      hasReminder: hasReminder,
      reminderTime: reminderTime,
      status: TaskStatus.pending,
      noteId: noteId,
      estimatedMinutes: estimatedMinutes,
      actualMinutes: null,
    );
  }

  /// Copia la tarea con cambios específicos
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    TaskPriority? priority,
    String? categoryId,
    List<String>? tags,
    List<TaskStep>? steps,
    bool? hasReminder,
    DateTime? reminderTime,
    TaskStatus? status,
    String? noteId,
    int? estimatedMinutes,
    int? actualMinutes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      steps: steps ?? this.steps,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      status: status ?? this.status,
      noteId: noteId ?? this.noteId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
    );
  }

  /// Marca la tarea como completada
  Task markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      status: TaskStatus.completed,
    );
  }

  /// Marca la tarea como pendiente
  Task markAsPending() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
      status: TaskStatus.pending,
    );
  }

  /// Calcula el progreso de la tarea basado en los pasos
  double get progress {
    if (steps.isEmpty) return isCompleted ? 1.0 : 0.0;
    
    final completedSteps = steps.where((step) => step.isCompleted).length;
    return completedSteps / steps.length;
  }

  /// Verifica si la tarea está vencida
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Verifica si la tarea vence hoy
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year && now.month == due.month && now.day == due.day;
  }

  /// Verifica si la tarea vence esta semana
  bool get isDueThisWeek {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return dueDate!.isBefore(weekFromNow) && dueDate!.isAfter(now);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        dueDate,
        completedAt,
        priority,
        categoryId,
        tags,
        steps,
        hasReminder,
        reminderTime,
        status,
        noteId,
        estimatedMinutes,
        actualMinutes,
      ];
}

/// Enumeración para las prioridades de tareas

enum TaskPriority {
  
  low,
  
  medium,
  
  high,
  
  critical;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.critical:
        return 'Crítica';
    }
  }

  String get icon {
    switch (this) {
      case TaskPriority.low:
        return 'keyboard_arrow_down';
      case TaskPriority.medium:
        return 'remove';
      case TaskPriority.high:
        return 'keyboard_arrow_up';
      case TaskPriority.critical:
        return 'priority_high';
    }
  }

  int get colorValue {
    switch (this) {
      case TaskPriority.low:
        return 0xFF4CAF50; // Verde
      case TaskPriority.medium:
        return 0xFFFF9800; // Naranja
      case TaskPriority.high:
        return 0xFFFF5722; // Rojo-naranja
      case TaskPriority.critical:
        return 0xFFF44336; // Rojo
    }
  }
}

/// Enumeración para los estados de tareas

enum TaskStatus {
  
  pending,
  
  inProgress,
  
  completed,
  
  cancelled,
  
  onHold;

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En progreso';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
      case TaskStatus.onHold:
        return 'En pausa';
    }
  }

  String get icon {
    switch (this) {
      case TaskStatus.pending:
        return 'schedule';
      case TaskStatus.inProgress:
        return 'play_arrow';
      case TaskStatus.completed:
        return 'check_circle';
      case TaskStatus.cancelled:
        return 'cancel';
      case TaskStatus.onHold:
        return 'pause_circle';
    }
  }
}

/// Entidad para representar pasos de una tarea

class TaskStep extends Equatable {
  
  final String id;
  
  
  final String title;
  
  
  final String description;
  
  
  final bool isCompleted;
  
  
  final DateTime createdAt;
  
  
  final DateTime? completedAt;
  
  
  final int order;

  const TaskStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    required this.order,
  });

  factory TaskStep.create({
    required String id,
    required String title,
    String description = '',
    required int order,
  }) {
    return TaskStep(
      id: id,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      completedAt: null,
      order: order,
    );
  }

  TaskStep copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    int? order,
  }) {
    return TaskStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      order: order ?? this.order,
    );
  }

  TaskStep markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  TaskStep markAsPending() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        completedAt,
        order,
      ];
}
