import 'package:dartz/dartz.dart' hide Task;
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para actualizar una nota
class UpdateNote {
  final NotesRepository repository;

  const UpdateNote(this.repository);

  Future<Either<Failure, Note>> call(Note note) async {
    final updatedNote = note.copyWith(
      updatedAt: DateTime.now(),
    );
    return await repository.updateNote(updatedNote);
  }
}

/// Caso de uso para eliminar una nota
class DeleteNote {
  final NotesRepository repository;

  const DeleteNote(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteNote(id);
  }
}

/// Caso de uso para eliminar múltiples notas
class DeleteMultipleNotes {
  final NotesRepository repository;

  const DeleteMultipleNotes(this.repository);

  Future<Either<Failure, void>> call(List<String> ids) async {
    return await repository.deleteNotes(ids);
  }
}
