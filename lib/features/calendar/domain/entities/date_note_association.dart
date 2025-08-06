import 'package:equatable/equatable.dart';

/// Entidad que representa la asociación entre una fecha y una nota
class DateNoteAssociation extends Equatable {
  final String id;
  final String noteId;
  final DateTime date;
  final String colorTag;
  final int priority; // 1 = alta, 2 = media, 3 = baja
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const DateNoteAssociation({
    required this.id,
    required this.noteId,
    required this.date,
    required this.colorTag,
    this.priority = 2,
    this.isCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Crea una copia de la asociación con campos modificados
  DateNoteAssociation copyWith({
    String? id,
    String? noteId,
    DateTime? date,
    String? colorTag,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DateNoteAssociation(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      date: date ?? this.date,
      colorTag: colorTag ?? this.colorTag,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Verifica si la asociación está en la fecha especificada
  bool isOnDate(DateTime targetDate) {
    return date.year == targetDate.year &&
           date.month == targetDate.month &&
           date.day == targetDate.day;
  }

  /// Obtiene el nivel de prioridad como texto
  String get priorityText {
    switch (priority) {
      case 1:
        return 'Alta';
      case 2:
        return 'Media';
      case 3:
        return 'Baja';
      default:
        return 'Media';
    }
  }

  /// Obtiene el color según la prioridad
  String get priorityColor {
    switch (priority) {
      case 1:
        return '#F44336'; // Rojo
      case 2:
        return '#FF9800'; // Naranja
      case 3:
        return '#4CAF50'; // Verde
      default:
        return '#FF9800'; // Naranja por defecto
    }
  }

  /// Obtiene el ícono según la prioridad
  String get priorityIcon {
    switch (priority) {
      case 1:
        return '🔴'; // Alta prioridad
      case 2:
        return '🟡'; // Media prioridad
      case 3:
        return '🟢'; // Baja prioridad
      default:
        return '🟡'; // Por defecto
    }
  }

  /// Verifica si la asociación está vencida
  bool get isOverdue {
    if (isCompleted) return false;
    return DateTime.now().isAfter(date);
  }

  /// Verifica si la asociación es para hoy
  bool get isDueToday {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  /// Verifica si la asociación es para mañana
  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
           date.month == tomorrow.month &&
           date.day == tomorrow.day;
  }

  /// Obtiene los días restantes hasta la fecha
  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    return dueDate.difference(today).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        noteId,
        date,
        colorTag,
        priority,
        isCompleted,
        createdAt,
        updatedAt,
      ];
}

/// Clase que agrupa las asociaciones por fecha
class DateNoteGroup extends Equatable {
  final DateTime date;
  final List<DateNoteAssociation> associations;

  const DateNoteGroup({
    required this.date,
    required this.associations,
  });

  /// Obtiene las asociaciones completadas
  List<DateNoteAssociation> get completed =>
      associations.where((a) => a.isCompleted).toList();

  /// Obtiene las asociaciones pendientes
  List<DateNoteAssociation> get pending =>
      associations.where((a) => !a.isCompleted).toList();

  /// Obtiene las asociaciones por prioridad
  List<DateNoteAssociation> get highPriority =>
      associations.where((a) => a.priority == 1).toList();

  List<DateNoteAssociation> get mediumPriority =>
      associations.where((a) => a.priority == 2).toList();

  List<DateNoteAssociation> get lowPriority =>
      associations.where((a) => a.priority == 3).toList();

  /// Verifica si hay asociaciones vencidas
  bool get hasOverdue => associations.any((a) => a.isOverdue);

  /// Obtiene el número total de asociaciones
  int get totalCount => associations.length;

  /// Obtiene el número de asociaciones completadas
  int get completedCount => completed.length;

  /// Obtiene el número de asociaciones pendientes
  int get pendingCount => pending.length;

  /// Obtiene el porcentaje de completitud
  double get completionPercentage {
    if (totalCount == 0) return 0.0;
    return (completedCount / totalCount) * 100;
  }

  @override
  List<Object?> get props => [date, associations];
}
