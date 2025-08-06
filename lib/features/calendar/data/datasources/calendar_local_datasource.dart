import 'package:hive/hive.dart';
import '../models/calendar_event_model.dart';
import '../models/date_note_association_model.dart';

/// Fuente de datos local para el calendario usando Hive
class CalendarLocalDatasource {
  static const String _eventsBoxName = 'calendar_events';
  static const String _associationsBoxName = 'date_note_associations';
  static const String _settingsBoxName = 'calendar_settings';

  late Box<CalendarEventModel> _eventsBox;
  late Box<DateNoteAssociationModel> _associationsBox;
  late Box<dynamic> _settingsBox;

  /// Inicializa las cajas de Hive
  Future<void> init() async {
    _eventsBox = await Hive.openBox<CalendarEventModel>(_eventsBoxName);
    _associationsBox = await Hive.openBox<DateNoteAssociationModel>(_associationsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // ===== OPERACIONES DE EVENTOS =====

  /// Obtiene todos los eventos
  List<CalendarEventModel> getAllEvents() {
    return _eventsBox.values.toList();
  }

  /// Obtiene eventos para una fecha específica
  List<CalendarEventModel> getEventsForDate(DateTime date) {
    return _eventsBox.values
        .where((event) => _isSameDate(event.date, date))
        .toList();
  }

  /// Obtiene eventos en un rango de fechas
  List<CalendarEventModel> getEventsInRange(DateTime startDate, DateTime endDate) {
    return _eventsBox.values
        .where((event) => 
            event.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            event.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  /// Obtiene eventos por tipo
  List<CalendarEventModel> getEventsByType(int typeIndex) {
    return _eventsBox.values
        .where((event) => event.typeIndex == typeIndex)
        .toList();
  }

  /// Obtiene eventos por color tag
  List<CalendarEventModel> getEventsByColorTag(String colorTag) {
    return _eventsBox.values
        .where((event) => event.colorTag == colorTag)
        .toList();
  }

  /// Obtiene un evento por ID
  CalendarEventModel? getEventById(String id) {
    return _eventsBox.get(id);
  }

  /// Guarda un evento
  Future<void> saveEvent(CalendarEventModel event) async {
    await _eventsBox.put(event.id, event);
  }

  /// Actualiza un evento
  Future<void> updateEvent(CalendarEventModel event) async {
    event.updatedAt = DateTime.now();
    await _eventsBox.put(event.id, event);
  }

  /// Elimina un evento
  Future<void> deleteEvent(String id) async {
    await _eventsBox.delete(id);
  }

  /// Elimina todos los eventos de una fecha
  Future<void> deleteEventsForDate(DateTime date) async {
    final eventsToDelete = getEventsForDate(date);
    for (final event in eventsToDelete) {
      await deleteEvent(event.id);
    }
  }

  /// Elimina todos los eventos
  Future<void> deleteAllEvents() async {
    await _eventsBox.clear();
  }

  // ===== OPERACIONES DE ASOCIACIONES =====

  /// Obtiene todas las asociaciones
  List<DateNoteAssociationModel> getAllAssociations() {
    return _associationsBox.values.toList();
  }

  /// Obtiene asociaciones para una fecha específica
  List<DateNoteAssociationModel> getAssociationsForDate(DateTime date) {
    return _associationsBox.values
        .where((association) => _isSameDate(association.date, date))
        .toList();
  }

  /// Obtiene asociaciones en un rango de fechas
  List<DateNoteAssociationModel> getAssociationsInRange(DateTime startDate, DateTime endDate) {
    return _associationsBox.values
        .where((association) => 
            association.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            association.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  /// Obtiene asociaciones por nota
  List<DateNoteAssociationModel> getAssociationsForNote(String noteId) {
    return _associationsBox.values
        .where((association) => association.noteId == noteId)
        .toList();
  }

  /// Obtiene asociaciones pendientes
  List<DateNoteAssociationModel> getPendingAssociations() {
    return _associationsBox.values
        .where((association) => !association.isCompleted)
        .toList();
  }

  /// Obtiene asociaciones completadas
  List<DateNoteAssociationModel> getCompletedAssociations() {
    return _associationsBox.values
        .where((association) => association.isCompleted)
        .toList();
  }

  /// Obtiene asociaciones vencidas
  List<DateNoteAssociationModel> getOverdueAssociations() {
    final now = DateTime.now();
    return _associationsBox.values
        .where((association) => 
            !association.isCompleted && 
            association.date.isBefore(now))
        .toList();
  }

  /// Obtiene asociaciones por prioridad
  List<DateNoteAssociationModel> getAssociationsByPriority(int priority) {
    return _associationsBox.values
        .where((association) => association.priority == priority)
        .toList();
  }

  /// Obtiene una asociación por ID
  DateNoteAssociationModel? getAssociationById(String id) {
    return _associationsBox.get(id);
  }

  /// Guarda una asociación
  Future<void> saveAssociation(DateNoteAssociationModel association) async {
    await _associationsBox.put(association.id, association);
  }

  /// Actualiza una asociación
  Future<void> updateAssociation(DateNoteAssociationModel association) async {
    association.updatedAt = DateTime.now();
    await _associationsBox.put(association.id, association);
  }

  /// Marca una asociación como completada
  Future<void> markAssociationAsCompleted(String id) async {
    final association = getAssociationById(id);
    if (association != null) {
      association.isCompleted = true;
      await updateAssociation(association);
    }
  }

  /// Marca una asociación como pendiente
  Future<void> markAssociationAsPending(String id) async {
    final association = getAssociationById(id);
    if (association != null) {
      association.isCompleted = false;
      await updateAssociation(association);
    }
  }

  /// Elimina una asociación
  Future<void> deleteAssociation(String id) async {
    await _associationsBox.delete(id);
  }

  /// Elimina todas las asociaciones de una nota
  Future<void> deleteAssociationsForNote(String noteId) async {
    final associationsToDelete = getAssociationsForNote(noteId);
    for (final association in associationsToDelete) {
      await deleteAssociation(association.id);
    }
  }

  /// Elimina todas las asociaciones
  Future<void> deleteAllAssociations() async {
    await _associationsBox.clear();
  }

  // ===== OPERACIONES DE CONFIGURACIÓN =====

  /// Obtiene los colores de etiquetas disponibles
  List<String> getAvailableColorTags() {
    final tags = _settingsBox.get('color_tags', defaultValue: <String>[]);
    return List<String>.from(tags);
  }

  /// Guarda un color de etiqueta
  Future<void> saveColorTag(String colorTag) async {
    final currentTags = getAvailableColorTags();
    if (!currentTags.contains(colorTag)) {
      currentTags.add(colorTag);
      await _settingsBox.put('color_tags', currentTags);
    }
  }

  /// Elimina un color de etiqueta
  Future<void> deleteColorTag(String colorTag) async {
    final currentTags = getAvailableColorTags();
    currentTags.remove(colorTag);
    await _settingsBox.put('color_tags', currentTags);
  }

  /// Obtiene la configuración del calendario
  Map<String, dynamic> getCalendarSettings() {
    return Map<String, dynamic>.from(_settingsBox.get('settings', defaultValue: {}));
  }

  /// Guarda la configuración del calendario
  Future<void> saveCalendarSettings(Map<String, dynamic> settings) async {
    await _settingsBox.put('settings', settings);
  }

  // ===== OPERACIONES DE BÚSQUEDA =====

  /// Busca eventos por título o descripción
  List<CalendarEventModel> searchEvents(String query) {
    final lowerQuery = query.toLowerCase();
    return _eventsBox.values
        .where((event) => 
            event.title.toLowerCase().contains(lowerQuery) ||
            (event.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  /// Busca asociaciones por nota ID
  List<DateNoteAssociationModel> searchAssociations(String query) {
    final lowerQuery = query.toLowerCase();
    return _associationsBox.values
        .where((association) => association.noteId.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // ===== UTILIDADES =====

  /// Verifica si dos fechas son del mismo día
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Obtiene estadísticas generales
  Map<String, dynamic> getStatistics() {
    final totalEvents = _eventsBox.length;
    final totalAssociations = _associationsBox.length;
    final completedAssociations = getCompletedAssociations().length;
    final pendingAssociations = getPendingAssociations().length;
    final overdueAssociations = getOverdueAssociations().length;

    return {
      'totalEvents': totalEvents,
      'totalAssociations': totalAssociations,
      'completedAssociations': completedAssociations,
      'pendingAssociations': pendingAssociations,
      'overdueAssociations': overdueAssociations,
      'completionRate': totalAssociations > 0 
          ? (completedAssociations / totalAssociations * 100).round() 
          : 0,
    };
  }

  /// Cierra las cajas de Hive
  Future<void> close() async {
    await _eventsBox.close();
    await _associationsBox.close();
    await _settingsBox.close();
  }
}
