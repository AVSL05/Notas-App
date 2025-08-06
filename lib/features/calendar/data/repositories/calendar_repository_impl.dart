import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/date_note_association.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/calendar_local_datasource.dart';
import '../models/calendar_event_model.dart';
import '../models/date_note_association_model.dart';

/// Implementación concreta del repositorio del calendario
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarLocalDatasource localDatasource;

  const CalendarRepositoryImpl({
    required this.localDatasource,
  });

  // ===== EVENTOS DEL CALENDARIO =====

  @override
  Future<List<CalendarEvent>> getAllEvents() async {
    try {
      final models = localDatasource.getAllEvents();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener todos los eventos: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsForDate(DateTime date) async {
    try {
      final models = localDatasource.getEventsForDate(date);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos para la fecha: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsInRange(DateTime startDate, DateTime endDate) async {
    try {
      final models = localDatasource.getEventsInRange(startDate, endDate);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos en rango: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsByType(CalendarEventType type) async {
    try {
      final models = localDatasource.getEventsByType(type.index);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos por tipo: $e');
    }
  }

  @override
  Future<List<CalendarEvent>> getEventsByColorTag(String colorTag) async {
    try {
      final models = localDatasource.getEventsByColorTag(colorTag);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos por color: $e');
    }
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    try {
      final model = CalendarEventModel.fromEntity(event);
      await localDatasource.saveEvent(model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  @override
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    try {
      final updatedEvent = event.copyWith(updatedAt: DateTime.now());
      final model = CalendarEventModel.fromEntity(updatedEvent);
      await localDatasource.updateEvent(model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al actualizar evento: $e');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await localDatasource.deleteEvent(eventId);
    } catch (e) {
      throw Exception('Error al eliminar evento: $e');
    }
  }

  @override
  Future<void> deleteEventsForDate(DateTime date) async {
    try {
      await localDatasource.deleteEventsForDate(date);
    } catch (e) {
      throw Exception('Error al eliminar eventos de la fecha: $e');
    }
  }

  // ===== ASOCIACIONES FECHA-NOTA =====

  @override
  Future<List<DateNoteAssociation>> getAllAssociations() async {
    try {
      final models = localDatasource.getAllAssociations();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener todas las asociaciones: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getAssociationsForDate(DateTime date) async {
    try {
      final models = localDatasource.getAssociationsForDate(date);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones para la fecha: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getAssociationsInRange(DateTime startDate, DateTime endDate) async {
    try {
      final models = localDatasource.getAssociationsInRange(startDate, endDate);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones en rango: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getAssociationsForNote(String noteId) async {
    try {
      final models = localDatasource.getAssociationsForNote(noteId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones para la nota: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getPendingAssociations() async {
    try {
      final models = localDatasource.getPendingAssociations();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones pendientes: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getCompletedAssociations() async {
    try {
      final models = localDatasource.getCompletedAssociations();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones completadas: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getOverdueAssociations() async {
    try {
      final models = localDatasource.getOverdueAssociations();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones vencidas: $e');
    }
  }

  @override
  Future<List<DateNoteAssociation>> getAssociationsByPriority(int priority) async {
    try {
      final models = localDatasource.getAssociationsByPriority(priority);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error al obtener asociaciones por prioridad: $e');
    }
  }

  @override
  Future<DateNoteAssociation> createAssociation(DateNoteAssociation association) async {
    try {
      final model = DateNoteAssociationModel.fromEntity(association);
      await localDatasource.saveAssociation(model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al crear asociación: $e');
    }
  }

  @override
  Future<DateNoteAssociation> updateAssociation(DateNoteAssociation association) async {
    try {
      final updatedAssociation = association.copyWith(updatedAt: DateTime.now());
      final model = DateNoteAssociationModel.fromEntity(updatedAssociation);
      await localDatasource.updateAssociation(model);
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al actualizar asociación: $e');
    }
  }

  @override
  Future<DateNoteAssociation> markAssociationAsCompleted(String associationId) async {
    try {
      await localDatasource.markAssociationAsCompleted(associationId);
      final model = localDatasource.getAssociationById(associationId);
      if (model == null) {
        throw Exception('Asociación no encontrada');
      }
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al marcar asociación como completada: $e');
    }
  }

  @override
  Future<DateNoteAssociation> markAssociationAsPending(String associationId) async {
    try {
      await localDatasource.markAssociationAsPending(associationId);
      final model = localDatasource.getAssociationById(associationId);
      if (model == null) {
        throw Exception('Asociación no encontrada');
      }
      return model.toEntity();
    } catch (e) {
      throw Exception('Error al marcar asociación como pendiente: $e');
    }
  }

  @override
  Future<void> deleteAssociation(String associationId) async {
    try {
      await localDatasource.deleteAssociation(associationId);
    } catch (e) {
      throw Exception('Error al eliminar asociación: $e');
    }
  }

  @override
  Future<void> deleteAssociationsForNote(String noteId) async {
    try {
      await localDatasource.deleteAssociationsForNote(noteId);
    } catch (e) {
      throw Exception('Error al eliminar asociaciones de la nota: $e');
    }
  }

  // ===== OPERACIONES COMBINADAS =====

  @override
  Future<Map<String, dynamic>> getCalendarDataForDate(DateTime date) async {
    try {
      final events = await getEventsForDate(date);
      final associations = await getAssociationsForDate(date);
      
      return {
        'date': date,
        'events': events,
        'associations': associations,
        'totalItems': events.length + associations.length,
      };
    } catch (e) {
      throw Exception('Error al obtener datos del calendario para la fecha: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCalendarDataForMonth(int year, int month) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);
      
      final events = await getEventsInRange(startDate, endDate);
      final associations = await getAssociationsInRange(startDate, endDate);
      
      // Agrupar por fecha
      final eventsByDate = <DateTime, List<CalendarEvent>>{};
      final associationsByDate = <DateTime, List<DateNoteAssociation>>{};
      
      for (final event in events) {
        final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
        eventsByDate.putIfAbsent(dateKey, () => []).add(event);
      }
      
      for (final association in associations) {
        final dateKey = DateTime(association.date.year, association.date.month, association.date.day);
        associationsByDate.putIfAbsent(dateKey, () => []).add(association);
      }
      
      return {
        'year': year,
        'month': month,
        'startDate': startDate,
        'endDate': endDate,
        'events': events,
        'associations': associations,
        'eventsByDate': eventsByDate,
        'associationsByDate': associationsByDate,
        'totalItems': events.length + associations.length,
      };
    } catch (e) {
      throw Exception('Error al obtener datos del calendario para el mes: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCalendarStatistics() async {
    try {
      final stats = localDatasource.getStatistics();
      final events = await getAllEvents();
      final associations = await getAllAssociations();
      
      final eventsByType = <CalendarEventType, int>{};
      for (final event in events) {
        eventsByType[event.type] = (eventsByType[event.type] ?? 0) + 1;
      }
      
      final associationsByPriority = <int, int>{};
      for (final association in associations) {
        associationsByPriority[association.priority] = 
            (associationsByPriority[association.priority] ?? 0) + 1;
      }
      
      return {
        ...stats,
        'eventsByType': eventsByType,
        'associationsByPriority': associationsByPriority,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas del calendario: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> searchCalendar(String query) async {
    try {
      final eventModels = localDatasource.searchEvents(query);
      final associationModels = localDatasource.searchAssociations(query);
      
      final events = eventModels.map((model) => model.toEntity()).toList();
      final associations = associationModels.map((model) => model.toEntity()).toList();
      
      return {
        'query': query,
        'events': events,
        'associations': associations,
        'totalResults': events.length + associations.length,
      };
    } catch (e) {
      throw Exception('Error al buscar en el calendario: $e');
    }
  }

  // ===== CONFIGURACIÓN Y PREFERENCIAS =====

  @override
  Future<List<String>> getAvailableColorTags() async {
    try {
      final tags = localDatasource.getAvailableColorTags();
      
      // Si no hay tags guardados, devolver los predeterminados
      if (tags.isEmpty) {
        final defaultTags = CalendarEventType.values.map((type) => type.defaultColor).toList();
        for (final tag in defaultTags) {
          await saveColorTag(tag);
        }
        return defaultTags;
      }
      
      return tags;
    } catch (e) {
      throw Exception('Error al obtener colores de etiquetas: $e');
    }
  }

  @override
  Future<void> saveColorTag(String colorTag) async {
    try {
      await localDatasource.saveColorTag(colorTag);
    } catch (e) {
      throw Exception('Error al guardar color de etiqueta: $e');
    }
  }

  @override
  Future<void> deleteColorTag(String colorTag) async {
    try {
      await localDatasource.deleteColorTag(colorTag);
    } catch (e) {
      throw Exception('Error al eliminar color de etiqueta: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCalendarSettings() async {
    try {
      final settings = localDatasource.getCalendarSettings();
      
      // Configuración predeterminada si no existe
      if (settings.isEmpty) {
        final defaultSettings = {
          'defaultView': 'month',
          'weekStartsOnMonday': true,
          'showWeekNumbers': false,
          'defaultEventDuration': 60, // minutos
          'notifications': true,
          'theme': 'system',
        };
        await saveCalendarSettings(defaultSettings);
        return defaultSettings;
      }
      
      return settings;
    } catch (e) {
      throw Exception('Error al obtener configuración del calendario: $e');
    }
  }

  @override
  Future<void> saveCalendarSettings(Map<String, dynamic> settings) async {
    try {
      await localDatasource.saveCalendarSettings(settings);
    } catch (e) {
      throw Exception('Error al guardar configuración del calendario: $e');
    }
  }
}
