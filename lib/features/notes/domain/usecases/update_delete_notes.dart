import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Caso de uso para actualizar una nota
class UpdateNote {
  final NotesRepository repository;

  const UpdateNote(this.repository);

  Future<Note> call(Note note) async {
    try {
      final updatedNote = note.copyWith(
        updatedAt: DateTime.now(),
      );
      return await repository.updateNote(updatedNote);
    } catch (e) {
      throw Exception('Error al actualizar la nota: $e');
    }
  }
}

/// Caso de uso para eliminar una nota
class DeleteNote {
  final NotesRepository repository;

  const DeleteNote(this.repository);

  Future<void> call(String id) async {
    try {
      await repository.deleteNote(id);
    } catch (e) {
      throw Exception('Error al eliminar la nota: $e');
    }
  }
}

/// Caso de uso para eliminar múltiples notas
class DeleteMultipleNotes {
  final NotesRepository repository;

  const DeleteMultipleNotes(this.repository);

  Future<void> call(List<String> ids) async {
    try {
      await repository.deleteNotes(ids);
    } catch (e) {
      throw Exception('Error al eliminar las notas: $e');
    }
  }
}
