import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../entities/task_category.dart';

/// Repositorio abstracto para el manejo de tareas
abstract class TaskRepository {
  // === CRUD DE TAREAS ===
  
  /// Obtiene todas las tareas
  Future<Either<Failure, List<Task>>> getAllTasks();
  
  /// Obtiene una tarea por ID
  Future<Either<Failure, Task?>> getTaskById(String id);
  
  /// Crea una nueva tarea
  Future<Either<Failure, void>> saveTask(Task task);
  
  /// Actualiza una tarea existente
  Future<Either<Failure, Task>> updateTask(Task task);
  
  /// Elimina una tarea
  Future<Either<Failure, void>> deleteTask(String id);
  
  /// Elimina múltiples tareas
  Future<Either<Failure, void>> deleteTasks(List<String> ids);
  
  /// Limpia todas las tareas
  Future<Either<Failure, void>> clearAllTasks();
  
  /// Completa una tarea
  Future<Either<Failure, Task>> completeTask(String id);
  
  /// Marca como pendiente una tarea
  Future<Either<Failure, Task>> uncompleteTask(String id);
  
  // === BÚSQUEDA Y FILTROS ===
  
  /// Busca tareas por término
  Future<Either<Failure, List<Task>>> searchTasks(String query);
  
  /// Obtiene tareas por categoría
  Future<Either<Failure, List<Task>>> getTasksByCategory(String categoryId);
  
  /// Obtiene tareas por estado
  Future<Either<Failure, List<Task>>> getTasksByStatus(TaskStatus status);
  
  /// Obtiene tareas por prioridad
  Future<Either<Failure, List<Task>>> getTasksByPriority(TaskPriority priority);
  
  /// Obtiene tareas completadas
  Future<Either<Failure, List<Task>>> getCompletedTasks();
  
  /// Obtiene tareas pendientes
  Future<Either<Failure, List<Task>>> getPendingTasks();
  
  /// Obtiene tareas vencidas
  Future<Either<Failure, List<Task>>> getOverdueTasks();
  
  /// Obtiene tareas que vencen hoy
  Future<Either<Failure, List<Task>>> getTasksDueToday();
  
  /// Obtiene tareas que vencen esta semana
  Future<Either<Failure, List<Task>>> getTasksDueThisWeek();
  
  /// Obtiene tareas con recordatorio
  Future<Either<Failure, List<Task>>> getTasksWithReminder();
  
  /// Obtiene tareas por rango de fechas
  Future<Either<Failure, List<Task>>> getTasksByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Obtiene tareas por etiquetas
  Future<Either<Failure, List<Task>>> getTasksByTags(List<String> tags);
  
  // === GESTIÓN DE CATEGORÍAS ===
  
  /// Obtiene todas las categorías
  Future<Either<Failure, List<TaskCategory>>> getAllCategories();
  
  /// Obtiene una categoría por ID
  Future<Either<Failure, TaskCategory?>> getCategoryById(String id);
  
  /// Crea una nueva categoría
  Future<Either<Failure, void>> saveCategory(TaskCategory category);
  
  /// Actualiza una categoría existente
  Future<Either<Failure, TaskCategory>> updateCategory(TaskCategory category);
  
  /// Elimina una categoría
  Future<Either<Failure, void>> deleteCategory(String id);
  
  /// Inicializa categorías por defecto
  Future<Either<Failure, void>> initializeDefaultCategories();
  
  // === GESTIÓN DE PASOS ===
  
  /// Añade un paso a una tarea
  Future<Either<Failure, Task>> addStepToTask(String taskId, TaskStep step);
  
  /// Actualiza un paso en una tarea
  Future<Either<Failure, Task>> updateStepInTask(String taskId, TaskStep step);
  
  /// Elimina un paso de una tarea
  Future<Either<Failure, Task>> removeStepFromTask(String taskId, String stepId);
  
  /// Reordena los pasos de una tarea
  Future<Either<Failure, Task>> reorderStepsInTask(String taskId, List<String> stepIds);
  
  // === ESTADÍSTICAS ===
  
  /// Obtiene contadores básicos de tareas
  Future<Either<Failure, Map<String, int>>> getTaskCounts();
  
  /// Obtiene estadísticas por categoría
  Future<Either<Failure, Map<String, dynamic>>> getCategoryStatistics();
  
  /// Obtiene estadísticas de productividad
  Future<Either<Failure, Map<String, dynamic>>> getProductivityStats({
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Calcula la tasa de finalización
  Future<Either<Failure, double>> getCompletionRate({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  // === IMPORTAR/EXPORTAR ===
  
  /// Exporta tareas a JSON
  Future<Either<Failure, Map<String, dynamic>>> exportTasks();
  
  /// Importa tareas desde JSON
  Future<Either<Failure, void>> importTasks(Map<String, dynamic> data);
  
  /// Limpia tareas completadas antiguas
  Future<Either<Failure, int>> cleanupOldCompletedTasks({
    Duration olderThan = const Duration(days: 30),
  });

  // === MÉTODOS ADICIONALES REQUERIDOS ===
  
  /// Obtiene el conteo total de tareas
  Future<Either<Failure, int>> getTotalTasksCount();
  
  /// Obtiene el conteo de tareas completadas
  Future<Either<Failure, int>> getCompletedTasksCount();
  
  /// Obtiene el conteo de tareas pendientes
  Future<Either<Failure, int>> getPendingTasksCount();
  
  /// Hace backup de tareas
  Future<Either<Failure, void>> backupTasks();
  
  /// Restaura tareas desde backup
  Future<Either<Failure, void>> restoreTasks();
  
  /// Marca una tarea como completada
  Future<Either<Failure, Task>> markTaskAsCompleted(String taskId);
  
  /// Marca una tarea como pendiente
  Future<Either<Failure, Task>> markTaskAsPending(String taskId);
  
  /// Duplica una tarea
  Future<Either<Failure, Task>> duplicateTask(String taskId);
  
  /// Obtiene categorías por defecto
  Future<Either<Failure, List<TaskCategory>>> getDefaultCategories();
  
  /// Crea una nueva categoría
  Future<Either<Failure, TaskCategory>> createCategory(TaskCategory category);
}
