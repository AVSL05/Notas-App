import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Caso de uso para añadir un paso a una tarea
class AddTaskStep {
  final TaskRepository repository;

  const AddTaskStep(this.repository);

  Future<Either<Failure, Task>> call(String taskId, TaskStep step) async {
    return await repository.addStepToTask(taskId, step);
  }
}

/// Caso de uso para actualizar un paso de una tarea
class UpdateTaskStep {
  final TaskRepository repository;

  const UpdateTaskStep(this.repository);

  Future<Either<Failure, Task>> call(String taskId, TaskStep step) async {
    return await repository.updateStepInTask(taskId, step);
  }
}

/// Caso de uso para eliminar un paso de una tarea
class RemoveTaskStep {
  final TaskRepository repository;

  const RemoveTaskStep(this.repository);

  Future<Either<Failure, Task>> call(String taskId, String stepId) async {
    return await repository.removeStepFromTask(taskId, stepId);
  }
}

/// Caso de uso para reordenar pasos de una tarea
class ReorderTaskSteps {
  final TaskRepository repository;

  const ReorderTaskSteps(this.repository);

  Future<Either<Failure, Task>> call(String taskId, List<String> steps) async {
    return await repository.reorderStepsInTask(taskId, steps);
  }
}
