import 'package:equatable/equatable.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/date_note_association.dart';

/// Eventos base para el CalendarBloc
abstract class CalendarBlocEvent extends Equatable {
  const CalendarBlocEvent();

  @override
  List<Object?> get props => [];
}

// ===== EVENTOS DE NAVEGACIÓN =====

/// Evento para cambiar a una fecha específica
class CalendarDateChanged extends CalendarBlocEvent {
  final DateTime date;

  const CalendarDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

/// Evento para navegar al mes anterior
class CalendarPreviousMonth extends CalendarBlocEvent {}

/// Evento para navegar al mes siguiente
class CalendarNextMonth extends CalendarBlocEvent {}

/// Evento para ir a hoy
class CalendarGoToToday extends CalendarBlocEvent {}

/// Evento para cambiar la vista del calendario
class CalendarViewChanged extends CalendarBlocEvent {
  final CalendarViewType viewType;

  const CalendarViewChanged(this.viewType);

  @override
  List<Object?> get props => [viewType];
}

// ===== EVENTOS DE DATOS =====

/// Evento para cargar eventos de una fecha
class CalendarLoadEventsForDate extends CalendarBlocEvent {
  final DateTime date;

  const CalendarLoadEventsForDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Evento para cargar datos del mes
class CalendarLoadMonthData extends CalendarBlocEvent {
  final int year;
  final int month;

  const CalendarLoadMonthData(this.year, this.month);

  @override
  List<Object?> get props => [year, month];
}

/// Evento para refrescar todos los datos
class CalendarRefreshData extends CalendarBlocEvent {}

// ===== EVENTOS DE EVENTOS DEL CALENDARIO =====

/// Evento para crear un nuevo evento
class CalendarCreateEvent extends CalendarBlocEvent {
  final CalendarEvent event;

  const CalendarCreateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

/// Evento para crear un evento rápido
class CalendarCreateQuickEvent extends CalendarBlocEvent {
  final String title;
  final DateTime date;
  final String? description;
  final CalendarEventType type;
  final String? colorTag;

  const CalendarCreateQuickEvent({
    required this.title,
    required this.date,
    this.description,
    this.type = CalendarEventType.note,
    this.colorTag,
  });

  @override
  List<Object?> get props => [title, date, description, type, colorTag];
}

/// Evento para actualizar un evento existente
class CalendarUpdateEvent extends CalendarBlocEvent {
  final CalendarEvent event;

  const CalendarUpdateEvent(this.event);

  @override
  List<Object?> get props => [event];
}

/// Evento para eliminar un evento
class CalendarDeleteEvent extends CalendarBlocEvent {
  final String eventId;

  const CalendarDeleteEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

// ===== EVENTOS DE ASOCIACIONES =====

/// Evento para crear una asociación fecha-nota
class CalendarCreateAssociation extends CalendarBlocEvent {
  final DateNoteAssociation association;

  const CalendarCreateAssociation(this.association);

  @override
  List<Object?> get props => [association];
}

/// Evento para crear una asociación rápida
class CalendarCreateQuickAssociation extends CalendarBlocEvent {
  final String noteId;
  final DateTime date;
  final String colorTag;
  final int priority;

  const CalendarCreateQuickAssociation({
    required this.noteId,
    required this.date,
    required this.colorTag,
    this.priority = 2,
  });

  @override
  List<Object?> get props => [noteId, date, colorTag, priority];
}

/// Evento para actualizar una asociación
class CalendarUpdateAssociation extends CalendarBlocEvent {
  final DateNoteAssociation association;

  const CalendarUpdateAssociation(this.association);

  @override
  List<Object?> get props => [association];
}

/// Evento para marcar asociación como completada
class CalendarMarkAssociationCompleted extends CalendarBlocEvent {
  final String associationId;

  const CalendarMarkAssociationCompleted(this.associationId);

  @override
  List<Object?> get props => [associationId];
}

/// Evento para marcar asociación como pendiente
class CalendarMarkAssociationPending extends CalendarBlocEvent {
  final String associationId;

  const CalendarMarkAssociationPending(this.associationId);

  @override
  List<Object?> get props => [associationId];
}

/// Evento para eliminar una asociación
class CalendarDeleteAssociation extends CalendarBlocEvent {
  final String associationId;

  const CalendarDeleteAssociation(this.associationId);

  @override
  List<Object?> get props => [associationId];
}

// ===== EVENTOS DE BÚSQUEDA Y FILTROS =====

/// Evento para buscar en el calendario
class CalendarSearch extends CalendarBlocEvent {
  final String query;

  const CalendarSearch(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para limpiar búsqueda
class CalendarClearSearch extends CalendarBlocEvent {}

/// Evento para filtrar eventos por tipo
class CalendarFilterByType extends CalendarBlocEvent {
  final CalendarEventType? type;

  const CalendarFilterByType(this.type);

  @override
  List<Object?> get props => [type];
}

/// Evento para filtrar asociaciones por prioridad
class CalendarFilterByPriority extends CalendarBlocEvent {
  final int? priority;

  const CalendarFilterByPriority(this.priority);

  @override
  List<Object?> get props => [priority];
}

/// Evento para filtrar asociaciones por estado
class CalendarFilterByCompletionStatus extends CalendarBlocEvent {
  final bool? isCompleted;

  const CalendarFilterByCompletionStatus(this.isCompleted);

  @override
  List<Object?> get props => [isCompleted];
}

// ===== EVENTOS DE CONFIGURACIÓN =====

/// Evento para cargar configuración
class CalendarLoadSettings extends CalendarBlocEvent {}

/// Evento para guardar configuración
class CalendarSaveSettings extends CalendarBlocEvent {
  final Map<String, dynamic> settings;

  const CalendarSaveSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Evento para agregar color tag
class CalendarAddColorTag extends CalendarBlocEvent {
  final String colorTag;

  const CalendarAddColorTag(this.colorTag);

  @override
  List<Object?> get props => [colorTag];
}

/// Evento para eliminar color tag
class CalendarRemoveColorTag extends CalendarBlocEvent {
  final String colorTag;

  const CalendarRemoveColorTag(this.colorTag);

  @override
  List<Object?> get props => [colorTag];
}

// ===== EVENTOS DE ESTADÍSTICAS =====

/// Evento para cargar estadísticas
class CalendarLoadStatistics extends CalendarBlocEvent {}

// ===== ENUMS AUXILIARES =====

/// Tipos de vista del calendario
enum CalendarViewType {
  month,
  week,
  day,
  agenda,
}

extension CalendarViewTypeExtension on CalendarViewType {
  String get displayName {
    switch (this) {
      case CalendarViewType.month:
        return 'Mes';
      case CalendarViewType.week:
        return 'Semana';
      case CalendarViewType.day:
        return 'Día';
      case CalendarViewType.agenda:
        return 'Agenda';
    }
  }

  String get icon {
    switch (this) {
      case CalendarViewType.month:
        return '📅';
      case CalendarViewType.week:
        return '📊';
      case CalendarViewType.day:
        return '📋';
      case CalendarViewType.agenda:
        return '📝';
    }
  }
}
