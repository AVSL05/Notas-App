import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

/// Caso de uso para crear eventos en el calendario
class CreateCalendarEvent {
  final CalendarRepository repository;

  const CreateCalendarEvent(this.repository);

  /// Ejecuta el caso de uso
  Future<CalendarEvent> call(CalendarEvent event) async {
    try {
      // Validar el evento antes de crearlo
      _validateEvent(event);
      
      // Verificar conflictos si es necesario
      if (!event.isAllDay && event.startTime != null && event.endTime != null) {
        await _checkForConflicts(event);
      }
      
      return await repository.createEvent(event);
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  /// Crea un evento rápido con información mínima
  Future<CalendarEvent> createQuickEvent({
    required String title,
    required DateTime date,
    String? description,
    CalendarEventType type = CalendarEventType.note,
    String? colorTag,
    bool isAllDay = true,
  }) async {
    final event = CalendarEvent(
      id: _generateId(),
      title: title,
      description: description,
      date: date,
      colorTag: colorTag ?? type.defaultColor,
      isAllDay: isAllDay,
      type: type,
      createdAt: DateTime.now(),
    );

    return call(event);
  }

  /// Crea un evento con horario específico
  Future<CalendarEvent> createTimedEvent({
    required String title,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    CalendarEventType type = CalendarEventType.meeting,
    String? colorTag,
    String? noteId,
  }) async {
    final event = CalendarEvent(
      id: _generateId(),
      title: title,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      colorTag: colorTag ?? type.defaultColor,
      noteId: noteId,
      isAllDay: false,
      type: type,
      createdAt: DateTime.now(),
    );

    return call(event);
  }

  /// Crea un evento asociado a una nota
  Future<CalendarEvent> createNoteEvent({
    required String title,
    required DateTime date,
    required String noteId,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? colorTag,
    bool isAllDay = true,
  }) async {
    final event = CalendarEvent(
      id: _generateId(),
      title: title,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      colorTag: colorTag ?? CalendarEventType.note.defaultColor,
      noteId: noteId,
      isAllDay: isAllDay,
      type: CalendarEventType.note,
      createdAt: DateTime.now(),
    );

    return call(event);
  }

  /// Crea un recordatorio
  Future<CalendarEvent> createReminder({
    required String title,
    required DateTime date,
    required DateTime reminderTime,
    String? description,
    String? colorTag,
  }) async {
    final event = CalendarEvent(
      id: _generateId(),
      title: title,
      description: description,
      date: date,
      startTime: reminderTime,
      colorTag: colorTag ?? CalendarEventType.reminder.defaultColor,
      isAllDay: false,
      type: CalendarEventType.reminder,
      createdAt: DateTime.now(),
    );

    return call(event);
  }

  /// Crea múltiples eventos (por ejemplo, eventos recurrentes)
  Future<List<CalendarEvent>> createMultipleEvents(List<CalendarEvent> events) async {
    final List<CalendarEvent> createdEvents = [];
    
    for (final event in events) {
      try {
        final createdEvent = await call(event);
        createdEvents.add(createdEvent);
      } catch (e) {
        // Log error but continue with other events
        print('Error creating event ${event.title}: $e');
      }
    }
    
    return createdEvents;
  }

  /// Crea eventos recurrentes semanales
  Future<List<CalendarEvent>> createWeeklyRecurring({
    required String title,
    required DateTime startDate,
    required int weeks,
    String? description,
    CalendarEventType type = CalendarEventType.reminder,
    String? colorTag,
    DateTime? startTime,
    DateTime? endTime,
    bool isAllDay = true,
  }) async {
    final List<CalendarEvent> events = [];
    
    for (int i = 0; i < weeks; i++) {
      final eventDate = startDate.add(Duration(days: i * 7));
      final event = CalendarEvent(
        id: _generateId(),
        title: title,
        description: description,
        date: eventDate,
        startTime: startTime,
        endTime: endTime,
        colorTag: colorTag ?? type.defaultColor,
        isAllDay: isAllDay,
        type: type,
        createdAt: DateTime.now(),
      );
      events.add(event);
    }
    
    return createMultipleEvents(events);
  }

  /// Validaciones del evento
  void _validateEvent(CalendarEvent event) {
    if (event.title.trim().isEmpty) {
      throw Exception('El título del evento no puede estar vacío');
    }

    if (!event.isAllDay) {
      if (event.startTime != null && event.endTime != null) {
        if (event.endTime!.isBefore(event.startTime!)) {
          throw Exception('La hora de fin no puede ser anterior a la hora de inicio');
        }
        
        if (event.endTime!.isAtSameMomentAs(event.startTime!)) {
          throw Exception('La hora de fin debe ser diferente a la hora de inicio');
        }
      }
    }

    // Validar que la fecha no sea muy antigua
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    if (event.date.isBefore(oneYearAgo)) {
      throw Exception('La fecha del evento no puede ser anterior a un año');
    }
  }

  /// Verifica conflictos con otros eventos
  Future<void> _checkForConflicts(CalendarEvent event) async {
    final existingEvents = await repository.getEventsForDate(event.date);
    
    for (final existing in existingEvents) {
      if (existing.id != event.id && event.conflictsWith(existing)) {
        throw Exception('El evento tiene conflicto de horario con: ${existing.title}');
      }
    }
  }

  /// Genera un ID único para el evento
  String _generateId() {
    return 'event_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
  }

  /// Genera una cadena aleatoria
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().microsecond;
    return List.generate(length, (index) => chars[random % chars.length]).join();
  }
}
