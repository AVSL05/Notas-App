import 'dart:convert';

import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../models/task_category_model.dart';
import '../../domain/entities/task.dart';

/// Data source local para tareas usando Hive
class TaskLocalDataSource {
  static const String _tasksBoxName = 'tasks';
  static const String _categoriesBoxName = 'task_categories';

  // Boxes de Hive
  Box<TaskModel>? _tasksBox;
  Box<TaskCategoryModel>? _categoriesBox;

  // Keys para estadísticas y configuraciones 
  static const String _statisticsKey = 'task_statistics';
  static const String _settingsKey = 'task_settings';

  /// Inicializa las cajas de Hive
  Future<void> initialize() async {
    _tasksBox = await Hive.openBox<TaskModel>(_tasksBoxName);
    _categoriesBox = await Hive.openBox<TaskCategoryModel>(_categoriesBoxName);
    
    // Inicializar configuraciones por defecto si no existen
    await _initializeDefaultSettings();
  }
  
  /// Inicializa configuraciones por defecto
  Future<void> _initializeDefaultSettings() async {
    final settings = _tasksBox!.get(_settingsKey);
    if (settings == null) {
      await _tasksBox!.put(_settingsKey, TaskModel(
        id: _settingsKey,
        title: 'Settings Container',
        description: jsonEncode(<String, dynamic>{
          'default_sort': 'created_date',
          'default_filter': 'all',
          'show_completed': true,
          'auto_cleanup_days': 30,
          'last_backup': DateTime.now().millisecondsSinceEpoch,
        }),
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: TaskPriority.low,
        categoryId: null,
        tags: const [],
        steps: const [],
        hasReminder: false,
        reminderTime: null,
        status: TaskStatus.pending,
        noteId: null,
        estimatedMinutes: null,
        actualMinutes: null,
        dueDate: null,
        completedAt: null,
      ));
    }
  }
  
  /// Obtiene configuraciones de tareas
  Future<Map<String, dynamic>> getTaskSettings() async {
    _ensureInitialized();
    final settings = _tasksBox!.get(_settingsKey);
    
    // Usar _statisticsKey para guardar estadísticas en caché
    final cachedStats = _tasksBox!.get(_statisticsKey);
    
    Map<String, dynamic> result = {};
    if (settings != null) {
      try {
        result = Map<String, dynamic>.from(jsonDecode(settings.description));
      } catch (e) {
        result = <String, dynamic>{};
      }
    }
    
    if (cachedStats != null) {
      try {
        result['cached_statistics'] = Map<String, dynamic>.from(jsonDecode(cachedStats.description));
      } catch (e) {
        // Ignorar errores de estadísticas cacheadas
      }
    }
    
    return result;
  }
  
  /// Actualiza configuraciones de tareas
  Future<void> updateTaskSettings(Map<String, dynamic> settings) async {
    _ensureInitialized();
    final currentSettings = await getTaskSettings();
    currentSettings.addAll(settings);
    
    // Actualizar estadísticas en caché usando _statisticsKey
    if (settings.containsKey('statistics')) {
      final statsData = settings['statistics'];
      await _tasksBox!.put(_statisticsKey, TaskModel(
        id: _statisticsKey,
        title: 'Statistics Container',
        description: jsonEncode(statsData),
        isCompleted: false,
        createdAt: DateTime.now(),
        priority: TaskPriority.low,
        categoryId: null,
        tags: const [],
        steps: const [],
        hasReminder: false,
        reminderTime: null,
        status: TaskStatus.pending,
        noteId: null,
        estimatedMinutes: null,
        actualMinutes: null,
        dueDate: null,
        completedAt: null,
      ));
      currentSettings.remove('statistics');
    }
    
    // Actualizar configuraciones principales
    final currentSettingsModel = _tasksBox!.get(_settingsKey);
    if (currentSettingsModel != null) {
      final updatedModel = TaskModel(
        id: currentSettingsModel.id,
        title: currentSettingsModel.title,
        description: jsonEncode(currentSettings),
        isCompleted: currentSettingsModel.isCompleted,
        createdAt: currentSettingsModel.createdAt,
        priority: currentSettingsModel.priority,
        categoryId: currentSettingsModel.categoryId,
        tags: currentSettingsModel.tags,
        steps: currentSettingsModel.steps,
        hasReminder: currentSettingsModel.hasReminder,
        reminderTime: currentSettingsModel.reminderTime,
        status: currentSettingsModel.status,
        noteId: currentSettingsModel.noteId,
        estimatedMinutes: currentSettingsModel.estimatedMinutes,
        actualMinutes: currentSettingsModel.actualMinutes,
        dueDate: currentSettingsModel.dueDate,
        completedAt: currentSettingsModel.completedAt,
      );
      await _tasksBox!.put(_settingsKey, updatedModel);
    }
  }

  /// Verifica que las cajas estén inicializadas
  void _ensureInitialized() {
    if (_tasksBox == null || _categoriesBox == null) {
      throw Exception('TaskLocalDataSource no ha sido inicializado. Llama a initialize() primero.');
    }
  }

  // === CRUD DE TAREAS ===

