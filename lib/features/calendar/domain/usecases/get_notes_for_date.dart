import '../entities/date_note_association.dart';
import '../repositories/calendar_repository.dart';

/// Caso de uso para obtener notas asociadas a fechas
class GetNotesForDate {
  final CalendarRepository repository;

  const GetNotesForDate(this.repository);

  /// Ejecuta el caso de uso
  Future<List<DateNoteAssociation>> call(DateTime date) async {
    try {
      return await repository.getAssociationsForDate(date);
    } catch (e) {
      throw Exception('Error al obtener notas para la fecha: $e');
    }
  }

  /// Obtiene asociaciones para hoy
  Future<List<DateNoteAssociation>> getTodaysNotes() async {
    return call(DateTime.now());
  }

  /// Obtiene asociaciones pendientes para hoy
  Future<List<DateNoteAssociation>> getTodaysPendingNotes() async {
    final todaysNotes = await getTodaysNotes();
    return todaysNotes.where((note) => !note.isCompleted).toList();
  }

  /// Obtiene asociaciones completadas para hoy
  Future<List<DateNoteAssociation>> getTodaysCompletedNotes() async {
    final todaysNotes = await getTodaysNotes();
    return todaysNotes.where((note) => note.isCompleted).toList();
  }

  /// Obtiene asociaciones vencidas
  Future<List<DateNoteAssociation>> getOverdueNotes() async {
    try {
      return await repository.getOverdueAssociations();
    } catch (e) {
      throw Exception('Error al obtener notas vencidas: $e');
    }
  }

  /// Obtiene asociaciones para la semana actual
  Future<List<DateNoteAssociation>> getThisWeeksNotes() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    try {
      return await repository.getAssociationsInRange(startOfWeek, endOfWeek);
    } catch (e) {
      throw Exception('Error al obtener notas de la semana: $e');
    }
  }

  /// Obtiene asociaciones para el mes actual
  Future<List<DateNoteAssociation>> getThisMonthsNotes() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    try {
      return await repository.getAssociationsInRange(startOfMonth, endOfMonth);
    } catch (e) {
      throw Exception('Error al obtener notas del mes: $e');
    }
  }

  /// Obtiene asociaciones por prioridad
  Future<List<DateNoteAssociation>> getNotesByPriority(int priority) async {
    try {
      return await repository.getAssociationsByPriority(priority);
    } catch (e) {
      throw Exception('Error al obtener notas por prioridad: $e');
    }
  }

  /// Obtiene asociaciones de alta prioridad
  Future<List<DateNoteAssociation>> getHighPriorityNotes() async {
    return getNotesByPriority(1);
  }

  /// Obtiene asociaciones de media prioridad
  Future<List<DateNoteAssociation>> getMediumPriorityNotes() async {
    return getNotesByPriority(2);
  }

  /// Obtiene asociaciones de baja prioridad
  Future<List<DateNoteAssociation>> getLowPriorityNotes() async {
    return getNotesByPriority(3);
  }

  /// Agrupa asociaciones por fecha
  Map<DateTime, List<DateNoteAssociation>> groupNotesByDate(List<DateNoteAssociation> notes) {
    final grouped = <DateTime, List<DateNoteAssociation>>{};
    
    for (final note in notes) {
      final dateKey = DateTime(note.date.year, note.date.month, note.date.day);
      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(note);
      } else {
        grouped[dateKey] = [note];
      }
    }
    
    return grouped;
  }

  /// Crea grupos de asociaciones por fecha
  List<DateNoteGroup> createDateGroups(List<DateNoteAssociation> notes) {
    final grouped = groupNotesByDate(notes);
    return grouped.entries.map((entry) => 
      DateNoteGroup(date: entry.key, associations: entry.value)
    ).toList();
  }

  /// Filtra asociaciones pendientes
  List<DateNoteAssociation> filterPending(List<DateNoteAssociation> notes) {
    return notes.where((note) => !note.isCompleted).toList();
  }

  /// Filtra asociaciones completadas
  List<DateNoteAssociation> filterCompleted(List<DateNoteAssociation> notes) {
    return notes.where((note) => note.isCompleted).toList();
  }

  /// Filtra asociaciones vencidas
  List<DateNoteAssociation> filterOverdue(List<DateNoteAssociation> notes) {
    return notes.where((note) => note.isOverdue).toList();
  }

  /// Filtra asociaciones para hoy
  List<DateNoteAssociation> filterDueToday(List<DateNoteAssociation> notes) {
    return notes.where((note) => note.isDueToday).toList();
  }

  /// Filtra asociaciones para mañana
  List<DateNoteAssociation> filterDueTomorrow(List<DateNoteAssociation> notes) {
    return notes.where((note) => note.isDueTomorrow).toList();
  }

  /// Ordena asociaciones por fecha
  List<DateNoteAssociation> sortByDate(List<DateNoteAssociation> notes, {bool ascending = true}) {
    final List<DateNoteAssociation> sorted = List.from(notes);
    sorted.sort((a, b) => ascending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
    return sorted;
  }

  /// Ordena asociaciones por prioridad
  List<DateNoteAssociation> sortByPriority(List<DateNoteAssociation> notes, {bool ascending = true}) {
    final List<DateNoteAssociation> sorted = List.from(notes);
    sorted.sort((a, b) => ascending ? a.priority.compareTo(b.priority) : b.priority.compareTo(a.priority));
    return sorted;
  }

  /// Ordena asociaciones por fecha de creación
  List<DateNoteAssociation> sortByCreated(List<DateNoteAssociation> notes, {bool ascending = false}) {
    final List<DateNoteAssociation> sorted = List.from(notes);
    sorted.sort((a, b) => ascending ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Obtiene estadísticas de las asociaciones
  Map<String, dynamic> getNotesStatistics(List<DateNoteAssociation> notes) {
    final total = notes.length;
    final completed = filterCompleted(notes).length;
    final pending = filterPending(notes).length;
    final overdue = filterOverdue(notes).length;
    final highPriority = notes.where((n) => n.priority == 1).length;
    final mediumPriority = notes.where((n) => n.priority == 2).length;
    final lowPriority = notes.where((n) => n.priority == 3).length;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'completionRate': total > 0 ? (completed / total * 100).round() : 0,
      'priorityDistribution': {
        'high': highPriority,
        'medium': mediumPriority,
        'low': lowPriority,
      },
    };
  }
}
