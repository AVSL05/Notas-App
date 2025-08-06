import 'package:equatable/equatable.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/date_note_association.dart';
import 'calendar_event.dart';

/// Estados base para el CalendarBloc
abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial del calendario
class CalendarInitial extends CalendarState {}

/// Estado de carga
class CalendarLoading extends CalendarState {}

/// Estado cuando se están cargando datos específicos
class CalendarLoadingSpecific extends CalendarState {
  final String loadingType;

  const CalendarLoadingSpecific(this.loadingType);

  @override
  List<Object?> get props => [loadingType];
}

/// Estado con datos cargados exitosamente
class CalendarLoaded extends CalendarState {
  final DateTime selectedDate;
  final CalendarViewType viewType;
  final List<CalendarEvent> events;
  final List<DateNoteAssociation> associations;
  final Map<DateTime, List<CalendarEvent>> eventsByDate;
  final Map<DateTime, List<DateNoteAssociation>> associationsByDate;
  final List<String> availableColorTags;
  final Map<String, dynamic> settings;
  final Map<String, dynamic>? statistics;
  final String? searchQuery;
  final CalendarEventType? typeFilter;
  final int? priorityFilter;
  final bool? completionFilter;

  const CalendarLoaded({
    required this.selectedDate,
    required this.viewType,
    required this.events,
    required this.associations,
    required this.eventsByDate,
    required this.associationsByDate,
    required this.availableColorTags,
    required this.settings,
    this.statistics,
    this.searchQuery,
    this.typeFilter,
    this.priorityFilter,
    this.completionFilter,
  });

  /// Crea una copia del estado con campos modificados
  CalendarLoaded copyWith({
    DateTime? selectedDate,
    CalendarViewType? viewType,
    List<CalendarEvent>? events,
    List<DateNoteAssociation>? associations,
    Map<DateTime, List<CalendarEvent>>? eventsByDate,
    Map<DateTime, List<DateNoteAssociation>>? associationsByDate,
    List<String>? availableColorTags,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? statistics,
    String? searchQuery,
    CalendarEventType? typeFilter,
    int? priorityFilter,
    bool? completionFilter,
    bool clearSearch = false,
    bool clearTypeFilter = false,
    bool clearPriorityFilter = false,
    bool clearCompletionFilter = false,
  }) {
    return CalendarLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      viewType: viewType ?? this.viewType,
      events: events ?? this.events,
      associations: associations ?? this.associations,
      eventsByDate: eventsByDate ?? this.eventsByDate,
      associationsByDate: associationsByDate ?? this.associationsByDate,
      availableColorTags: availableColorTags ?? this.availableColorTags,
      settings: settings ?? this.settings,
      statistics: statistics ?? this.statistics,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      priorityFilter: clearPriorityFilter ? null : (priorityFilter ?? this.priorityFilter),
      completionFilter: clearCompletionFilter ? null : (completionFilter ?? this.completionFilter),
    );
  }

  /// Obtiene eventos para la fecha seleccionada
  List<CalendarEvent> get eventsForSelectedDate {
    final dateKey = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return eventsByDate[dateKey] ?? [];
  }

  /// Obtiene asociaciones para la fecha seleccionada
  List<DateNoteAssociation> get associationsForSelectedDate {
    final dateKey = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return associationsByDate[dateKey] ?? [];
  }

  /// Obtiene eventos filtrados
  List<CalendarEvent> get filteredEvents {
    List<CalendarEvent> filtered = events;

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((event) =>
          event.title.toLowerCase().contains(query) ||
          (event.description?.toLowerCase().contains(query) ?? false)).toList();
    }

    if (typeFilter != null) {
      filtered = filtered.where((event) => event.type == typeFilter).toList();
    }

    return filtered;
  }

  /// Obtiene asociaciones filtradas
  List<DateNoteAssociation> get filteredAssociations {
    List<DateNoteAssociation> filtered = associations;

    if (priorityFilter != null) {
      filtered = filtered.where((association) => association.priority == priorityFilter).toList();
    }

    if (completionFilter != null) {
      filtered = filtered.where((association) => association.isCompleted == completionFilter).toList();
    }

    return filtered;
  }

  /// Verifica si hay filtros activos
  bool get hasActiveFilters {
    return searchQuery != null || 
           typeFilter != null || 
           priorityFilter != null || 
           completionFilter != null;
  }

  /// Obtiene el número total de elementos para la fecha seleccionada
  int get totalItemsForSelectedDate {
    return eventsForSelectedDate.length + associationsForSelectedDate.length;
  }

  /// Obtiene eventos de todo el día para la fecha seleccionada
  List<CalendarEvent> get allDayEventsForSelectedDate {
    return eventsForSelectedDate.where((event) => event.isAllDay).toList();
  }

  /// Obtiene eventos con hora para la fecha seleccionada
  List<CalendarEvent> get timedEventsForSelectedDate {
    return eventsForSelectedDate.where((event) => !event.isAllDay).toList();
  }

  /// Obtiene asociaciones pendientes para la fecha seleccionada
  List<DateNoteAssociation> get pendingAssociationsForSelectedDate {
    return associationsForSelectedDate.where((association) => !association.isCompleted).toList();
  }

  /// Obtiene asociaciones completadas para la fecha seleccionada
  List<DateNoteAssociation> get completedAssociationsForSelectedDate {
    return associationsForSelectedDate.where((association) => association.isCompleted).toList();
  }

  @override
  List<Object?> get props => [
        selectedDate,
        viewType,
        events,
        associations,
        eventsByDate,
        associationsByDate,
        availableColorTags,
        settings,
        statistics,
        searchQuery,
        typeFilter,
        priorityFilter,
        completionFilter,
      ];
}

