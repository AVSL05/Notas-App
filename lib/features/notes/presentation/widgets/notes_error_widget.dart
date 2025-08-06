import 'package:flutter/material.dart';

/// Widget que muestra errores relacionados con las notas
class NotesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? errorCode;
  final bool showDetails;

  const NotesErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.errorCode,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de error
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Título del error
            Text(
              'Algo salió mal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Mensaje de error
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            
            // Código de error (si se proporciona)
            if (errorCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Código: $errorCode',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Botones de acción
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                
                if (onRetry != null && showDetails) const SizedBox(width: 12),
                
                if (showDetails)
                  OutlinedButton.icon(
                    onPressed: () => _showErrorDetails(context),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Detalles'),
                  ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Sugerencias
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Posibles soluciones:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    _SuggestionItem(
                      text: 'Verifica tu conexión a internet',
                      icon: Icons.wifi_off,
                    ),
                    const SizedBox(height: 8),
                    _SuggestionItem(
                      text: 'Cierra y vuelve a abrir la aplicación',
                      icon: Icons.refresh,
                    ),
                    const SizedBox(height: 8),
                    _SuggestionItem(
                      text: 'Verifica que tengas espacio suficiente',
                      icon: Icons.storage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del error'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mensaje:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(message),
              
              if (errorCode != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Código:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  errorCode!,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
              
              const SizedBox(height: 16),
              Text(
                'Tiempo:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(DateTime.now().toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar reporte de error
            },
            child: const Text('Reportar'),
          ),
        ],
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final String text;
  final IconData icon;

  const _SuggestionItem({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Variación más pequeña del widget de error para usar en contextos compactos
class CompactNotesErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const CompactNotesErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reintentar',
            ),
          ],
        ],
      ),
    );
  }
}
