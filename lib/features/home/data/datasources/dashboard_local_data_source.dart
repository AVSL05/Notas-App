import 'package:hive/hive.dart';
import 'package:notas_app/features/home/data/models/dashboard_summary_model.dart';

/// Datasource local para datos del dashboard usando Hive
abstract class DashboardLocalDataSource {
  /// Obtiene el resumen del dashboard desde caché local
  Future<DashboardSummaryModel?> getDashboardSummary();

  /// Guarda el resumen del dashboard en caché local
  Future<void> saveDashboardSummary(DashboardSummaryModel summary);

  /// Obtiene las acciones rápidas desde caché local
  Future<List<QuickActionModel>> getQuickActions();

  /// Guarda las acciones rápidas en caché local
  Future<void> saveQuickActions(List<QuickActionModel> actions);

  /// Obtiene las actividades recientes desde caché local
  Future<List<RecentActivityModel>> getRecentActivities({int limit = 10});

  /// Guarda una nueva actividad en caché local
  Future<void> saveActivity(RecentActivityModel activity);

  /// Elimina actividades antiguas (más de 30 días)
  Future<void> cleanupOldActivities();

  /// Obtiene configuraciones del dashboard
  Future<Map<String, dynamic>> getDashboardSettings();

  /// Guarda configuraciones del dashboard
  Future<void> saveDashboardSettings(Map<String, dynamic> settings);

  /// Limpia todos los datos del dashboard
  Future<void> clearDashboardData();

  /// Exporta todos los datos del dashboard
  Future<Map<String, dynamic>> exportAllData();

  /// Importa datos del dashboard
  Future<void> importData(Map<String, dynamic> data);
}

