import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Caso de uso para crear una nueva tarea
class CreateTask {
  final TaskRepository repository;

  const CreateTask(this.repository);

  Future<Either<Failure, void>> call(Task task) async {
    return await repository.saveTask(task);
  }
}

/// Caso de uso para obtener todas las tareas
class GetAllTasks {
  final TaskRepository repository;

  const GetAllTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getAllTasks();
  }
}

/// Caso de uso para obtener una tarea por ID
class GetTaskById {
  final TaskRepository repository;

  const GetTaskById(this.repository);

  Future<Either<Failure, Task?>> call(String id) async {
    return await repository.getTaskById(id);
  }
}

/// Caso de uso para actualizar una tarea
class UpdateTask {
  final TaskRepository repository;

  const UpdateTask(this.repository);

  Future<Either<Failure, void>> call(Task task) async {
    return await repository.updateTask(task);
  }
}

/// Caso de uso para eliminar una tarea
class DeleteTask {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTask(id);
  }
}

/// Caso de uso para buscar tareas
class SearchTasks {
  final TaskRepository repository;

  const SearchTasks(this.repository);

  Future<Either<Failure, List<Task>>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getAllTasks();
    }
    return await repository.searchTasks(query);
  }
}

/// Caso de uso para marcar una tarea como completada
class MarkTaskAsCompleted {
  final TaskRepository repository;

  const MarkTaskAsCompleted(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.markTaskAsCompleted(id);
  }
}

/// Caso de uso para marcar una tarea como pendiente
class MarkTaskAsPending {
  final TaskRepository repository;

  const MarkTaskAsPending(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.markTaskAsPending(id);
  }
}

/// Caso de uso para obtener tareas por estado
class GetTasksByStatus {
  final TaskRepository repository;

  const GetTasksByStatus(this.repository);

  Future<Either<Failure, List<Task>>> call(TaskStatus status) async {
    return await repository.getTasksByStatus(status);
  }
}

/// Caso de uso para obtener tareas pendientes
class GetPendingTasks {
  final TaskRepository repository;

  const GetPendingTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getPendingTasks();
  }
}

/// Caso de uso para obtener tareas completadas
class GetCompletedTasks {
  final TaskRepository repository;

  const GetCompletedTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getCompletedTasks();
  }
}

/// Caso de uso para obtener tareas vencidas
class GetOverdueTasks {
  final TaskRepository repository;

  const GetOverdueTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getOverdueTasks();
  }
}

/// Caso de uso para obtener tareas que vencen hoy
class GetTasksDueToday {
  final TaskRepository repository;

  const GetTasksDueToday(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getTasksDueToday();
  }
}

/// Caso de uso para duplicar una tarea
class DuplicateTask {
  final TaskRepository repository;

  const DuplicateTask(this.repository);

  Future<Either<Failure, Task>> call(String id) async {
    return await repository.duplicateTask(id);
  }
}
