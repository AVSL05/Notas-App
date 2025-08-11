part of 'dashboard_bloc.dart';

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

/// Evento para ejecutar una acción rápida
class ExecuteQuickAction extends DashboardEvent {
  final QuickAction action;

  const ExecuteQuickAction({required this.action});

  @override
  List<Object?> get props => [action];
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

/// Evento para registrar una nueva actividad
class RecordActivityEvent extends DashboardEvent {
  final ActivityType type;
  final String title;
  final String description;
  final String? entityId;
  final Map<String, dynamic>? metadata;

  const RecordActivityEvent({
    required this.type,
    required this.title,
    required this.description,
    this.entityId,
    this.metadata,
  });

  @override
  List<Object?> get props => [type, title, description, entityId, metadata];
}

/// Evento para limpiar actividades antiguas
class CleanupOldActivitiesEvent extends DashboardEvent {
  const CleanupOldActivitiesEvent();
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

