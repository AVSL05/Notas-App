import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';
import '../models/dashboard_summary_model.dart';

/// Implementación del repositorio del dashboard
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  const DashboardRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    final summary = await localDataSource.getDashboardSummary();
    return summary ?? DashboardSummary.empty;
  }

  @override
  Future<void> updateDashboardMetrics() async {
    // Esta función será implementada para calcular métricas reales
    // Por ahora creamos un resumen de ejemplo
    final now = DateTime.now();

    // TODO: Implementar cálculo real de métricas desde otras fuentes de datos
    // Esto debería integrar con NotesRepository, TasksRepository, etc.

    final summary = DashboardSummaryModel(
      totalNotes: 0, // TODO: Obtener de NotesRepository
      completedTasks: 0, // TODO: Calcular tareas completadas
      totalCategories: 0, // TODO: Obtener de CategoryRepository
      productivityScore: 0.0, // TODO: Calcular
      quickActions: [], // Se inicializa vacío, se puede poblar después
      recentActivities: [], // Se inicializa vacío
      lastUpdated: now,
    );

    await localDataSource.saveDashboardSummary(summary);
  }

  @override
  Future<List<QuickAction>> getQuickActions() async {
    final actions = await localDataSource.getQuickActions();
    return actions.cast<QuickAction>();
  }

  @override
  Future<void> updateQuickActions(List<QuickAction> actions) async {
    final actionModels =
        actions.map((action) => QuickActionModel.fromEntity(action)).toList();
    await localDataSource.saveQuickActions(actionModels);
  }

  @override
  Future<List<RecentActivity>> getRecentActivities({int limit = 10}) async {
    final activities = await localDataSource.getRecentActivities(limit: limit);
    return activities.cast<RecentActivity>();
  }

  @override
  Future<void> recordActivity(RecentActivity activity) async {
    final activityModel = RecentActivityModel.fromEntity(activity);
    await localDataSource.saveActivity(activityModel);
  }

  @override
  Future<void> cleanupOldActivities() async {
    await localDataSource.cleanupOldActivities();
  }

  @override
  Future<Map<String, dynamic>> getDashboardSettings() async {
    return await localDataSource.getDashboardSettings();
  }

  @override
  Future<void> updateDashboardSettings(Map<String, dynamic> settings) async {
    await localDataSource.saveDashboardSettings(settings);
  }

  @override
  Future<Map<String, dynamic>> exportDashboardData() async {
    return await localDataSource.exportAllData();
  }

  @override
  Future<void> importDashboardData(Map<String, dynamic> data) async {
    await localDataSource.importData(data);
  }

  @override
  Future<void> resetDashboardData() async {
    await localDataSource.clearDashboardData();

    // Reinicializar con acciones rápidas por defecto
    final defaultActions = QuickAction.getDefaultActions()
        .map((e) => QuickActionModel.fromEntity(e))
        .toList();
    await localDataSource.saveQuickActions(defaultActions);

    // Crear resumen inicial
    await updateDashboardMetrics();
  }

  @override
  Future<Map<String, dynamic>> getProductivityStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // TODO: Implementar cálculo de estadísticas de productividad
    // Esto debería analizar actividades y métricas en el rango de fechas
    
    final activities = await localDataSource.getRecentActivities(limit: 1000);
    
    // Filtrar actividades en el rango de fechas
    final filteredActivities = activities.where((activity) {
      return activity.timestamp.isAfter(startDate) && 
             activity.timestamp.isBefore(endDate);
    }).toList();
    
    // Calcular estadísticas básicas
    final notesCreated = filteredActivities
        .where((a) => a.type == ActivityType.noteCreated)
        .length;
    
    final tasksCompleted = filteredActivities
        .where((a) => a.type == ActivityType.taskCompleted)
        .length;
    
    final totalActivities = filteredActivities.length;
    
    return {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_activities': totalActivities,
      'notes_created': notesCreated,
      'tasks_completed': tasksCompleted,
      'most_active_day': _getMostActiveDay(filteredActivities),
      'activity_trend': _getActivityTrend(filteredActivities),
      'productivity_score': _calculateProductivityScore(filteredActivities),
    };
  }

  /// Obtiene el día más activo en base a las actividades
  String _getMostActiveDay(List<RecentActivityModel> activities) {
    if (activities.isEmpty) return 'N/A';
    
    final dayCount = <String, int>{};
    
    for (final activity in activities) {
      final dayKey = '${activity.timestamp.year}-${activity.timestamp.month}-${activity.timestamp.day}';
      dayCount[dayKey] = (dayCount[dayKey] ?? 0) + 1;
    }
    
    if (dayCount.isEmpty) return 'N/A';
    
    final mostActiveDay = dayCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return mostActiveDay;
  }

  /// Calcula la tendencia de actividad
  String _getActivityTrend(List<RecentActivityModel> activities) {
    if (activities.length < 2) return 'stable';
    
    // Ordenar por fecha
    activities.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Dividir en dos mitades y comparar
    final midPoint = activities.length ~/ 2;
    final firstHalf = activities.take(midPoint).length;
    final secondHalf = activities.skip(midPoint).length;
    
    if (secondHalf > firstHalf * 1.2) return 'increasing';
    if (secondHalf < firstHalf * 0.8) return 'decreasing';
    return 'stable';
  }

  /// Calcula un puntaje de productividad basado en las actividades
  double _calculateProductivityScore(List<RecentActivityModel> activities) {
    if (activities.isEmpty) return 0.0;
    
    double score = 0.0;
    
    for (final activity in activities) {
      switch (activity.type) {
        case ActivityType.noteCreated:
          score += 2.0;
          break;
        case ActivityType.taskCompleted:
          score += 3.0;
          break;
        case ActivityType.noteUpdated:
          score += 1.5;
          break;
        case ActivityType.taskCreated:
          score += 1.0;
          break;
        case ActivityType.reminderSet:
          score += 1.0;
          break;
        case ActivityType.notePinned:
          score += 0.5;
          break;
        case ActivityType.categoryCreated:
          score += 1.0;
          break;
        default:
          score += 0.5;
      }
    }
    
    // Normalizar el puntaje (máximo 100)
    return (score / activities.length * 10).clamp(0.0, 100.0);
  }
}
