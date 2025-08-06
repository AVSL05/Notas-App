import 'package:flutter/material.dart';

import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/date_note_association.dart';

/// Widget que muestra los eventos del día seleccionado
class CalendarDayEvents extends StatelessWidget {
  final DateTime? selectedDate;
  final List<CalendarEvent> events;
  final List<DateNoteAssociation> notes;
  final bool isLoading;
  final ValueChanged<CalendarEvent>? onEventTap;
  final ValueChanged<CalendarEvent>? onEventEdit;
  final ValueChanged<CalendarEvent>? onEventDelete;

  const CalendarDayEvents({
    super.key,
    this.selectedDate,
    required this.events,
    required this.notes,
    this.isLoading = false,
    this.onEventTap,
    this.onEventEdit,
    this.onEventDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return const _EmptyState(
        message: 'Selecciona una fecha para ver los eventos',
        icon: Icons.calendar_today,
      );
    }

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con la fecha seleccionada
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
            child: Text(
              _formatSelectedDate(selectedDate!),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Lista de eventos y notas
          Expanded(
            child: _buildEventsList(context),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de eventos
  Widget _buildEventsList(BuildContext context) {
    if (events.isEmpty && notes.isEmpty) {
      return const _EmptyState(
        message: 'No hay eventos para esta fecha',
        icon: Icons.event_busy,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Eventos del calendario
        if (events.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Eventos (${events.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ...events.map((event) => _buildEventTile(context, event)),
        ],
        
        // Separador si hay eventos y notas
        if (events.isNotEmpty && notes.isNotEmpty)
          const Divider(height: 24),
        
        // Notas asociadas
        if (notes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Notas (${notes.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ...notes.map((note) => _buildNoteTile(context, note)),
        ],
      ],
    );
  }

  /// Construye el tile de un evento
  Widget _buildEventTile(BuildContext context, CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: ListTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getColorFromTag(event.colorTag),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null && event.description!.isNotEmpty)
              Text(
                event.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Text(_buildEventTimeString(event)),
            Text(
              event.type.displayName,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEventEdit?.call(event);
                break;
              case 'delete':
                onEventDelete?.call(event);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => onEventTap?.call(event),
      ),
    );
  }

  /// Construye el tile de una nota
  Widget _buildNoteTile(BuildContext context, DateNoteAssociation note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: ListTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getColorFromTag(note.colorTag),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          'Nota asociada', // TODO: Obtener título real de la nota
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prioridad: ${_getPriorityText(note.priority)}'),
            if (note.isCompleted)
              const Text(
                'Completada',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (note.isOverdue)
              const Text(
                'Vencida',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: note.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : note.isOverdue
                ? const Icon(Icons.warning, color: Colors.red)
                : null,
      ),
    );
  }

  /// Construye la cadena de tiempo para un evento
  String _buildEventTimeString(CalendarEvent event) {
    if (event.isAllDay) {
      return 'Todo el día';
    }

    if (event.startTime != null) {
      final startTime = _formatTime(event.startTime!);
      if (event.endTime != null) {
        final endTime = _formatTime(event.endTime!);
        return '$startTime - $endTime';
      }
      return startTime;
    }

    return 'Sin hora específica';
  }

  /// Formatea la fecha seleccionada
  String _formatSelectedDate(DateTime date) {
    const dayNames = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    const monthNames = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    final dayName = dayNames[date.weekday - 1];
    final monthName = monthNames[date.month - 1];
    
    return '$dayName, ${date.day} de $monthName de ${date.year}';
  }

  /// Formatea una hora
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
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

  /// Obtiene el texto de prioridad
  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Baja';
      case 2:
        return 'Media';
      case 3:
        return 'Alta';
      default:
        return 'Sin definir';
    }
  }
}

/// Widget para estados vacíos
class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
