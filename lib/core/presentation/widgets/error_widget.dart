import 'package:flutter/material.dart';

/// Widget de error reutilizable para toda la aplicación
class CustomErrorWidget extends StatelessWidget {
  /// Mensaje de error a mostrar
  final String message;
  
  /// Callback opcional para el botón de reintentar
  final VoidCallback? onRetry;
  
  /// Texto del botón de reintentar
  final String? retryText;
  
  /// Icono a mostrar con el error
  final IconData? icon;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText ?? 'Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de error específico para conexión de red
class NetworkErrorWidget extends StatelessWidget {
  /// Callback para el botón de reintentar
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      message: 'No hay conexión a internet.\nVerifica tu conexión y vuelve a intentar.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      retryText: 'Verificar conexión',
    );
  }
}

/// Widget de error genérico
class GenericErrorWidget extends StatelessWidget {
  /// Callback para el botón de reintentar
  final VoidCallback? onRetry;

  const GenericErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      message: 'Ha ocurrido un error inesperado.\nPor favor, inténtalo de nuevo.',
      icon: Icons.sentiment_dissatisfied,
      onRetry: onRetry,
    );
  }
}

/// Widget de error cuando no se encuentran datos
class EmptyDataWidget extends StatelessWidget {
  /// Mensaje personalizado
  final String? message;
  
  /// Callback para acción principal
  final VoidCallback? onAction;
  
  /// Texto del botón de acción
  final String? actionText;
  
  /// Icono a mostrar
  final IconData? icon;

  const EmptyDataWidget({
    super.key,
    this.message,
    this.onAction,
    this.actionText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'No hay datos disponibles',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText ?? 'Agregar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
