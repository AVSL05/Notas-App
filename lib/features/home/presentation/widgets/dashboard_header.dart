import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Widget del encabezado del dashboard
class DashboardHeader extends StatelessWidget {
  final DashboardSummary summary;

  const DashboardHeader({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo principal
            Text(
              summary.greeting,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Mensaje motivacional
            Text(
              summary.motivationalMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Indicador de estado
            Row(
              children: [
                Icon(
                  summary.hasData ? Icons.check_circle : Icons.info_outline,
                  size: 16,
                  color: summary.hasData ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  summary.hasData 
                      ? 'Todo al día' 
                      : 'Comienza creando tu primera nota',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: summary.hasData ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
