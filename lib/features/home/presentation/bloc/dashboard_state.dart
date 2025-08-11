part of 'dashboard_bloc.dart';

/// Estados del BLoC del dashboard
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial del dashboard
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Estado de carga del dashboard
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Estado de carga exitosa del dashboard
class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;
  final List<QuickAction> quickActions;
  final List<RecentActivity> recentActivities;
  final Map<String, dynamic> settings;

  const DashboardLoaded({
    required this.summary,
    required this.quickActions,
    required this.recentActivities,
    required this.settings,
  });

  /// Verifica si hay datos para mostrar
  bool get hasData =>
      summary.totalNotes > 0 ||
      summary.completedTasks > 0 || // Se debe usar completedTasks o una métrica similar
      recentActivities.isNotEmpty;

  /// Obtiene el saludo basado en la hora del día
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días!';
    if (hour < 18) return '¡Buenas tardes!';
    return '¡Buenas noches!';
  }

  /// Obtiene mensaje motivacional basado en productividad
  String get motivationalMessage {
    switch (summary.productivityLevel) {
      case ProductivityLevel.low:
        return 'Un pequeño paso puede hacer una gran diferencia.';
      case ProductivityLevel.medium:
        return '¡Buen trabajo! Sigue así.';
      case ProductivityLevel.high:
        return '¡Estás en racha! Excelente progreso.';
      case ProductivityLevel.excellent:
        return '¡Imparable! Estás superando todas las expectativas.';
      default:
        return 'Comienza a organizar tu día para ver tu progreso.';
    }
  }

  /// Obtiene el color asociado a un nivel de productividad
  Color getProductivityColor(ProductivityLevel level) {
    switch (level) {
      case ProductivityLevel.low:
        return Colors.red;
      case ProductivityLevel.medium:
        return Colors.orange;
      case ProductivityLevel.high:
        return Colors.blue;
      case ProductivityLevel.excellent:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  List<Object?> get props => [
        summary,
        quickActions,
        recentActivities,
        settings,
      ];

  /// Crea una copia con valores modificados
  DashboardLoaded copyWith({
    DashboardSummary? summary,
    List<QuickAction>? quickActions,
    List<RecentActivity>? recentActivities,
    Map<String, dynamic>? settings,
  }) {
    return DashboardLoaded(
      summary: summary ?? this.summary,
      quickActions: quickActions ?? this.quickActions,
      recentActivities: recentActivities ?? this.recentActivities,
      settings: settings ?? this.settings,
    );
  }
}

/// Estado de error del dashboard
class DashboardError extends DashboardState {
  final String message;
  final String? details;

  const DashboardError({
    required this.message,
    this.details,
  });

  @override
  List<Object?> get props => [message, details];
}

/// Estado de actualización de métricas
class DashboardUpdatingMetrics extends DashboardState {
  final DashboardSummary currentSummary;

  const DashboardUpdatingMetrics({
    required this.currentSummary,
  });

  @override
  List<Object?> get props => [currentSummary];
}

/// Estado de actualización de configuraciones
class DashboardUpdatingSettings extends DashboardState {
  final Map<String, dynamic> currentSettings;

  const DashboardUpdatingSettings({
    required this.currentSettings,
  });

  @override
  List<Object?> get props => [currentSettings];
}

/// Estado cuando se está registrando una actividad
class DashboardRecordingActivity extends DashboardState {
  final RecentActivity activity;

  const DashboardRecordingActivity({
    required this.activity,
  });

  @override
  List<Object?> get props => [activity];
}

/// Estado de limpieza de datos
class DashboardCleaningUp extends DashboardState {
  const DashboardCleaningUp();
}

/// Estado de exportación de datos
class DashboardExporting extends DashboardState {
  const DashboardExporting();
}

/// Estado de exportación exitosa
class DashboardExported extends DashboardState {
  final Map<String, dynamic> exportedData;

  const DashboardExported({
    required this.exportedData,
  });

  @override
  List<Object?> get props => [exportedData];
}

/// Estado de importación de datos
class DashboardImporting extends DashboardState {
  const DashboardImporting();
}

/// Estado de importación exitosa
class DashboardImported extends DashboardState {
  const DashboardImported();
}

/// Estado de obtención de estadísticas de productividad
class DashboardLoadingStats extends DashboardState {
  const DashboardLoadingStats();
}

/// Estado con estadísticas de productividad cargadas
class DashboardStatsLoaded extends DashboardState {
  final Map<String, dynamic> stats;
  final DateTime startDate;
  final DateTime endDate;

  const DashboardStatsLoaded({
    required this.stats,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [stats, startDate, endDate];
}
