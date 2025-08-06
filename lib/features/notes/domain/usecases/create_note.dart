import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Caso de uso para crear una nueva nota
class CreateNote {
  final NotesRepository repository;

  const CreateNote(this.repository);

  Future<Note> call(CreateNoteParams params) async {
    try {
      final note = Note(
        id: params.id,
        title: params.title,
        content: params.content,
        tasks: params.tasks,
        tags: params.tags,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        reminderDate: params.reminderDate,
        isPinned: params.isPinned,
        colorTag: params.colorTag,
        isArchived: false,
        isFavorite: params.isFavorite,
        category: params.category,
      );

      return await repository.createNote(note);
    } catch (e) {
      throw Exception('Error al crear la nota: $e');
    }
  }
}

/// Parámetros para crear una nota
class CreateNoteParams {
  final String id;
  final String title;
  final String content;
  final List<Task> tasks;
  final List<String> tags;
  final DateTime? reminderDate;
  final bool isPinned;
  final String colorTag;
  final bool isFavorite;
  final String? category;

  const CreateNoteParams({
    required this.id,
    required this.title,
    this.content = '',
    this.tasks = const [],
    this.tags = const [],
    this.reminderDate,
    this.isPinned = false,
    this.colorTag = 'default',
    this.isFavorite = false,
    this.category,
  });
}
