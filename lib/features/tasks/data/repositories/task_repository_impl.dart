import 'package:dartz/dartz.dart' hide Task;
import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';
import '../models/task_category_model.dart';
import '../../../../core/error/failures.dart';

/// Implementación del repositorio de tareas
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource _localDataSource;

  TaskRepositoryImpl({
    required TaskLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  // === CRUD DE TAREAS ===

  @override
  Future<Either<Failure, List<Task>>> getAllTasks() async {
    try {
      final taskModels = await _localDataSource.getAllTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task?>> getTaskById(String id) async {
    try {
      final taskModel = await _localDataSource.getTaskById(id);
      final task = taskModel?.toEntity();
      return Right(task);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _localDataSource.saveTask(taskModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al guardar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTasks(List<Task> tasks) async {
    try {
      final taskModels = tasks.map((task) => TaskModel.fromEntity(task)).toList();
      await _localDataSource.saveTasks(taskModels);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al guardar las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await _localDataSource.deleteTask(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al eliminar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTasks(List<String> ids) async {
    try {
      await _localDataSource.deleteTasks(ids);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al eliminar las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllTasks() async {
    try {
      await _localDataSource.clearAllTasks();
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al limpiar todas las tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final updatedTask = task;
      final taskModel = TaskModel.fromEntity(updatedTask);
      await _localDataSource.saveTask(taskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al actualizar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> completeTask(String id) async {
    try {
      final taskModel = await _localDataSource.getTaskById(id);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final completedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        
        
      );

      final completedTaskModel = TaskModel.fromEntity(completedTask);
      await _localDataSource.saveTask(completedTaskModel);
      return Right(completedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al completar la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> uncompleteTask(String id) async {
    try {
      final taskModel = await _localDataSource.getTaskById(id);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final uncompletedTask = task.copyWith(
        status: TaskStatus.inProgress,
        completedAt: null,
        
      );

      final uncompletedTaskModel = TaskModel.fromEntity(uncompletedTask);
      await _localDataSource.saveTask(uncompletedTaskModel);
      return Right(uncompletedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al marcar como pendiente: ${e.toString()}'));
    }
  }

  // === BÚSQUEDA Y FILTROS ===

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) async {
    try {
      final taskModels = await _localDataSource.searchTasks(query);
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al buscar tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByCategory(String categoryId) async {
    try {
      final taskModels = await _localDataSource.getTasksByCategory(categoryId);
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas por categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByStatus(TaskStatus status) async {
    try {
      final taskModels = await _localDataSource.getTasksByStatus(status);
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas por estado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByPriority(TaskPriority priority) async {
    try {
      final taskModels = await _localDataSource.getTasksByPriority(priority);
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas por prioridad: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getCompletedTasks() async {
    try {
      final taskModels = await _localDataSource.getCompletedTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas completadas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getPendingTasks() async {
    try {
      final taskModels = await _localDataSource.getPendingTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas pendientes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getOverdueTasks() async {
    try {
      final taskModels = await _localDataSource.getOverdueTasks();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas vencidas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksDueToday() async {
    try {
      final taskModels = await _localDataSource.getTasksDueToday();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas que vencen hoy: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksDueThisWeek() async {
    try {
      final taskModels = await _localDataSource.getTasksDueThisWeek();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas que vencen esta semana: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksWithReminder() async {
    try {
      final taskModels = await _localDataSource.getTasksWithReminder();
      final tasks = taskModels.map((model) => model.toEntity()).toList();
      return Right(tasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas con recordatorio: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final allTaskModels = await _localDataSource.getAllTasks();
      final filteredTasks = allTaskModels.where((task) {
        final taskDate = task.dueDate ?? task.createdAt;
        return taskDate.isAfter(startDate) && taskDate.isBefore(endDate);
      }).map((model) => model.toEntity()).toList();
      
      return Right(filteredTasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas por rango de fechas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksByTags(List<String> tags) async {
    try {
      final allTaskModels = await _localDataSource.getAllTasks();
      final filteredTasks = allTaskModels.where((task) {
        return tags.any((tag) => task.tags.contains(tag));
      }).map((model) => model.toEntity()).toList();
      
      return Right(filteredTasks);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener tareas por etiquetas: ${e.toString()}'));
    }
  }

  // === GESTIÓN DE CATEGORÍAS ===

  @override
  Future<Either<Failure, List<TaskCategory>>> getAllCategories() async {
    try {
      final categoryModels = await _localDataSource.getAllCategories();
      final categories = categoryModels.map((model) => model.toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener las categorías: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TaskCategory?>> getCategoryById(String id) async {
    try {
      final categoryModel = await _localDataSource.getCategoryById(id);
      final category = categoryModel?.toEntity();
      return Right(category);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener la categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCategory(TaskCategory category) async {
    try {
      final categoryModel = TaskCategoryModel.fromEntity(category);
      await _localDataSource.saveCategory(categoryModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al guardar la categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      // Verificar si hay tareas asociadas a esta categoría
      final tasksInCategory = await _localDataSource.getTasksByCategory(id);
      if (tasksInCategory.isNotEmpty) {
        return Left(ValidationFailure(
          message: 'No se puede eliminar la categoría porque tiene tareas asociadas'
        ));
      }

      await _localDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al eliminar la categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TaskCategory>> updateCategory(TaskCategory category) async {
    try {
      final updatedCategory = category;
      final categoryModel = TaskCategoryModel.fromEntity(updatedCategory);
      await _localDataSource.saveCategory(categoryModel);
      return Right(updatedCategory);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al actualizar la categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> initializeDefaultCategories() async {
    try {
      final defaultCategories = await _localDataSource.getDefaultCategories();
      await _localDataSource.saveCategories(defaultCategories);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al inicializar categorías por defecto: ${e.toString()}'));
    }
  }

  // === GESTIÓN DE PASOS ===

  @override
  Future<Either<Failure, Task>> addStepToTask(String taskId, TaskStep step) async {
    try {
      final taskModel = await _localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final newSteps = List<TaskStep>.from(task.steps)..add(step);
      final updatedTask = task.copyWith(
        steps: newSteps,
        
      );

      final updatedTaskModel = TaskModel.fromEntity(updatedTask);
      await _localDataSource.saveTask(updatedTaskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al agregar paso a la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> updateStepInTask(String taskId, TaskStep step) async {
    try {
      final taskModel = await _localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final stepIndex = task.steps.indexWhere((s) => s.id == step.id);
      if (stepIndex == -1) {
        return Left(LocalFailure(message: 'Paso no encontrado en la tarea'));
      }

      final newSteps = List<TaskStep>.from(task.steps);
      newSteps[stepIndex] = step;
      
      final updatedTask = task.copyWith(
        steps: newSteps,
        
      );

      final updatedTaskModel = TaskModel.fromEntity(updatedTask);
      await _localDataSource.saveTask(updatedTaskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al actualizar paso de la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> removeStepFromTask(String taskId, String stepId) async {
    try {
      final taskModel = await _localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final newSteps = task.steps.where((step) => step.id != stepId).toList();
      
      final updatedTask = task.copyWith(
        steps: newSteps,
        
      );

      final updatedTaskModel = TaskModel.fromEntity(updatedTask);
      await _localDataSource.saveTask(updatedTaskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al eliminar paso de la tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> reorderStepsInTask(String taskId, List<String> stepIds) async {
    try {
      final taskModel = await _localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }

      final task = taskModel.toEntity();
      final reorderedSteps = <TaskStep>[];
      
      // Reordenar según la lista de IDs
      for (final stepId in stepIds) {
        final step = task.steps.firstWhere(
          (s) => s.id == stepId,
          orElse: () => throw Exception('Paso no encontrado: $stepId'),
        );
        reorderedSteps.add(step.copyWith(order: reorderedSteps.length));
      }
      
      final updatedTask = task.copyWith(
        steps: reorderedSteps,
        
      );

      final updatedTaskModel = TaskModel.fromEntity(updatedTask);
      await _localDataSource.saveTask(updatedTaskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al reordenar pasos de la tarea: ${e.toString()}'));
    }
  }

  // === ESTADÍSTICAS ===

  @override
  Future<Either<Failure, Map<String, int>>> getTaskCounts() async {
    try {
      final counts = await _localDataSource.getTaskCounts();
      return Right(counts);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener contadores de tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCategoryStatistics() async {
    try {
      final stats = await _localDataSource.getCategoryStatistics();
      return Right(stats);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener estadísticas por categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProductivityStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final stats = await _localDataSource.getProductivityStats(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(stats);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener estadísticas de productividad: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getCompletionRate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final allTaskModels = await _localDataSource.getAllTasks();
      
      // Filtrar por rango de fechas si se proporciona
      final filteredTasks = allTaskModels.where((task) {
        if (startDate != null && task.createdAt.isBefore(startDate)) return false;
        if (endDate != null && task.createdAt.isAfter(endDate)) return false;
        return true;
      }).toList();
      
      if (filteredTasks.isEmpty) return const Right(0.0);
      
      final completedCount = filteredTasks.where((task) => task.isCompleted).length;
      final rate = (completedCount / filteredTasks.length) * 100;
      
      return Right(rate);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al calcular tasa de finalización: ${e.toString()}'));
    }
  }

  // === IMPORTACIÓN Y EXPORTACIÓN ===

  @override
  Future<Either<Failure, Map<String, dynamic>>> exportTasks() async {
    try {
      final data = await _localDataSource.exportTasks();
      return Right(data);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al exportar tareas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> importTasks(Map<String, dynamic> data) async {
    try {
      // Validar estructura de datos
      if (!data.containsKey('tasks') || !data.containsKey('categories')) {
        return Left(ValidationFailure(message: 'Formato de importación inválido'));
      }

      // Importar categorías primero
      final categoriesData = data['categories'] as List<dynamic>;
      final categories = categoriesData
          .map((catData) => TaskCategoryModel.fromJson(catData))
          .toList();
      await _localDataSource.saveCategories(categories);

      // Importar tareas
      final tasksData = data['tasks'] as List<dynamic>;
      final tasks = tasksData
          .map((taskData) => TaskModel.fromJson(taskData))
          .toList();
      await _localDataSource.saveTasks(tasks);

      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al importar tareas: ${e.toString()}'));
    }
  }

  // === UTILIDADES ===

  @override
  Future<Either<Failure, int>> cleanupOldCompletedTasks({
    Duration olderThan = const Duration(days: 30),
  }) async {
    try {
      final deletedCount = await _localDataSource.cleanupOldCompletedTasks(
        olderThan: olderThan,
      );
      return Right(deletedCount);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al limpiar tareas completadas antiguas: ${e.toString()}'));
    }
  }

  // === MÉTODOS ADICIONALES REQUERIDOS ===
  
  @override
  Future<Either<Failure, int>> getTotalTasksCount() async {
    try {
      final tasks = await _localDataSource.getAllTasks();
      return Right(tasks.length);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener conteo total: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getCompletedTasksCount() async {
    try {
      final completedTasks = await _localDataSource.getCompletedTasks();
      return Right(completedTasks.length);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener conteo completadas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getPendingTasksCount() async {
    try {
      final pendingTasks = await _localDataSource.getPendingTasks();
      return Right(pendingTasks.length);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener conteo pendientes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> backupTasks() async {
    try {
      final exportResult = await exportTasks();
      return exportResult.fold(
        (failure) => Left(failure),
        (data) {
          // Aquí se podría implementar el guardado del backup
          // Por ahora solo retornamos éxito
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(LocalFailure(message: 'Error al hacer backup: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> restoreTasks() async {
    try {
      // Implementación básica - se puede expandir más tarde
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al restaurar: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Task>> markTaskAsCompleted(String taskId) async {
    return completeTask(taskId);
  }

  @override
  Future<Either<Failure, Task>> markTaskAsPending(String taskId) async {
    return uncompleteTask(taskId);
  }

  @override
  Future<Either<Failure, Task>> duplicateTask(String taskId) async {
    try {
      final taskModel = await _localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }
      
      final originalTask = taskModel.toEntity();
      final duplicatedTask = originalTask.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${originalTask.title} (Copia)',
        isCompleted: false,
        completedAt: null,
        createdAt: DateTime.now(),
      );
      
      final duplicatedTaskModel = TaskModel.fromEntity(duplicatedTask);
      await _localDataSource.saveTask(duplicatedTaskModel);
      return Right(duplicatedTask);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al duplicar tarea: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TaskCategory>>> getDefaultCategories() async {
    try {
      final defaultCategoriesModels = await _localDataSource.getDefaultCategories();
      final defaultCategories = defaultCategoriesModels.map((model) => model.toEntity()).toList();
      return Right(defaultCategories);
    } catch (e) {
      return Left(LocalFailure(message: 'Error al obtener categorías por defecto: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TaskCategory>> createCategory(TaskCategory category) async {
    try {
      final categoryModel = TaskCategoryModel.fromEntity(category);
      await _localDataSource.saveCategory(categoryModel);
      return Right(categoryModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: 'Error al crear categoría: ${e.toString()}'));
    }
  }
}
