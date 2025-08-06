import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/calendar_event.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';
import '../bloc/calendar_event.dart';
import '../widgets/calendar_day_events.dart';
import '../widgets/event_creation_dialog.dart';

/// Página principal del calendario
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CalendarBloc>()
        ..add(CalendarDateChanged(DateTime.now())),
      child: const CalendarView(),
    );
  }
}

/// Vista principal del calendario
class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              context.read<CalendarBloc>().add(CalendarDateChanged(DateTime.now()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CalendarInitial || state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CalendarError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CalendarBloc>().add(CalendarDateChanged(DateTime.now()));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is CalendarLoaded) {
            return Column(
              children: [
                // Widget del calendario
                Expanded(
                  flex: 2,
                  child: TableCalendar<CalendarEvent>(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) => _getEventsForDay(state, day),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: _buildCalendarStyle(context),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(day, state.selectedDate);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<CalendarBloc>().add(
                        CalendarDateChanged(selectedDay),
                      );
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return null;
                        
                        return Positioned(
                          bottom: 1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: events.take(3).map((event) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _getColorFromTag(event.colorTag),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Lista de eventos del día seleccionado
                Expanded(
                  flex: 1,
                  child: CalendarDayEvents(
                    selectedDate: state.selectedDate,
                    events: state.eventsByDate[DateTime(
                      state.selectedDate.year,
                      state.selectedDate.month,
                      state.selectedDate.day,
                    )] ?? [],
                    notes: state.associationsByDate[DateTime(
                      state.selectedDate.year,
                      state.selectedDate.month,
                      state.selectedDate.day,
                    )] ?? [],
                    isLoading: false,
                    onEventTap: (event) => _showEventDetails(context, event),
                    onEventEdit: (event) => _showEditEventDialog(context, event),
                    onEventDelete: (event) => _showDeleteConfirmation(context, event),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEventDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Obtiene los eventos para un día específico
  List<CalendarEvent> _getEventsForDay(CalendarLoaded state, DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    return state.eventsByDate[dayKey] ?? [];
  }

  /// Construye el estilo del calendario
  CalendarStyle _buildCalendarStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    return CalendarStyle(
      todayDecoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: theme.primaryColor,
        shape: BoxShape.circle,
      ),
      weekendTextStyle: TextStyle(
        color: theme.colorScheme.error,
      ),
      outsideDaysVisible: false,
      markersMaxCount: 3,
    );
  }

  /// Obtiene el color basado en la etiqueta
  Color _getColorFromTag(String colorTag) {
    switch (colorTag.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  /// Muestra el diálogo de creación de evento
  void _showCreateEventDialog(BuildContext context) {
    final bloc = context.read<CalendarBloc>();
    final state = bloc.state;
    final selectedDate = state is CalendarLoaded ? state.selectedDate : DateTime.now();
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: EventCreationDialog(
          initialDate: selectedDate,
          onEventCreated: (event) {
            bloc.add(CalendarCreateEvent(event));
          },
        ),
      ),
    );
  }

  /// Muestra el diálogo de edición de evento
  void _showEditEventDialog(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CalendarBloc>(),
        child: EventCreationDialog(
          initialDate: event.date,
          initialEvent: event,
          onEventCreated: (updatedEvent) {
            context.read<CalendarBloc>().add(CalendarUpdateEvent(updatedEvent));
          },
        ),
      ),
    );
  }

  /// Muestra los detalles de un evento
  void _showEventDetails(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null) ...[
              Text('Descripción:'),
              Text(event.description!),
              const SizedBox(height: 8),
            ],
            Text('Fecha: ${_formatDate(event.date)}'),
            if (!event.isAllDay && event.startTime != null) ...[
              Text('Hora: ${_formatTime(event.startTime!)}'),
              if (event.endTime != null)
                Text('Hasta: ${_formatTime(event.endTime!)}'),
            ],
            Text('Tipo: ${event.type.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditEventDialog(context, event);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  /// Muestra la confirmación de eliminación
  void _showDeleteConfirmation(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar evento'),
        content: Text('¿Estás seguro de que quieres eliminar "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CalendarBloc>().add(CalendarDeleteEvent(event.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de filtros
  void _showFilterDialog(BuildContext context) {
    // TODO: Implementar diálogo de filtros
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de filtros próximamente')),
    );
  }

  /// Muestra el diálogo de configuraciones
  void _showSettingsDialog(BuildContext context) {
    // TODO: Implementar diálogo de configuraciones
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuraciones próximamente')),
    );
  }

  /// Formatea una fecha
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Formatea una hora
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
