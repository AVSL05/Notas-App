import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Caso de uso para buscar notas
class SearchNotes {
  final NotesRepository repository;

  const SearchNotes(this.repository);

  Future<List<Note>> call(String query) async {
    try {
      if (query.trim().isEmpty) {
        return await repository.getAllNotes();
      }
      return await repository.searchNotes(query);
    } catch (e) {
      throw Exception('Error al buscar notas: $e');
    }
  }
}

/// Caso de uso para obtener una nota por ID
class GetNoteById {
  final NotesRepository repository;

  const GetNoteById(this.repository);

  Future<Note?> call(String id) async {
    try {
      return await repository.getNoteById(id);
    } catch (e) {
      throw Exception('Error al obtener la nota: $e');
    }
  }
}

/// Caso de uso para duplicar una nota
class DuplicateNote {
  final NotesRepository repository;

  const DuplicateNote(this.repository);

  Future<Note> call(String id) async {
    try {
      return await repository.duplicateNote(id);
    } catch (e) {
      throw Exception('Error al duplicar la nota: $e');
    }
  }
}
