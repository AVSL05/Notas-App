import 'package:dartz/dartz.dart' hide Task;
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';

/// Caso de uso para gestionar tareas en notas
class ManageNoteTasks {
  final NotesRepository repository;

  const ManageNoteTasks(this.repository);

  /// Añade una tarea a una nota
  Future<Either<Failure, Note>> addTask(String noteId, dynamic task) async {
    return await repository.addTaskToNote(noteId, task);
  }

  /// Actualiza una tarea en una nota
  Future<Either<Failure, Note>> updateTask(String noteId, dynamic task) async {
    return await repository.updateTaskInNote(noteId, task);
  }

  /// Elimina una tarea de una nota
  Future<Either<Failure, Note>> removeTask(String noteId, String taskId) async {
    return await repository.removeTaskFromNote(noteId, taskId);
  }

  /// Marca/desmarca una tarea como completada
  Future<Either<Failure, Note>> toggleTaskCompletion(String noteId, String taskId) async {
    return await repository.toggleTaskCompletion(noteId, taskId);
  }
}

/// Caso de uso para gestionar etiquetas
class ManageNoteTags {
  final NotesRepository repository;

  const ManageNoteTags(this.repository);

  /// Obtiene todas las etiquetas
  Future<Either<Failure, List<String>>> getAllTags() async {
    return await repository.getAllTags();
  }

  /// Añade una etiqueta a una nota
  Future<Either<Failure, Note>> addTag(String noteId, String tag) async {
    return await repository.addTagToNote(noteId, tag);
  }

  /// Elimina una etiqueta de una nota
  Future<Either<Failure, Note>> removeTag(String noteId, String tag) async {
    return await repository.removeTagFromNote(noteId, tag);
  }

  /// Elimina una etiqueta de todas las notas
  Future<Either<Failure, void>> deleteTag(String tag) async {
    return await repository.deleteTag(tag);
  }

  /// Renombra una etiqueta
  Future<Either<Failure, void>> renameTag(String oldTag, String newTag) async {
    return await repository.renameTag(oldTag, newTag);
  }
}

/// Caso de uso para gestionar recordatorios
class ManageNoteReminders {
  final NotesRepository repository;

  const ManageNoteReminders(this.repository);

  /// Establece un recordatorio
  Future<Either<Failure, Note>> setReminder(String noteId, DateTime reminderDate) async {
    return await repository.setReminder(noteId, reminderDate);
  }

  /// Elimina un recordatorio
  Future<Either<Failure, Note>> removeReminder(String noteId) async {
    return await repository.removeReminder(noteId);
  }

  /// Obtiene notas con recordatorios activos
  Future<Either<Failure, List<Note>>> getActiveReminders() async {
    return await repository.getNotesWithActiveReminders();
  }

  /// Obtiene notas con recordatorios vencidos
  Future<Either<Failure, List<Note>>> getOverdueReminders() async {
    return await repository.getNotesWithOverdueReminders();
  }
}
