import '../entities/dashboard_summary.dart';

/// Repository abstracto para gestionar datos del dashboard
abstract class DashboardRepository {
  /// Obtiene el resumen actual del dashboard
  Future<DashboardSummary> getDashboardSummary();

  /// Actualiza las métricas del dashboard
  Future<void> updateDashboardMetrics();

  /// Obtiene las acciones rápidas configuradas
  Future<List<QuickAction>> getQuickActions();

  /// Actualiza las acciones rápidas
  Future<void> updateQuickActions(List<QuickAction> actions);

  /// Obtiene las actividades recientes
  Future<List<RecentActivity>> getRecentActivities({int limit = 10});

  /// Registra una nueva actividad
  Future<void> recordActivity(RecentActivity activity);

  /// Limpia actividades antiguas (más de 30 días)
  Future<void> cleanupOldActivities();

  /// Obtiene configuraciones del dashboard
  Future<Map<String, dynamic>> getDashboardSettings();

  /// Actualiza configuraciones del dashboard
  Future<void> updateDashboardSettings(Map<String, dynamic> settings);

  /// Exporta datos del dashboard para backup
  Future<Map<String, dynamic>> exportDashboardData();

  /// Importa datos del dashboard desde backup
  Future<void> importDashboardData(Map<String, dynamic> data);

  /// Reinicia todas las métricas del dashboard
  Future<void> resetDashboardData();

  /// Obtiene estadísticas de productividad por período
  Future<Map<String, dynamic>> getProductivityStats({
    required DateTime startDate,
    required DateTime endDate,
  });
}
