import 'package:flutter/material.dart';

/// Widget de carga reutilizable para toda la aplicación
class LoadingWidget extends StatelessWidget {
  /// Mensaje opcional a mostrar debajo del indicador de carga
  final String? message;
  
  /// Color del indicador de progreso
  final Color? color;
  
  /// Tamaño del indicador de progreso
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? Theme.of(context).primaryColor,
              strokeWidth: 3.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget de carga pequeño para usar en botones o espacios reducidos
class SmallLoadingWidget extends StatelessWidget {
  /// Color del indicador de progreso
  final Color? color;
  
  /// Tamaño del indicador de progreso
  final double size;

  const SmallLoadingWidget({
    super.key,
    this.color,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).primaryColor,
        strokeWidth: 2.0,
      ),
    );
  }
}

/// Widget de carga con overlay semitransparente
class OverlayLoadingWidget extends StatelessWidget {
  /// Si mostrar el overlay de fondo
  final bool showOverlay;
  
  /// Mensaje opcional a mostrar
  final String? message;
  
  /// Color del overlay
  final Color? overlayColor;

  const OverlayLoadingWidget({
    super.key,
    this.showOverlay = true,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    final child = LoadingWidget(message: message);
    
    if (!showOverlay) return child;
    
    return Container(
      color: overlayColor ?? Colors.black.withOpacity(0.3),
      child: child,
    );
  }
}
