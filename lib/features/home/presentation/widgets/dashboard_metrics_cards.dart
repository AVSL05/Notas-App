import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_summary.dart';

/// Widget de tarjetas de métricas del dashboard
class DashboardMetricsCards extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardMetricsCards({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fila superior: Notas y Tareas
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Notas',
                value: summary.totalNotes.toString(),
                subtitle: _getNotesSubtitle(),
                icon: Icons.note,
                color: Colors.blue,
                onTap: () => _handleNotesCardTap(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                title: 'Tareas',
                value: summary.totalTasks.toString(),
                subtitle: _getTasksSubtitle(),
                icon: Icons.task_alt,
                color: Colors.orange,
                onTap: () => _handleTasksCardTap(context),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Fila inferior: Productividad
        _ProductivityCard(summary: summary),
        
        const SizedBox(height: 12),
        
        // Fila de métricas adicionales
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Favoritas',
                value: summary.favoriteNotes.toString(),
                subtitle: 'notas marcadas',
                icon: Icons.favorite,
                color: Colors.red,
                isCompact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                title: 'Recordatorios',
                value: summary.upcomingReminders.toString(),
                subtitle: 'próximos',
                icon: Icons.alarm,
                color: Colors.purple,
                isCompact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                title: 'Eventos',
                value: summary.todayEvents.toString(),
                subtitle: 'hoy',
                icon: Icons.event,
                color: Colors.green,
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getNotesSubtitle() {
    if (summary.pinnedNotes > 0) {
      return '${summary.pinnedNotes} fijadas';
    } else if (summary.archivedNotes > 0) {
      return '${summary.archivedNotes} archivadas';
    }
    return 'total';
  }

  String _getTasksSubtitle() {
    if (summary.totalTasks == 0) return 'ninguna';
    if (summary.completedTasks == summary.totalTasks) return 'todas completadas';
    return '${summary.completedTasks} completadas';
  }

  void _handleNotesCardTap(BuildContext context) {
    // TODO: Navegar a la vista de notas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegar a notas - próximamente')),
    );
  }

  void _handleTasksCardTap(BuildContext context) {
    // TODO: Navegar a la vista de tareas
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegar a tareas - próximamente')),
    );
  }
}

/// Widget individual para una métrica
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isCompact;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isCompact ? 6 : 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: isCompact ? 16 : 20,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                ],
              ),
              
              SizedBox(height: isCompact ? 8 : 12),
              
              Text(
                value,
                style: (isCompact 
                    ? theme.textTheme.headlineSmall 
                    : theme.textTheme.headlineMedium)?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                title,
                style: (isCompact 
                    ? theme.textTheme.bodySmall 
                    : theme.textTheme.bodyMedium)?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              Text(
                subtitle,
                style: (isCompact 
                    ? theme.textTheme.bodySmall 
                    : theme.textTheme.bodySmall)?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget especializado para la tarjeta de productividad
class _ProductivityCard extends StatelessWidget {
  final DashboardSummary summary;

  const _ProductivityCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = summary.productivityLevel;
    final percentage = summary.completionPercentage;
    final color = Color(int.parse('0xFF${level.colorHex.substring(1)}'));
    
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleProductivityTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Productividad',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          level.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    level.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Barra de progreso
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: level.value,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
              
              if (summary.totalTasks > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '${summary.completedTasks} de ${summary.totalTasks} tareas completadas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleProductivityTap(BuildContext context) {
    // TODO: Navegar a vista detallada de productividad
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vista detallada de productividad - próximamente')),
    );
  }
}
