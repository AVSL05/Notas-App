import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entidad que representa un evento en el calendario
class CalendarEvent extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String colorTag;
  final String? noteId; // Asociación con una nota
  final bool isAllDay;
  final CalendarEventType type;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.startTime,
    this.endTime,
    required this.colorTag,
    this.noteId,
    this.isAllDay = false,
    required this.type,
    required this.createdAt,
    this.updatedAt,
  });

  /// Crea una copia del evento con campos modificados
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? colorTag,
    String? noteId,
    bool? isAllDay,
    CalendarEventType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      colorTag: colorTag ?? this.colorTag,
      noteId: noteId ?? this.noteId,
      isAllDay: isAllDay ?? this.isAllDay,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Verifica si el evento está en la fecha especificada
  bool isOnDate(DateTime targetDate) {
    return date.year == targetDate.year &&
           date.month == targetDate.month &&
           date.day == targetDate.day;
  }

  /// Obtiene la duración del evento
  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }

  /// Verifica si el evento está en conflicto con otro evento
  bool conflictsWith(CalendarEvent other) {
    if (!isOnDate(other.date)) return false;
    if (isAllDay || other.isAllDay) return true;
    
    if (startTime != null && endTime != null && 
        other.startTime != null && other.endTime != null) {
      return startTime!.isBefore(other.endTime!) && 
             endTime!.isAfter(other.startTime!);
    }
    
    return false;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        startTime,
        endTime,
        colorTag,
        noteId,
        isAllDay,
        type,
        createdAt,
        updatedAt,
      ];
}

/// Tipos de eventos en el calendario
enum CalendarEventType {
  note,        // Evento asociado a una nota
  reminder,    // Recordatorio simple
  task,        // Tarea con fecha de vencimiento
  meeting,     // Reunión o cita
  personal,    // Evento personal
  work,        // Evento relacionado con trabajo
  birthday,    // Cumpleaños
  holiday,     // Día festivo
}

/// Extensión para obtener información adicional del tipo de evento
extension CalendarEventTypeExtension on CalendarEventType {
  String get displayName {
    switch (this) {
      case CalendarEventType.note:
        return 'Nota';
      case CalendarEventType.reminder:
        return 'Recordatorio';
      case CalendarEventType.task:
        return 'Tarea';
      case CalendarEventType.meeting:
        return 'Reunión';
      case CalendarEventType.personal:
        return 'Personal';
      case CalendarEventType.work:
        return 'Trabajo';
      case CalendarEventType.birthday:
        return 'Cumpleaños';
      case CalendarEventType.holiday:
        return 'Día Festivo';
    }
  }

  IconData get iconData {
    switch (this) {
      case CalendarEventType.note:
        return Icons.note;
      case CalendarEventType.reminder:
        return Icons.notifications;
      case CalendarEventType.task:
        return Icons.task_alt;
      case CalendarEventType.meeting:
        return Icons.people;
      case CalendarEventType.personal:
        return Icons.person;
      case CalendarEventType.work:
        return Icons.work;
      case CalendarEventType.birthday:
        return Icons.cake;
      case CalendarEventType.holiday:
        return Icons.celebration;
    }
  }

  String get icon {
    switch (this) {
      case CalendarEventType.note:
        return '📝';
      case CalendarEventType.reminder:
        return '⏰';
      case CalendarEventType.task:
        return '✅';
      case CalendarEventType.meeting:
        return '🤝';
      case CalendarEventType.personal:
        return '👤';
      case CalendarEventType.work:
        return '💼';
      case CalendarEventType.birthday:
        return '🎂';
      case CalendarEventType.holiday:
        return '🎉';
    }
  }

  String get defaultColor {
    switch (this) {
      case CalendarEventType.note:
        return '#2196F3';      // Azul
      case CalendarEventType.reminder:
        return '#FF9800';      // Naranja
      case CalendarEventType.task:
        return '#4CAF50';      // Verde
      case CalendarEventType.meeting:
        return '#9C27B0';      // Púrpura
      case CalendarEventType.personal:
        return '#E91E63';      // Rosa
      case CalendarEventType.work:
        return '#607D8B';      // Azul gris
      case CalendarEventType.birthday:
        return '#FFEB3B';      // Amarillo
      case CalendarEventType.holiday:
        return '#F44336';      // Rojo
    }
  }
}
