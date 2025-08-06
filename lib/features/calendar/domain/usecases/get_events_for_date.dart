import '../entities/calendar_event.dart';
import '../repositories/calendar_repository.dart';

/// Caso de uso para obtener eventos de una fecha específica
class GetEventsForDate {
  final CalendarRepository repository;

  const GetEventsForDate(this.repository);

  /// Ejecuta el caso de uso
  Future<List<CalendarEvent>> call(DateTime date) async {
    try {
      return await repository.getEventsForDate(date);
    } catch (e) {
      throw Exception('Error al obtener eventos para la fecha: $e');
    }
  }

  /// Obtiene eventos para hoy
  Future<List<CalendarEvent>> getTodaysEvents() async {
    return call(DateTime.now());
  }

  /// Obtiene eventos para mañana
  Future<List<CalendarEvent>> getTomorrowsEvents() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return call(tomorrow);
  }

  /// Obtiene eventos para la semana actual
  Future<List<CalendarEvent>> getThisWeeksEvents() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return await repository.getEventsInRange(startOfWeek, endOfWeek);
  }

  /// Obtiene eventos para el mes actual
  Future<List<CalendarEvent>> getThisMonthsEvents() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return await repository.getEventsInRange(startOfMonth, endOfMonth);
  }

  /// Agrupa eventos por fecha
  Map<DateTime, List<CalendarEvent>> groupEventsByDate(List<CalendarEvent> events) {
    final grouped = <DateTime, List<CalendarEvent>>{};
    
    for (final event in events) {
      final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(event);
      } else {
        grouped[dateKey] = [event];
      }
    }
    
    return grouped;
  }

  /// Filtra eventos por tipo
  List<CalendarEvent> filterByType(List<CalendarEvent> events, CalendarEventType type) {
    return events.where((event) => event.type == type).toList();
  }

  /// Filtra eventos de todo el día
  List<CalendarEvent> filterAllDayEvents(List<CalendarEvent> events) {
    return events.where((event) => event.isAllDay).toList();
  }

  /// Filtra eventos con hora específica
  List<CalendarEvent> filterTimedEvents(List<CalendarEvent> events) {
    return events.where((event) => !event.isAllDay).toList();
  }

  /// Ordena eventos por hora de inicio
  List<CalendarEvent> sortByStartTime(List<CalendarEvent> events) {
    final List<CalendarEvent> sorted = List.from(events);
    sorted.sort((a, b) {
      // Eventos de todo el día primero
      if (a.isAllDay && !b.isAllDay) return -1;
      if (!a.isAllDay && b.isAllDay) return 1;
      if (a.isAllDay && b.isAllDay) return 0;
      
      // Luego por hora de inicio
      if (a.startTime != null && b.startTime != null) {
        return a.startTime!.compareTo(b.startTime!);
      }
      
      return 0;
    });
    return sorted;
  }
}
