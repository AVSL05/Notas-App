import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_category.dart';
import '../repositories/task_repository.dart';

/// Caso de uso para crear una nueva categoría
class CreateTaskCategory {
  final TaskRepository repository;

  const CreateTaskCategory(this.repository);

  Future<Either<Failure, void>> call(TaskCategory category) async {
    return await repository.saveCategory(category);
  }
}

/// Caso de uso para obtener todas las categorías
class GetAllTaskCategories {
  final TaskRepository repository;

  const GetAllTaskCategories(this.repository);

  Future<Either<Failure, List<TaskCategory>>> call() async {
    return await repository.getAllCategories();
  }
}

/// Caso de uso para obtener una categoría por ID
class GetTaskCategoryById {
  final TaskRepository repository;

  const GetTaskCategoryById(this.repository);

  Future<Either<Failure, TaskCategory?>> call(String id) async {
    return await repository.getCategoryById(id);
  }
}

/// Caso de uso para actualizar una categoría
class UpdateTaskCategory {
  final TaskRepository repository;

  const UpdateTaskCategory(this.repository);

  Future<Either<Failure, void>> call(TaskCategory category) async {
    return await repository.updateCategory(category);
  }
}

/// Caso de uso para eliminar una categoría
class DeleteTaskCategory {
  final TaskRepository repository;

  const DeleteTaskCategory(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCategory(id);
  }
}

/// Caso de uso para obtener categorías por defecto
class GetDefaultTaskCategories {
  final TaskRepository repository;

  const GetDefaultTaskCategories(this.repository);

  Future<Either<Failure, List<TaskCategory>>> call() async {
    return await repository.getDefaultCategories();
  }
}

/// Caso de uso para inicializar categorías por defecto
class InitializeDefaultCategories {
  final TaskRepository repository;

  const InitializeDefaultCategories(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      // Obtener categorías existentes
      final categoriesResult = await repository.getAllCategories();
      
      return categoriesResult.fold(
        (failure) => Left(failure),
        (existingCategories) async {
          // Obtener categorías por defecto
          final defaultCategories = TaskCategory.defaultCategories;
          
          // Crear solo las categorías que no existen
          for (final defaultCategory in defaultCategories) {
            final exists = existingCategories.any(
              (category) => category.id == defaultCategory.id,
            );
            
            if (!exists) {
              final result = await repository.createCategory(defaultCategory);
              if (result.isLeft()) {
                return result;
              }
            }
          }
          
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(LocalFailure(message: 'Error al inicializar categorías por defecto: $e'));
    }
  }
}
