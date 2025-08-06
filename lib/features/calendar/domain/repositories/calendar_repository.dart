import '../entities/calendar_event.dart';
import '../entities/date_note_association.dart';

/// Repositorio abstracto para operaciones del calendario
abstract class CalendarRepository {
  // ===== EVENTOS DEL CALENDARIO =====
  
  /// Obtiene todos los eventos del calendario
  Future<List<CalendarEvent>> getAllEvents();

  /// Obtiene eventos para una fecha específica
  Future<List<CalendarEvent>> getEventsForDate(DateTime date);

  /// Obtiene eventos en un rango de fechas
  Future<List<CalendarEvent>> getEventsInRange(DateTime startDate, DateTime endDate);

  /// Obtiene eventos por tipo
  Future<List<CalendarEvent>> getEventsByType(CalendarEventType type);

  /// Obtiene eventos por color tag
  Future<List<CalendarEvent>> getEventsByColorTag(String colorTag);

  /// Crea un nuevo evento
  Future<CalendarEvent> createEvent(CalendarEvent event);

  /// Actualiza un evento existente
  Future<CalendarEvent> updateEvent(CalendarEvent event);

  /// Elimina un evento
  Future<void> deleteEvent(String eventId);

  /// Elimina todos los eventos de una fecha
  Future<void> deleteEventsForDate(DateTime date);

  // ===== ASOCIACIONES FECHA-NOTA =====

  /// Obtiene todas las asociaciones fecha-nota
  Future<List<DateNoteAssociation>> getAllAssociations();

  /// Obtiene asociaciones para una fecha específica
  Future<List<DateNoteAssociation>> getAssociationsForDate(DateTime date);

  /// Obtiene asociaciones en un rango de fechas
  Future<List<DateNoteAssociation>> getAssociationsInRange(DateTime startDate, DateTime endDate);

  /// Obtiene asociaciones por nota
  Future<List<DateNoteAssociation>> getAssociationsForNote(String noteId);

  /// Obtiene asociaciones pendientes
  Future<List<DateNoteAssociation>> getPendingAssociations();

  /// Obtiene asociaciones completadas
  Future<List<DateNoteAssociation>> getCompletedAssociations();

  /// Obtiene asociaciones vencidas
  Future<List<DateNoteAssociation>> getOverdueAssociations();

  /// Obtiene asociaciones por prioridad
  Future<List<DateNoteAssociation>> getAssociationsByPriority(int priority);

  /// Crea una nueva asociación fecha-nota
  Future<DateNoteAssociation> createAssociation(DateNoteAssociation association);

  /// Actualiza una asociación existente
  Future<DateNoteAssociation> updateAssociation(DateNoteAssociation association);

  /// Marca una asociación como completada
  Future<DateNoteAssociation> markAssociationAsCompleted(String associationId);

  /// Marca una asociación como pendiente
  Future<DateNoteAssociation> markAssociationAsPending(String associationId);

  /// Elimina una asociación
  Future<void> deleteAssociation(String associationId);

  /// Elimina todas las asociaciones de una nota
  Future<void> deleteAssociationsForNote(String noteId);

  // ===== OPERACIONES COMBINADAS =====

  /// Obtiene todos los elementos del calendario para una fecha (eventos + asociaciones)
  Future<Map<String, dynamic>> getCalendarDataForDate(DateTime date);

  /// Obtiene datos del calendario para un mes completo
  Future<Map<String, dynamic>> getCalendarDataForMonth(int year, int month);

  /// Obtiene estadísticas del calendario
  Future<Map<String, dynamic>> getCalendarStatistics();

  /// Busca en eventos y asociaciones por texto
  Future<Map<String, dynamic>> searchCalendar(String query);

  // ===== CONFIGURACIÓN Y PREFERENCIAS =====

  /// Obtiene los colores de etiquetas disponibles
  Future<List<String>> getAvailableColorTags();

  /// Guarda un nuevo color de etiqueta
  Future<void> saveColorTag(String colorTag);

  /// Elimina un color de etiqueta
  Future<void> deleteColorTag(String colorTag);

  /// Obtiene la configuración del calendario
  Future<Map<String, dynamic>> getCalendarSettings();

  /// Guarda la configuración del calendario
  Future<void> saveCalendarSettings(Map<String, dynamic> settings);
}
