import 'package:flutter/material.dart';

import '../../domain/entities/calendar_event.dart';

/// Tile para mostrar un evento del calendario
class CalendarEventTile extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const CalendarEventTile({
    super.key,
    required this.event,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador de color
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: _getColorFromTag(event.colorTag),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Contenido del evento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Descripción
                    if (event.description != null && event.description!.isNotEmpty)
                      Text(
                        event.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Información adicional
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        // Tiempo
                        _buildInfoChip(
                          context,
                          icon: Icons.access_time,
                          label: _getTimeString(),
                        ),
                        
                        // Tipo de evento
                        _buildInfoChip(
                          context,
                          icon: event.type.iconData,
                          label: event.type.displayName,
                          color: Theme.of(context).primaryColor,
                        ),
                        
                        // Nota asociada
                        if (event.noteId != null)
                          _buildInfoChip(
                            context,
                            icon: Icons.note,
                            label: 'Con nota',
                            color: Colors.green,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Acciones
              if (showActions)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
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
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un chip de información
  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (color ?? Theme.of(context).primaryColor).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color ?? Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene la cadena de tiempo del evento
  String _getTimeString() {
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

    return 'Sin hora';
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
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