  /// Obtiene todas las tareas
  Future<List<TaskModel>> getAllTasks() async {
    _ensureInitialized();
    final tasks = _tasksBox!.values.toList();
    // Ordenar por fecha de creación (más recientes primero)
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  /// Obtiene una tarea por ID
  Future<TaskModel?> getTaskById(String id) async {
    _ensureInitialized();
    return _tasksBox!.get(id);
  }

  /// Guarda una tarea
  Future<void> saveTask(TaskModel task) async {
    _ensureInitialized();
    await _tasksBox!.put(task.id, task);
  }

  /// Guarda múltiples tareas
  Future<void> saveTasks(List<TaskModel> tasks) async {
    _ensureInitialized();
    final taskMap = <String, TaskModel>{};
    for (final task in tasks) {
      taskMap[task.id] = task;
    }
    await _tasksBox!.putAll(taskMap);
  }

  /// Elimina una tarea
  Future<void> deleteTask(String id) async {
    _ensureInitialized();
    await _tasksBox!.delete(id);
  }

  /// Elimina múltiples tareas
  Future<void> deleteTasks(List<String> ids) async {
    _ensureInitialized();
    await _tasksBox!.deleteAll(ids);
  }

  /// Limpia todas las tareas
  Future<void> clearAllTasks() async {
    _ensureInitialized();
    await _tasksBox!.clear();
  }

  // === FILTROS Y BÚSQUEDA ===

  /// Busca tareas por término
  Future<List<TaskModel>> searchTasks(String query) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final lowerQuery = query.toLowerCase();
    
    return allTasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
             task.description.toLowerCase().contains(lowerQuery) ||
             task.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Obtiene tareas por categoría
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.categoryId == categoryId).toList();
  }

  /// Obtiene tareas por estado
  Future<List<TaskModel>> getTasksByStatus(TaskStatus status) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.status == status).toList();
  }

  /// Obtiene tareas por prioridad
  Future<List<TaskModel>> getTasksByPriority(TaskPriority priority) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.priority == priority).toList();
  }

  /// Obtiene tareas completadas
  Future<List<TaskModel>> getCompletedTasks() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.isCompleted).toList();
  }

  /// Obtiene tareas pendientes
  Future<List<TaskModel>> getPendingTasks() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => !task.isCompleted).toList();
  }

  /// Obtiene tareas vencidas
  Future<List<TaskModel>> getOverdueTasks() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final now = DateTime.now();
    
    return allTasks.where((task) {
      return task.dueDate != null && 
             !task.isCompleted && 
             task.dueDate!.isBefore(now);
    }).toList();
  }

  /// Obtiene tareas que vencen hoy
  Future<List<TaskModel>> getTasksDueToday() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final now = DateTime.now();
    
    return allTasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      final dueDate = task.dueDate!;
      return now.year == dueDate.year && 
             now.month == dueDate.month && 
             now.day == dueDate.day;
    }).toList();
  }

  /// Obtiene tareas que vencen esta semana
  Future<List<TaskModel>> getTasksDueThisWeek() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    
    return allTasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      return task.dueDate!.isAfter(now) && task.dueDate!.isBefore(weekFromNow);
    }).toList();
  }

  /// Obtiene tareas con recordatorio
  Future<List<TaskModel>> getTasksWithReminder() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    return allTasks.where((task) => task.hasReminder && task.reminderTime != null).toList();
  }

  // === CATEGORÍAS ===

  /// Obtiene todas las categorías
  Future<List<TaskCategoryModel>> getAllCategories() async {
    _ensureInitialized();
    final categories = _categoriesBox!.values.toList();
    // Ordenar por orden y luego por nombre
    categories.sort((a, b) {
      final orderComparison = a.order.compareTo(b.order);
      if (orderComparison != 0) return orderComparison;
      return a.name.compareTo(b.name);
    });
    return categories;
  }

  /// Obtiene todas las categorías (alias para compatibilidad)
  Future<List<TaskCategoryModel>> getCategories() async {
    return getAllCategories();
  }

  /// Obtiene una categoría por ID
  Future<TaskCategoryModel?> getCategoryById(String id) async {
    _ensureInitialized();
    return _categoriesBox!.get(id);
  }

  /// Guarda una categoría
  Future<void> saveCategory(TaskCategoryModel category) async {
    _ensureInitialized();
    await _categoriesBox!.put(category.id, category);
  }

  /// Guarda múltiples categorías
  Future<void> saveCategories(List<TaskCategoryModel> categories) async {
    _ensureInitialized();
    final categoryMap = <String, TaskCategoryModel>{};
    for (final category in categories) {
      categoryMap[category.id] = category;
    }
    await _categoriesBox!.putAll(categoryMap);
  }

  /// Elimina una categoría
  Future<void> deleteCategory(String id) async {
    _ensureInitialized();
    await _categoriesBox!.delete(id);
  }

  /// Obtiene categorías por defecto
  Future<List<TaskCategoryModel>> getDefaultCategories() async {
    return [
      TaskCategoryModel(
        id: 'default_work',
        name: 'Trabajo',
        description: 'Tareas relacionadas con el trabajo',
        colorValue: 0xFF2196F3,
        icon: 'work',
        createdAt: DateTime.now(),
        isDefault: true,
        order: 0,
      ),
      TaskCategoryModel(
        id: 'default_personal',
        name: 'Personal',
        description: 'Tareas personales',
        colorValue: 0xFF4CAF50,
        icon: 'person',
        createdAt: DateTime.now(),
        isDefault: true,
        order: 1,
      ),
      TaskCategoryModel(
        id: 'default_shopping',
        name: 'Compras',
        description: 'Lista de compras',
        colorValue: 0xFFF44336,
        icon: 'shopping_cart',
        createdAt: DateTime.now(),
        isDefault: true,
        order: 2,
      ),
    ];
  }

  // === ESTADÍSTICAS ===

  /// Obtiene contadores básicos
  Future<Map<String, int>> getTaskCounts() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final completedTasks = allTasks.where((task) => task.isCompleted).length;
    final pendingTasks = allTasks.where((task) => !task.isCompleted).length;
    
    return {
      'total': allTasks.length,
      'completed': completedTasks,
      'pending': pendingTasks,
    };
  }

  /// Obtiene estadísticas por categoría
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final allCategories = await getAllCategories();
    
    final stats = <String, Map<String, int>>{};
    
    for (final category in allCategories) {
      final categoryTasks = allTasks.where((task) => task.categoryId == category.id);
      final completedCount = categoryTasks.where((task) => task.isCompleted).length;
      
      stats[category.id] = {
        'total': categoryTasks.length,
        'completed': completedCount,
        'pending': categoryTasks.length - completedCount,
      };
    }
    
    // Tareas sin categoría
    final uncategorizedTasks = allTasks.where((task) => task.categoryId == null);
    final uncategorizedCompleted = uncategorizedTasks.where((task) => task.isCompleted).length;
    
    stats['uncategorized'] = {
      'total': uncategorizedTasks.length,
      'completed': uncategorizedCompleted,
      'pending': uncategorizedTasks.length - uncategorizedCompleted,
    };
    
    return stats;
  }

  /// Obtiene estadísticas de productividad
  Future<Map<String, dynamic>> getProductivityStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    
    // Filtrar tareas en el rango de fechas
    final tasksInRange = allTasks.where((task) {
      return task.createdAt.isAfter(startDate) && task.createdAt.isBefore(endDate);
    }).toList();
    
    final completedInRange = tasksInRange.where((task) => 
      task.isCompleted && 
      task.completedAt != null &&
      task.completedAt!.isAfter(startDate) && 
      task.completedAt!.isBefore(endDate)
    ).toList();
    
    // Calcular métricas
    final totalTasks = tasksInRange.length;
    final completedTasks = completedInRange.length;
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;
    
    // Estadísticas por prioridad
    final priorityStats = <String, int>{};
    for (final priority in TaskPriority.values) {
      priorityStats[priority.name] = tasksInRange.where((task) => task.priority == priority).length;
    }
    
    return {
      'period': {
        'start': startDate.toIso8601String(),
        'end': endDate.toIso8601String(),
      },
      'tasks': {
        'total': totalTasks,
        'completed': completedTasks,
        'pending': totalTasks - completedTasks,
        'completion_rate': completionRate,
      },
      'priority_distribution': priorityStats,
      'average_completion_time': _calculateAverageCompletionTime(completedInRange),
    };
  }

  /// Calcula el tiempo promedio de finalización
  double _calculateAverageCompletionTime(List<TaskModel> completedTasks) {
    if (completedTasks.isEmpty) return 0.0;
    
    final totalMinutes = completedTasks.fold<int>(0, (sum, task) {
      if (task.completedAt != null) {
        final duration = task.completedAt!.difference(task.createdAt);
        return sum + duration.inMinutes;
      }
      return sum;
    });
    
    return totalMinutes / completedTasks.length;
  }

  // === UTILIDADES ===

  /// Limpia tareas completadas antiguas
  Future<int> cleanupOldCompletedTasks({
    Duration olderThan = const Duration(days: 30),
  }) async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final cutoffDate = DateTime.now().subtract(olderThan);
    
    final tasksToDelete = allTasks.where((task) {
      return task.isCompleted && 
             task.completedAt != null && 
             task.completedAt!.isBefore(cutoffDate);
    }).toList();
    
    final idsToDelete = tasksToDelete.map((task) => task.id).toList();
    await deleteTasks(idsToDelete);
    
    return tasksToDelete.length;
  }

  /// Exporta todas las tareas a JSON
  Future<Map<String, dynamic>> exportTasks() async {
    _ensureInitialized();
    final allTasks = await getAllTasks();
    final allCategories = await getAllCategories();
    
    return {
      'version': '1.0',
      'exported_at': DateTime.now().toIso8601String(),
      'tasks': allTasks.map((task) => task.toJson()).toList(),
      'categories': allCategories.map((category) => category.toJson()).toList(),
    };
  }

  /// Cierra las cajas de Hive
  Future<void> close() async {
    await _tasksBox?.close();
    await _categoriesBox?.close();
  }
}