/// Implementación del datasource local usando Hive
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _dashboardBox = 'dashboard_box';
  static const String _quickActionsBox = 'quick_actions_box';
  static const String _activitiesBox = 'activities_box';
  static const String _settingsBox = 'dashboard_settings_box';
  
  static const String _summaryKey = 'dashboard_summary';
  static const String _settingsKey = 'dashboard_settings';

  Box<DashboardSummaryModel>? _dashboardBox_;
  Box<QuickActionModel>? _quickActionsBox_;
  Box<RecentActivityModel>? _activitiesBox_;
  Box<Map<String, dynamic>>? _settingsBox_;

  /// Obtiene la box del dashboard
  Future<Box<DashboardSummaryModel>> get _getDashboardBox async {
    return _dashboardBox_ ??= await Hive.openBox<DashboardSummaryModel>(_dashboardBox);
  }

  /// Obtiene la box de acciones rápidas
  Future<Box<QuickActionModel>> get _getQuickActionsBox async {
    return _quickActionsBox_ ??= await Hive.openBox<QuickActionModel>(_quickActionsBox);
  }

  /// Obtiene la box de actividades
  Future<Box<RecentActivityModel>> get _getActivitiesBox async {
    return _activitiesBox_ ??= await Hive.openBox<RecentActivityModel>(_activitiesBox);
  }

  /// Obtiene la box de configuraciones
  Future<Box<Map<String, dynamic>>> get _getSettingsBox async {
    return _settingsBox_ ??= await Hive.openBox<Map<String, dynamic>>(_settingsBox);
  }

  @override
  Future<DashboardSummaryModel?> getDashboardSummary() async {
    final box = await _getDashboardBox;
    return box.get(_summaryKey);
  }

  @override
  Future<void> saveDashboardSummary(DashboardSummaryModel summary) async {
    final box = await _getDashboardBox;
    await box.put(_summaryKey, summary);
  }

  @override
  Future<List<QuickActionModel>> getQuickActions() async {
    final box = await _getQuickActionsBox;
    
    // Si no hay acciones guardadas, retornamos las por defecto
    if (box.isEmpty) {
      final defaultActions = _getDefaultActions();
      await saveQuickActions(defaultActions);
      return defaultActions;
    }
    
    final actions = box.values.toList();
    // Ordenar por sortOrder
    actions.sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
    return actions;
  }

  List<QuickActionModel> _getDefaultActions() {
    return [
      QuickActionModel(
        id: 'create_note',
        title: 'Nueva Nota',
        description: 'Crear una nueva nota',
        iconData: 'add',
        route: '/notes/new',
        isEnabled: true,
        createdAt: DateTime.now(),
        sortOrder: 1,
      ),
      QuickActionModel(
        id: 'create_task',
        title: 'Nueva Tarea',
        description: 'Crear una nueva tarea',
        iconData: 'task_alt',
        route: '/tasks/new',
        isEnabled: true,
        createdAt: DateTime.now(),
        sortOrder: 2,
      ),
      QuickActionModel(
        id: 'view_calendar',
        title: 'Calendario',
        description: 'Ver el calendario',
        iconData: 'calendar_today',
        route: '/calendar',
        isEnabled: true,
        createdAt: DateTime.now(),
        sortOrder: 3,
      ),
    ];
  }

  @override
  Future<void> saveQuickActions(List<QuickActionModel> actions) async {
    final box = await _getQuickActionsBox;
    await box.clear();
    
    for (final action in actions) {
      await box.put(action.id, action);
    }
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities({int limit = 10}) async {
    final box = await _getActivitiesBox;
    final activities = box.values.toList();
    
    // Ordenar por timestamp descendente (más recientes primero)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Limitar resultados
    if (activities.length > limit) {
      return activities.take(limit).toList();
    }
    
    return activities;
  }

  @override
  Future<void> saveActivity(RecentActivityModel activity) async {
    final box = await _getActivitiesBox;
    await box.put(activity.id, activity);
    
    // Limitar el número de actividades almacenadas (máximo 100)
    if (box.length > 100) {
      await _cleanupExcessActivities();
    }
  }

  @override
  Future<void> cleanupOldActivities() async {
    final box = await _getActivitiesBox;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final keysToDelete = <String>[];
    
    for (final entry in box.toMap().entries) {
      if (entry.value.timestamp.isBefore(thirtyDaysAgo)) {
        keysToDelete.add(entry.key);
      }
    }
    
    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }

  /// Limpia actividades excesivas manteniendo solo las 50 más recientes
  Future<void> _cleanupExcessActivities() async {
    final box = await _getActivitiesBox;
    final activities = box.values.toList();
    
    // Ordenar por timestamp descendente
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Mantener solo las 50 más recientes
    final toKeep = activities.take(50).toList();
    await box.clear();
    
    for (final activity in toKeep) {
      await box.put(activity.id, activity);
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardSettings() async {
    final box = await _getSettingsBox;
    return box.get(_settingsKey) ?? _getDefaultSettings();
  }

  @override
  Future<void> saveDashboardSettings(Map<String, dynamic> settings) async {
    final box = await _getSettingsBox;
    await box.put(_settingsKey, settings);
  }

  /// Obtiene configuraciones por defecto
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'showProductivityMetrics': true,
      'showRecentActivities': true,
      'showQuickActions': true,
      'maxRecentActivities': 10,
      'autoUpdateInterval': 300, // 5 minutos en segundos
      'showWelcomeMessage': true,
      'compactView': false,
      'darkMode': false,
      'notifications': {
        'enabled': true,
        'dailyReminder': true,
        'weeklyReport': true,
      },
      'widgets': {
        'notes': true,
        'tasks': true,
        'calendar': true,
        'productivity': true,
      },
    };
  }

  @override
  Future<void> clearDashboardData() async {
    final dashboardBox = await _getDashboardBox;
    final quickActionsBox = await _getQuickActionsBox;
    final activitiesBox = await _getActivitiesBox;
    final settingsBox = await _getSettingsBox;
    
    await Future.wait([
      dashboardBox.clear(),
      quickActionsBox.clear(),
      activitiesBox.clear(),
      settingsBox.clear(),
    ]);
  }

  @override
  Future<Map<String, dynamic>> exportAllData() async {
    final summary = await getDashboardSummary();
    final quickActions = await getQuickActions();
    final activities = await getRecentActivities(limit: 1000); // Todas las actividades
    final settings = await getDashboardSettings();
    
    return {
      'dashboard_summary': summary?.toJson(),
      'quick_actions': quickActions.map((action) => action.toJson()).toList(),
      'recent_activities': activities.map((activity) => activity.toJson()).toList(),
      'settings': settings,
      'export_date': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }

  @override
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      // Importar resumen del dashboard
      if (data.containsKey('dashboard_summary') && data['dashboard_summary'] != null) {
        final summaryData = data['dashboard_summary'] as Map<String, dynamic>;
        final summary = DashboardSummaryModel.fromJson(summaryData);
        await saveDashboardSummary(summary);
      }
      
      // Importar acciones rápidas
      if (data.containsKey('quick_actions')) {
        final actionsData = data['quick_actions'] as List<dynamic>;
        final actions = actionsData
            .map((actionData) => QuickActionModel.fromJson(actionData as Map<String, dynamic>))
            .toList();
        await saveQuickActions(actions);
      }
      
      // Importar actividades recientes
      if (data.containsKey('recent_activities')) {
        final activitiesData = data['recent_activities'] as List<dynamic>;
        final activitiesBox = await _getActivitiesBox;
        await activitiesBox.clear();
        
        for (final activityData in activitiesData) {
          final activity = RecentActivityModel.fromJson(activityData as Map<String, dynamic>);
          await activitiesBox.put(activity.id, activity);
        }
      }
      
      // Importar configuraciones
      if (data.containsKey('settings')) {
        final settingsData = data['settings'] as Map<String, dynamic>;
        await saveDashboardSettings(settingsData);
      }
    } catch (e) {
      throw Exception('Error al importar datos del dashboard: $e');
    }
  }
}
