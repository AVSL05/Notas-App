import 'dart:convert';

import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

/// Caso de uso para obtener contadores de tareas
class GetTaskCounts {
  final TaskRepository repository;

  const GetTaskCounts(this.repository);

  Future<Either<Failure, Map<String, int>>> call() async {
    try {
      final results = await Future.wait([
        repository.getTotalTasksCount(),
        repository.getCompletedTasksCount(),
        repository.getPendingTasksCount(),
      ]);

      // Verificar si algún resultado tiene error
      for (final result in results) {
        if (result.isLeft()) {
          return result.fold(
            (failure) => Left(failure),
            (_) => Left(LocalFailure(message: 'Error inesperado')),
          );
        }
      }

      // Extraer los valores
      final totalTasks = results[0].getOrElse(() => 0);
      final completedTasks = results[1].getOrElse(() => 0);
      final pendingTasks = results[2].getOrElse(() => 0);

      return Right({
        'total': totalTasks,
        'completed': completedTasks,
        'pending': pendingTasks,
        'completion_rate': totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toInt() : 0,
      });
    } catch (e) {
      return Left(LocalFailure(message: "Error obteniendo conteos de tareas: $e"));
    }
  }
}

/// Use case para obtener estadísticas de tareas
class GetTaskStatistics {
  final TaskRepository repository;

  GetTaskStatistics(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    try {
      return await repository.getCategoryStatistics();
    } catch (e) {
      return Left(LocalFailure(message: "Error obteniendo estadísticas: $e"));
    }
  }
}

/// Caso de uso para obtener estadísticas de productividad
class GetProductivityStatistics {
  final TaskRepository repository;

  const GetProductivityStatistics(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return await repository.getProductivityStats(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      return Left(LocalFailure(message: "Error obteniendo estadísticas de productividad: $e"));
    }
  }
}

/// Use case para exportar tareas
class ExportTasks {
  final TaskRepository repository;

  ExportTasks(this.repository);

  Future<Either<Failure, String>> call(String format) async {
    try {
      // Primero obtener todas las tareas
      final tasksResult = await repository.getAllTasks();
      return tasksResult.fold(
        (failure) => Left(failure),
        (tasks) {
          // Convertir a JSON string
          final taskMaps = tasks.map((task) => {
            'id': task.id,
            'title': task.title,
            'description': task.description,
            'isCompleted': task.isCompleted,
            'createdAt': task.createdAt.toIso8601String(),
            'dueDate': task.dueDate?.toIso8601String(),
            'priority': task.priority.name,
            'categoryId': task.categoryId,
            'tags': task.tags,
          }).toList();
          
          final exportData = {
            'tasks': taskMaps,
            'exportedAt': DateTime.now().toIso8601String(),
            'format': format,
          };
          
          return Right(jsonEncode(exportData));
        },
      );
    } catch (e) {
      return Left(LocalFailure(message: "Error exportando tareas: $e"));
    }
  }
}
