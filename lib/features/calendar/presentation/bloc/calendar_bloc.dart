import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/date_note_association.dart';
import '../../domain/usecases/get_events_for_date.dart';
import '../../domain/usecases/create_calendar_event.dart';
import '../../domain/usecases/get_notes_for_date.dart';
import 'calendar_state.dart';
import 'calendar_event.dart';

/// BLoC que maneja el estado del calendario
class CalendarBloc extends Bloc<CalendarBlocEvent, CalendarState> {
  final GetEventsForDate _getEventsForDate;
  final CreateCalendarEvent _createCalendarEvent;
  final GetNotesForDate _getNotesForDate;

  CalendarBloc({
    required GetEventsForDate getEventsForDate,
    required CreateCalendarEvent createCalendarEvent,
    required GetNotesForDate getNotesForDate,
  })  : _getEventsForDate = getEventsForDate,
        _createCalendarEvent = createCalendarEvent,
        _getNotesForDate = getNotesForDate,
        super(CalendarInitial()) {
    
    // Registrar manejadores de eventos
    on<CalendarDateChanged>(_onDateChanged);
    on<CalendarLoadEventsForDate>(_onLoadEventsForDate);
    on<CalendarCreateEvent>(_onCreateEvent);
    on<CalendarUpdateEvent>(_onUpdateEvent);
    on<CalendarDeleteEvent>(_onDeleteEvent);
    on<CalendarFilterByType>(_onFilterByType);
    on<CalendarViewChanged>(_onViewChanged);
    on<CalendarGoToToday>(_onGoToToday);
  }

  /// Maneja el cambio de fecha
  Future<void> _onDateChanged(
    CalendarDateChanged event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

    try {
      // Cargar eventos para la fecha seleccionada
      final events = await _getEventsForDate(event.date);
      final notes = await _getNotesForDate(event.date);

      emit(CalendarLoaded(
        selectedDate: event.date,
        viewType: CalendarViewType.month,
        events: events,
        associations: notes,
        eventsByDate: _groupEventsByDate(events),
        associationsByDate: _groupAssociationsByDate(notes),
        availableColorTags: _getAvailableColorTags(events, notes),
        settings: const {},
      ));
    } catch (e) {
      emit(CalendarError(message: 'Error al cargar datos para la fecha seleccionada: $e'));
    }
  }

  /// Maneja la carga de eventos para una fecha
  Future<void> _onLoadEventsForDate(
    CalendarLoadEventsForDate event,
    Emitter<CalendarState> emit,
  ) async {
    emit(const CalendarLoadingSpecific('events'));

    try {
      final events = await _getEventsForDate(event.date);

      if (state is CalendarLoaded) {
        final currentState = state as CalendarLoaded;
        emit(currentState.copyWith(
          selectedDate: event.date,
          events: events,
          eventsByDate: _groupEventsByDate(events),
        ));
      } else {
        emit(CalendarLoaded(
          selectedDate: event.date,
          viewType: CalendarViewType.month,
          events: events,
          associations: const [],
          eventsByDate: _groupEventsByDate(events),
          associationsByDate: const {},
          availableColorTags: _getAvailableColorTags(events, const []),
          settings: const {},
        ));
      }
    } catch (e) {
      emit(CalendarError(message: 'Error al cargar eventos: $e'));
    }
  }

  /// Maneja la creación de un evento
  Future<void> _onCreateEvent(
    CalendarCreateEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(const CalendarLoadingSpecific('creating'));

    try {
      final createdEvent = await _createCalendarEvent(event.event);

      if (state is CalendarLoaded) {
        final currentState = state as CalendarLoaded;
        final updatedEvents = List<CalendarEvent>.from(currentState.events)
          ..add(createdEvent);

        emit(currentState.copyWith(
          events: updatedEvents,
          eventsByDate: _groupEventsByDate(updatedEvents),
        ));
      }
    } catch (e) {
      emit(CalendarError(message: 'Error al crear evento: $e'));
    }
  }

  /// Maneja la actualización de un evento
  Future<void> _onUpdateEvent(
    CalendarUpdateEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(const CalendarLoadingSpecific('updating'));

    try {
      if (state is CalendarLoaded) {
        final currentState = state as CalendarLoaded;
        final updatedEvents = currentState.events.map((e) {
          return e.id == event.event.id ? event.event : e;
        }).toList();

        emit(currentState.copyWith(
          events: updatedEvents,
          eventsByDate: _groupEventsByDate(updatedEvents),
        ));
      }
    } catch (e) {
      emit(CalendarError(message: 'Error al actualizar evento: $e'));
    }
  }

  /// Maneja la eliminación de un evento
  Future<void> _onDeleteEvent(
    CalendarDeleteEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(const CalendarLoadingSpecific('deleting'));

    try {
      if (state is CalendarLoaded) {
        final currentState = state as CalendarLoaded;
        final updatedEvents = currentState.events
            .where((e) => e.id != event.eventId)
            .toList();

        emit(currentState.copyWith(
          events: updatedEvents,
          eventsByDate: _groupEventsByDate(updatedEvents),
        ));
      }
    } catch (e) {
      emit(CalendarError(message: 'Error al eliminar evento: $e'));
    }
  }

  /// Maneja el filtrado por tipo
  Future<void> _onFilterByType(
    CalendarFilterByType event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      
      emit(currentState.copyWith(
        typeFilter: event.type,
      ));
    }
  }

  /// Maneja el cambio de vista
  void _onViewChanged(
    CalendarViewChanged event,
    Emitter<CalendarState> emit,
  ) {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      emit(currentState.copyWith(viewType: event.viewType));
    }
  }

  /// Maneja ir a hoy
  void _onGoToToday(
    CalendarGoToToday event,
    Emitter<CalendarState> emit,
  ) {
    add(CalendarDateChanged(DateTime.now()));
  }

  /// Agrupa eventos por fecha
  Map<DateTime, List<CalendarEvent>> _groupEventsByDate(List<CalendarEvent> events) {
    final Map<DateTime, List<CalendarEvent>> grouped = {};
    
    for (final event in events) {
      final dateKey = DateTime(event.date.year, event.date.month, event.date.day);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(event);
    }
    
    return grouped;
  }

  /// Agrupa asociaciones por fecha
  Map<DateTime, List<DateNoteAssociation>> _groupAssociationsByDate(List<DateNoteAssociation> associations) {
    final Map<DateTime, List<DateNoteAssociation>> grouped = {};
    
    for (final association in associations) {
      final dateKey = DateTime(association.date.year, association.date.month, association.date.day);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(association);
    }
    
    return grouped;
  }

  /// Obtiene las etiquetas de color disponibles
  List<String> _getAvailableColorTags(List<CalendarEvent> events, List<DateNoteAssociation> associations) {
    final Set<String> colorTags = {};
    
    for (final event in events) {
      colorTags.add(event.colorTag);
    }
    
    for (final association in associations) {
      colorTags.add(association.colorTag);
    }
    
    return colorTags.toList();
  }
}
