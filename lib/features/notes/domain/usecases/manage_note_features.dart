import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Caso de uso para gestionar tareas en notas
class ManageNoteTasks {
  final NotesRepository repository;

  const ManageNoteTasks(this.repository);

  /// Añade una tarea a una nota
  Future<Note> addTask(String noteId, Task task) async {
    try {
      return await repository.addTaskToNote(noteId, task);
    } catch (e) {
      throw Exception('Error al añadir tarea: $e');
    }
  }

  /// Actualiza una tarea en una nota
  Future<Note> updateTask(String noteId, Task task) async {
    try {
      return await repository.updateTaskInNote(noteId, task);
    } catch (e) {
      throw Exception('Error al actualizar tarea: $e');
    }
  }

  /// Elimina una tarea de una nota
  Future<Note> removeTask(String noteId, String taskId) async {
    try {
      return await repository.removeTaskFromNote(noteId, taskId);
    } catch (e) {
      throw Exception('Error al eliminar tarea: $e');
    }
  }

  /// Marca/desmarca una tarea como completada
  Future<Note> toggleTaskCompletion(String noteId, String taskId) async {
    try {
      return await repository.toggleTaskCompletion(noteId, taskId);
    } catch (e) {
      throw Exception('Error al cambiar estado de tarea: $e');
    }
  }
}

/// Caso de uso para gestionar etiquetas
class ManageNoteTags {
  final NotesRepository repository;

  const ManageNoteTags(this.repository);

  /// Obtiene todas las etiquetas
  Future<List<String>> getAllTags() async {
    try {
      return await repository.getAllTags();
    } catch (e) {
      throw Exception('Error al obtener etiquetas: $e');
    }
  }

  /// Añade una etiqueta a una nota
  Future<Note> addTag(String noteId, String tag) async {
    try {
      return await repository.addTagToNote(noteId, tag);
    } catch (e) {
      throw Exception('Error al añadir etiqueta: $e');
    }
  }

  /// Elimina una etiqueta de una nota
  Future<Note> removeTag(String noteId, String tag) async {
    try {
      return await repository.removeTagFromNote(noteId, tag);
    } catch (e) {
      throw Exception('Error al eliminar etiqueta: $e');
    }
  }

  /// Elimina una etiqueta de todas las notas
  Future<void> deleteTag(String tag) async {
    try {
      await repository.deleteTag(tag);
    } catch (e) {
      throw Exception('Error al eliminar etiqueta completamente: $e');
    }
  }

  /// Renombra una etiqueta
  Future<void> renameTag(String oldTag, String newTag) async {
    try {
      await repository.renameTag(oldTag, newTag);
    } catch (e) {
      throw Exception('Error al renombrar etiqueta: $e');
    }
  }
}

/// Caso de uso para gestionar recordatorios
class ManageNoteReminders {
  final NotesRepository repository;

  const ManageNoteReminders(this.repository);

  /// Establece un recordatorio
  Future<Note> setReminder(String noteId, DateTime reminderDate) async {
    try {
      return await repository.setReminder(noteId, reminderDate);
    } catch (e) {
      throw Exception('Error al establecer recordatorio: $e');
    }
  }

  /// Elimina un recordatorio
  Future<Note> removeReminder(String noteId) async {
    try {
      return await repository.removeReminder(noteId);
    } catch (e) {
      throw Exception('Error al eliminar recordatorio: $e');
    }
  }

  /// Obtiene notas con recordatorios activos
  Future<List<Note>> getActiveReminders() async {
    try {
      return await repository.getNotesWithActiveReminders();
    } catch (e) {
      throw Exception('Error al obtener recordatorios activos: $e');
    }
  }

  /// Obtiene notas con recordatorios vencidos
  Future<List<Note>> getOverdueReminders() async {
    try {
      return await repository.getNotesWithOverdueReminders();
    } catch (e) {
      throw Exception('Error al obtener recordatorios vencidos: $e');
    }
  }
}
