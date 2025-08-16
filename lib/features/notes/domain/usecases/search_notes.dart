import 'package:dartz/dartz.dart' hide Task;
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para buscar notas
class SearchNotes {
  final NotesRepository repository;

  const SearchNotes(this.repository);

  Future<Either<Failure, List<Note>>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getAllNotes();
    }
    return await repository.searchNotes(query);
  }
}

/// Caso de uso para obtener una nota por ID
class GetNoteById {
  final NotesRepository repository;

  const GetNoteById(this.repository);

  Future<Either<Failure, Note?>> call(String id) async {
    return await repository.getNoteById(id);
  }
}

/// Caso de uso para duplicar una nota
class DuplicateNote {
  final NotesRepository repository;

  const DuplicateNote(this.repository);

  Future<Either<Failure, Note>> call(String id) async {
    return await repository.duplicateNote(id);
  }
}
