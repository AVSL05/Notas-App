import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';

/// Widget que muestra una tarjeta individual de nota
class NoteCard extends StatelessWidget {
  final Note note;
  final bool isCompact;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    this.isCompact = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Determinar el color de la tarjeta basado en el colorTag
    Color cardColor = _getCardColor(colorScheme);
    
    return Card(
      elevation: 2,
      color: cardColor,
      child: InkWell(
        onTap: onTap ?? () => _navigateToNoteDetail(context),
        onLongPress: onLongPress ?? () => _showNoteOptions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y badges
              _buildHeader(context),
              
              if (!isCompact) const SizedBox(height: 8),
              
              // Contenido de la nota
              _buildContent(context),
              
              const Spacer(),
              
              // Footer con información adicional
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Título
        Expanded(
          child: Text(
            note.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isCompact ? 14 : 16,
            ),
            maxLines: isCompact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Badges
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.isPinned)
              Icon(
                Icons.push_pin,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            if (note.isFavorite)
              Icon(
                Icons.favorite,
                size: 16,
                color: Colors.red,
              ),
            if (note.reminderDate != null)
              Icon(
                Icons.alarm,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contenido de texto
        if (note.content.isNotEmpty)
          Text(
            note.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isCompact ? 12 : 14,
            ),
            maxLines: isCompact ? 2 : 4,
            overflow: TextOverflow.ellipsis,
          ),
        
        // Tareas si las hay
        if (note.tasks.isNotEmpty && !isCompact)
          _buildTasksPreview(context),
        
        // Tags si los hay
        if (note.tags.isNotEmpty && !isCompact)
          _buildTagsPreview(context),
      ],
    );
  }

  Widget _buildTasksPreview(BuildContext context) {
    final completedTasks = note.tasks.where((task) => task.isCompleted).length;
    final totalTasks = note.tasks.length;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '$completedTasks/$totalTasks tareas',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsPreview(BuildContext context) {
    if (note.tags.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 4.0,
        children: note.tags.take(2).map((tag) => Chip(
          label: Text(
            tag,
            style: const TextStyle(fontSize: 10),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        )).toList(),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Categoría
        if (note.category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              note.category!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 10,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        
        // Fecha de actualización
        Text(
          _formatDate(note.updatedAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: isCompact ? 10 : 12,
          ),
        ),
      ],
    );
  }

  Color _getCardColor(ColorScheme colorScheme) {
    if (note.colorTag == null) return colorScheme.surface;
    
    switch (note.colorTag) {
      case '#F44336': // Rojo
        return Colors.red.shade50;
      case '#E91E63': // Rosa
        return Colors.pink.shade50;
      case '#9C27B0': // Púrpura
        return Colors.purple.shade50;
      case '#673AB7': // Violeta
        return Colors.deepPurple.shade50;
      case '#3F51B5': // Índigo
        return Colors.indigo.shade50;
      case '#2196F3': // Azul
        return Colors.blue.shade50;
      case '#03A9F4': // Azul claro
        return Colors.lightBlue.shade50;
      case '#00BCD4': // Cian
        return Colors.cyan.shade50;
      case '#009688': // Verde azulado
        return Colors.teal.shade50;
      case '#4CAF50': // Verde
        return Colors.green.shade50;
      case '#8BC34A': // Verde claro
        return Colors.lightGreen.shade50;
      case '#CDDC39': // Lima
        return Colors.lime.shade50;
      case '#FFEB3B': // Amarillo
        return Colors.yellow.shade50;
      case '#FFC107': // Ámbar
        return Colors.amber.shade50;
      case '#FF9800': // Naranja
        return Colors.orange.shade50;
      case '#FF5722': // Naranja profundo
        return Colors.deepOrange.shade50;
      default:
        return colorScheme.surface;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Ahora';
        }
        return '${difference.inMinutes}m';
      }
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  void _navigateToNoteDetail(BuildContext context) {
    // TODO: Implementar navegación a la página de detalle de nota
    print('Navegar a detalle de nota: ${note.id}');
  }

  void _showNoteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? 'Desfijar' : 'Fijar'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar toggle pin
              },
            ),
            ListTile(
              leading: Icon(note.isFavorite ? Icons.favorite : Icons.favorite_border),
              title: Text(note.isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar toggle favorite
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archivar'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar archive
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar delete
              },
            ),
          ],
        ),
      ),
    );
  }
}