/// Estado de error
class CalendarError extends CalendarState {
  final String message;
  final String? errorCode;
  final dynamic exception;

  const CalendarError({
    required this.message,
    this.errorCode,
    this.exception,
  });

  @override
  List<Object?> get props => [message, errorCode, exception];
}

/// Estado de operación exitosa
class CalendarOperationSuccess extends CalendarState {
  final String message;
  final String operationType;
  final dynamic data;

  const CalendarOperationSuccess({
    required this.message,
    required this.operationType,
    this.data,
  });

  @override
  List<Object?> get props => [message, operationType, data];
}

/// Estado cuando se crea un evento exitosamente
class CalendarEventCreated extends CalendarOperationSuccess {
  final CalendarEvent event;

  const CalendarEventCreated(this.event)
      : super(
          message: 'Evento creado exitosamente',
          operationType: 'create_event',
          data: event,
        );

  @override
  List<Object?> get props => [event];
}

/// Estado cuando se actualiza un evento exitosamente
class CalendarEventUpdated extends CalendarOperationSuccess {
  final CalendarEvent event;

  const CalendarEventUpdated(this.event)
      : super(
          message: 'Evento actualizado exitosamente',
          operationType: 'update_event',
          data: event,
        );

  @override
  List<Object?> get props => [event];
}

/// Estado cuando se elimina un evento exitosamente
class CalendarEventDeleted extends CalendarOperationSuccess {
  final String eventId;

  const CalendarEventDeleted(this.eventId)
      : super(
          message: 'Evento eliminado exitosamente',
          operationType: 'delete_event',
          data: eventId,
        );

  @override
  List<Object?> get props => [eventId];
}

/// Estado cuando se crea una asociación exitosamente
class CalendarAssociationCreated extends CalendarOperationSuccess {
  final DateNoteAssociation association;

  const CalendarAssociationCreated(this.association)
      : super(
          message: 'Asociación creada exitosamente',
          operationType: 'create_association',
          data: association,
        );

  @override
  List<Object?> get props => [association];
}

/// Estado cuando se actualiza una asociación exitosamente
class CalendarAssociationUpdated extends CalendarOperationSuccess {
  final DateNoteAssociation association;

  const CalendarAssociationUpdated(this.association)
      : super(
          message: 'Asociación actualizada exitosamente',
          operationType: 'update_association',
          data: association,
        );

  @override
  List<Object?> get props => [association];
}

/// Estado cuando se elimina una asociación exitosamente
class CalendarAssociationDeleted extends CalendarOperationSuccess {
  final String associationId;

  const CalendarAssociationDeleted(this.associationId)
      : super(
          message: 'Asociación eliminada exitosamente',
          operationType: 'delete_association',
          data: associationId,
        );

  @override
  List<Object?> get props => [associationId];
}

/// Estado cuando se agregan datos a la cache local (para optimización)
class CalendarDataCached extends CalendarState {
  final String cacheType;
  final int itemCount;

  const CalendarDataCached({
    required this.cacheType,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [cacheType, itemCount];
}
