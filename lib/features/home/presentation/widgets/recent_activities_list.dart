import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_summary.dart';

/// Lista de actividades recientes
class RecentActivitiesList extends StatelessWidget {
  final List<RecentActivity> activities;
  final bool isCompact;
  final Function(RecentActivity)? onActivityTap;

  const RecentActivitiesList({
    super.key,
    required this.activities,
    this.isCompact = false,
    this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: isCompact ? const NeverScrollableScrollPhysics() : null,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _ActivityTile(
          activity: activities[index],
          isCompact: isCompact,
          onTap: onActivityTap,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay actividades recientes',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus acciones aparecerán aquí',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget individual para una actividad
class _ActivityTile extends StatelessWidget {
  final RecentActivity activity;
  final bool isCompact;
  final Function(RecentActivity)? onTap;

  const _ActivityTile({
    required this.activity,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(int.parse('0xFF${activity.type.colorHex.substring(1)}'));
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        dense: isCompact,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isCompact ? 4 : 8,
        ),
        
        // Icono de la actividad
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            IconData(
              int.parse(activity.type.iconCodePoint),
              fontFamily: 'MaterialIcons',
            ),
            color: color,
            size: 20,
          ),
        ),
        
        // Contenido principal
        title: Text(
          activity.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: isCompact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Tipo de actividad
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    activity.type.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Tiempo transcurrido
                Text(
                  activity.timeAgo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                
                // Indicador de hoy
                if (activity.isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        
        // Acción para elementos relacionados
        trailing: activity.relatedItemId != null && onTap != null
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              )
            : null,
        
        onTap: onTap != null ? () => onTap!(activity) : null,
      ),
    );
  }
}
