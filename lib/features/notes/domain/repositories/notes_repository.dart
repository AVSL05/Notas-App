import 'package:dartz/dartz.dart' hide Task;
import '../entities/note.dart';
import '../../../../core/error/failures.dart';

/// Repositorio abstracto para operaciones de notas
abstract class NotesRepository {
  // ===== OPERACIONES BÁSICAS =====
  
  /// Obtiene todas las notas
  Future<Either<Failure, List<Note>>> getAllNotes();

  /// Obtiene una nota por ID
  Future<Either<Failure, Note?>> getNoteById(String id);

  /// Crea una nueva nota
  Future<Either<Failure, Note>> createNote(Note note);

  /// Actualiza una nota existente
  Future<Either<Failure, Note>> updateNote(Note note);

  /// Elimina una nota
  Future<Either<Failure, void>> deleteNote(String id);

  /// Elimina múltiples notas
  Future<Either<Failure, void>> deleteNotes(List<String> ids);

  // ===== BÚSQUEDA Y FILTROS =====

  /// Busca notas por texto
  Future<Either<Failure, List<Note>>> searchNotes(String query);

  /// Obtiene notas filtradas por múltiples criterios
  Future<Either<Failure, List<Note>>> getFilteredNotes({
    String? searchQuery,
    List<String>? tags,
    String? category,
    bool? isPinned,
    bool? isFavorite,
    bool? isArchived,
    bool? hasReminder,
    bool? hasTasks,
    DateTime? createdAfter,
    DateTime? createdBefore,
  });

  /// Obtiene notas por etiqueta
  Future<Either<Failure, List<Note>>> getNotesByTag(String tag);

  /// Obtiene notas por categoría
  Future<Either<Failure, List<Note>>> getNotesByCategory(String category);

  /// Obtiene notas archivadas
  Future<Either<Failure, List<Note>>> getArchivedNotes();

  /// Obtiene notas favoritas
  Future<Either<Failure, List<Note>>> getFavoriteNotes();

  /// Obtiene notas fijadas
  Future<Either<Failure, List<Note>>> getPinnedNotes();

  // ===== OPERACIONES ESPECIALES =====

  /// Duplica una nota
  Future<Either<Failure, Note>> duplicateNote(String id);

  /// Archiva una nota
  Future<Either<Failure, Note>> archiveNote(String id);

  /// Desarchivar una nota
  Future<Either<Failure, Note>> unarchiveNote(String id);

  /// Marca/desmarca una nota como favorita
  Future<Either<Failure, Note>> toggleFavorite(String id);

  /// Fija/desfija una nota
  Future<Either<Failure, Note>> togglePin(String id);

  // ===== GESTIÓN DE TAREAS =====

  /// Añade una tarea a una nota
  Future<Either<Failure, Note>> addTaskToNote(String noteId, dynamic task);

  /// Actualiza una tarea en una nota
  Future<Either<Failure, Note>> updateTaskInNote(String noteId, dynamic task);

  /// Elimina una tarea de una nota
  Future<Either<Failure, Note>> removeTaskFromNote(String noteId, String taskId);

  /// Marca/desmarca una tarea como completada
  Future<Either<Failure, Note>> toggleTaskCompletion(String noteId, String taskId);

  // ===== GESTIÓN DE ETIQUETAS =====

  /// Obtiene todas las etiquetas disponibles
  Future<Either<Failure, List<String>>> getAllTags();

  /// Añade una etiqueta a una nota
  Future<Either<Failure, Note>> addTagToNote(String noteId, String tag);

  /// Elimina una etiqueta de una nota
  Future<Either<Failure, Note>> removeTagFromNote(String noteId, String tag);

  /// Elimina una etiqueta de todas las notas
  Future<Either<Failure, void>> deleteTag(String tag);

  /// Renombra una etiqueta en todas las notas
  Future<Either<Failure, void>> renameTag(String oldTag, String newTag);

  // ===== GESTIÓN DE CATEGORÍAS =====

  /// Obtiene todas las categorías disponibles
  Future<Either<Failure, List<String>>> getAllCategories();

  /// Cambia la categoría de una nota
  Future<Either<Failure, Note>> changeNoteCategory(String noteId, String? category);

  /// Elimina una categoría y desasigna de todas las notas
  Future<Either<Failure, void>> deleteCategory(String category);

  /// Renombra una categoría en todas las notas
  Future<Either<Failure, void>> renameCategory(String oldCategory, String newCategory);

  // ===== RECORDATORIOS =====

  /// Establece un recordatorio para una nota
  Future<Either<Failure, Note>> setReminder(String noteId, DateTime reminderDate);

  /// Elimina el recordatorio de una nota
  Future<Either<Failure, Note>> removeReminder(String noteId);

  /// Obtiene notas con recordatorios activos
  Future<Either<Failure, List<Note>>> getNotesWithActiveReminders();

  /// Obtiene notas con recordatorios vencidos
  Future<Either<Failure, List<Note>>> getNotesWithOverdueReminders();

  // ===== ESTADÍSTICAS =====

  /// Obtiene estadísticas generales de las notas
  Future<Either<Failure, Map<String, dynamic>>> getNotesStatistics();

  /// Obtiene el conteo de notas por categoría
  Future<Either<Failure, Map<String, int>>> getNoteCountByCategory();

  /// Obtiene el conteo de notas por etiqueta
  Future<Either<Failure, Map<String, int>>> getNoteCountByTag();

  // ===== IMPORTACIÓN/EXPORTACIÓN =====

  /// Exporta todas las notas a JSON
  Future<Either<Failure, String>> exportNotesToJson();

  /// Importa notas desde JSON
  Future<Either<Failure, List<Note>>> importNotesFromJson(String jsonData);

  /// Exporta una nota específica
  Future<Either<Failure, Map<String, dynamic>>> exportNote(String id);

  // ===== MANTENIMIENTO =====

  /// Limpia notas archivadas permanentemente
  Future<Either<Failure, void>> cleanupArchivedNotes();

  /// Hace copia de seguridad de todas las notas
  Future<Either<Failure, void>> backupNotes();

  /// Restaura notas desde copia de seguridad
  Future<Either<Failure, void>> restoreNotes(String backupData);
}
