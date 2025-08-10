import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../domain/entities/dashboard_summary.dart';

/// Grid de acciones rápidas del dashboard
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final Function(QuickActionType) onActionTap;
  final Function(QuickAction)? onActionLongPress;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
    this.onActionLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final enabledActions = actions.where((action) => action.isEnabled).toList();
    
    if (enabledActions.isEmpty) {
      return _buildEmptyState(context);
    }

    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: enabledActions.map((action) {
        final index = enabledActions.indexOf(action);
        return StaggeredGridTile.count(
          crossAxisCellCount: _getCrossAxisCount(index, enabledActions.length),
          mainAxisCellCount: 1,
          child: _QuickActionCard(
            action: action,
            onTap: () => onActionTap(action.type),
            onLongPress: onActionLongPress != null 
                ? () => onActionLongPress!(action)
                : null,
          ),
        );
      }).toList(),
    );
  }

  /// Determina el número de celdas en el eje cruzado para la disposición staggered
  int _getCrossAxisCount(int index, int totalItems) {
    // Patrón: primera fila tiene dos acciones (1,1), segunda fila una acción ancha (2)
    // Luego se repite el patrón
    final position = index % 3;
    if (position == 0 || position == 1) {
      return 1; // Acción normal (ocupa 1 celda)
    } else {
      return 2; // Acción ancha (ocupa 2 celdas)
    }
  }

  /// Construye el estado vacío cuando no hay acciones
  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.touch_app_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay acciones rápidas disponibles',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Configura tus acciones rápidas favoritas',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget individual para una acción rápida
class _QuickActionCard extends StatelessWidget {
  final QuickAction action;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _QuickActionCard({
    required this.action,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(int.parse('0xFF${action.colorHex.substring(1)}'));
    
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  IconData(
                    int.parse(action.iconCodePoint),
                    fontFamily: 'MaterialIcons',
                  ),
                  color: color,
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Título
              Text(
                action.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Descripción
              Text(
                action.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
