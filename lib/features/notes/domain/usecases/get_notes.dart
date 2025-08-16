import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para obtener todas las notas
class GetAllNotes {
  final NotesRepository repository;

  const GetAllNotes(this.repository);

  Future<Either<Failure, List<Note>>> call() async {
    try {
      return await repository.getAllNotes();
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener todas las notas: $e'));
    }
  }
}

/// Caso de uso para obtener notas filtradas
class GetFilteredNotes {
  final NotesRepository repository;

  const GetFilteredNotes(this.repository);

  Future<Either<Failure, List<Note>>> call(GetFilteredNotesParams params) async {
    try {
      return await repository.getFilteredNotes(
        searchQuery: params.searchQuery,
        tags: params.tags,
        category: params.category,
        isPinned: params.isPinned,
        isFavorite: params.isFavorite,
        isArchived: params.isArchived,
        hasReminder: params.hasReminder,
        hasTasks: params.hasTasks,
        createdAfter: params.createdAfter,
        createdBefore: params.createdBefore,
      );
    } catch (e) {
      throw Exception('Error al obtener notas filtradas: $e');
    }
  }
}

/// Parámetros para filtrar notas
class GetFilteredNotesParams {
  final String? searchQuery;
  final List<String>? tags;
  final String? category;
  final bool? isPinned;
  final bool? isFavorite;
  final bool? isArchived;
  final bool? hasReminder;
  final bool? hasTasks;
  final DateTime? createdAfter;
  final DateTime? createdBefore;

  const GetFilteredNotesParams({
    this.searchQuery,
    this.tags,
    this.category,
    this.isPinned,
    this.isFavorite,
    this.isArchived,
    this.hasReminder,
    this.hasTasks,
    this.createdAfter,
    this.createdBefore,
  });
}
