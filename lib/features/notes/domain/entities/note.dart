import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String content; // Contenido en formato Delta JSON de Quill
  
  @HiveField(3)
  final List<Task> tasks;
  
  @HiveField(4)
  final List<String> tags;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final DateTime updatedAt;
  
  @HiveField(7)
  final DateTime? reminderDate;
  
  @HiveField(8)
  final bool isPinned;
  
  @HiveField(9)
  final String colorTag;

  @HiveField(10)
  final bool isArchived;

  @HiveField(11)
  final bool isFavorite;

  @HiveField(12)
  final String? category;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.tasks = const [],
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.reminderDate,
    this.isPinned = false,
    this.colorTag = 'default',
    this.isArchived = false,
    this.isFavorite = false,
    this.category,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    List<Task>? tasks,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderDate,
    bool? isPinned,
    String? colorTag,
    bool? isArchived,
    bool? isFavorite,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tasks: tasks ?? this.tasks,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderDate: reminderDate ?? this.reminderDate,
      isPinned: isPinned ?? this.isPinned,
      colorTag: colorTag ?? this.colorTag,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }

  /// Verifica si la nota tiene recordatorio activo
  bool get hasActiveReminder {
    return reminderDate != null && reminderDate!.isAfter(DateTime.now());
  }

  /// Verifica si la nota tiene tareas
  bool get hasTasks {
    return tasks.isNotEmpty;
  }

  /// Obtiene el número de tareas completadas
  int get completedTasksCount {
    return tasks.where((task) => task.isCompleted).length;
  }

  /// Obtiene el número de tareas pendientes
  int get pendingTasksCount {
    return tasks.where((task) => !task.isCompleted).length;
  }

  /// Calcula el porcentaje de progreso de las tareas
  double get taskProgress {
    if (tasks.isEmpty) return 0.0;
    return completedTasksCount / tasks.length;
  }

  /// Verifica si todas las tareas están completadas
  bool get allTasksCompleted {
    return tasks.isNotEmpty && tasks.every((task) => task.isCompleted);
  }

  /// Obtiene la fecha de la última modificación (actualización o creación)
  DateTime get lastModified {
    return updatedAt;
  }

  /// Verifica si la nota contiene el texto de búsqueda
  bool containsSearchText(String searchText) {
    final searchLower = searchText.toLowerCase();
    return title.toLowerCase().contains(searchLower) ||
           content.toLowerCase().contains(searchLower) ||
           tags.any((tag) => tag.toLowerCase().contains(searchLower)) ||
           tasks.any((task) => task.title.toLowerCase().contains(searchLower));
  }

  /// Obtiene un preview del contenido (primeras palabras)
  String get contentPreview {
    if (content.isEmpty) return 'Sin contenido';
    final words = content.split(' ');
    if (words.length <= 20) return content;
    return '${words.take(20).join(' ')}...';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        tasks,
        tags,
        createdAt,
        updatedAt,
        reminderDate,
        isPinned,
        colorTag,
        isArchived,
        isFavorite,
        category,
      ];
}

@HiveType(typeId: 1)
class Task extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final bool isCompleted;
  
  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final DateTime? completedAt;

  @HiveField(6)
  final DateTime? dueDate;

  @HiveField(7)
  final TaskPriority priority;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.description,
    this.completedAt,
    this.dueDate,
    this.priority = TaskPriority.medium,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? description,
    DateTime? completedAt,
    DateTime? dueDate,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  /// Marca la tarea como completada
  Task markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  /// Marca la tarea como pendiente
  Task markAsPending() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  /// Verifica si la tarea está vencida
  bool get isOverdue {
    return dueDate != null && 
           dueDate!.isBefore(DateTime.now()) && 
           !isCompleted;
  }

  /// Verifica si la tarea vence hoy
  bool get isDueToday {
    if (dueDate == null) return false;
    final today = DateTime.now();
    return dueDate!.year == today.year &&
           dueDate!.month == today.month &&
           dueDate!.day == today.day;
  }

  @override
  List<Object?> get props => [
        id, 
        title, 
        isCompleted, 
        createdAt, 
        description, 
        completedAt, 
        dueDate, 
        priority
      ];
}

/// Prioridades de las tareas
@HiveType(typeId: 4)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}

/// Extensión para obtener información adicional de la prioridad
extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }

  String get colorHex {
    switch (this) {
      case TaskPriority.low:
        return '#4CAF50';      // Verde
      case TaskPriority.medium:
        return '#FF9800';      // Naranja
      case TaskPriority.high:
        return '#F44336';      // Rojo
      case TaskPriority.urgent:
        return '#9C27B0';      // Púrpura
    }
  }

  int get value {
    switch (this) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
      case TaskPriority.urgent:
        return 4;
    }
  }
}
