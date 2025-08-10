part of 'dashboard_bloc.dart';

/// Eventos del BLoC del dashboard
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar el dashboard
class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

/// Evento para refrescar el dashboard
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

/// Evento para actualizar las métricas del dashboard
class UpdateDashboardMetrics extends DashboardEvent {
  const UpdateDashboardMetrics();
}

/// Evento para actualizar las acciones rápidas
class UpdateQuickActions extends DashboardEvent {
  final List<QuickAction> actions;

  const UpdateQuickActions({
    required this.actions,
  });

  @override
  List<Object?> get props => [actions];
}

/// Evento para registrar una nueva actividad
class RecordDashboardActivity extends DashboardEvent {
  final ActivityType type;
  final String title;
  final String description;
  final String? relatedItemId;
  final Map<String, dynamic>? metadata;

  const RecordDashboardActivity({
    required this.type,
    required this.title,
    required this.description,
    this.relatedItemId,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        type,
        title,
        description,
        relatedItemId,
        metadata,
      ];
}

/// Evento para obtener actividades recientes
class LoadRecentActivities extends DashboardEvent {
  final int limit;

  const LoadRecentActivities({
    this.limit = 10,
  });

  @override
  List<Object?> get props => [limit];
}

/// Evento para limpiar actividades antiguas
class CleanupOldActivities extends DashboardEvent {
  const CleanupOldActivities();
}

/// Evento para actualizar configuraciones del dashboard
class UpdateDashboardSettings extends DashboardEvent {
  final Map<String, dynamic> settings;

  const UpdateDashboardSettings({
    required this.settings,
  });

  @override
  List<Object?> get props => [settings];
}

/// Evento para obtener configuraciones del dashboard
class LoadDashboardSettings extends DashboardEvent {
  const LoadDashboardSettings();
}

/// Evento para exportar datos del dashboard
class ExportDashboardData extends DashboardEvent {
  const ExportDashboardData();
}

/// Evento para importar datos del dashboard
class ImportDashboardData extends DashboardEvent {
  final Map<String, dynamic> data;

  const ImportDashboardData({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

/// Evento para reiniciar datos del dashboard
class ResetDashboardData extends DashboardEvent {
  const ResetDashboardData();
}

/// Evento para obtener estadísticas de productividad
class LoadProductivityStats extends DashboardEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadProductivityStats({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Evento para ejecutar una acción rápida
class ExecuteQuickAction extends DashboardEvent {
  final QuickActionType actionType;
  final Map<String, dynamic>? parameters;

  const ExecuteQuickAction({
    required this.actionType,
    this.parameters,
  });

  @override
  List<Object?> get props => [actionType, parameters];
}

/// Evento para reordenar acciones rápidas
class ReorderQuickActions extends DashboardEvent {
  final List<QuickAction> reorderedActions;

  const ReorderQuickActions({
    required this.reorderedActions,
  });

  @override
  List<Object?> get props => [reorderedActions];
}

/// Evento para toggle de habilitación de una acción rápida
class ToggleQuickAction extends DashboardEvent {
  final String actionId;
  final bool isEnabled;

  const ToggleQuickAction({
    required this.actionId,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [actionId, isEnabled];
}

/// Evento para filtrar actividades por tipo
class FilterActivitiesByType extends DashboardEvent {
  final ActivityType? filterType;

  const FilterActivitiesByType({
    this.filterType,
  });

  @override
  List<Object?> get props => [filterType];
}

/// Evento para buscar en actividades recientes
class SearchRecentActivities extends DashboardEvent {
  final String query;

  const SearchRecentActivities({
    required this.query,
  });

  @override
  List<Object?> get props => [query];
}
