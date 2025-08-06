import '../entities/note.dart';

/// Repositorio abstracto para operaciones de notas
abstract class NotesRepository {
  // ===== OPERACIONES BÁSICAS =====
  
  /// Obtiene todas las notas
  Future<List<Note>> getAllNotes();

  /// Obtiene una nota por ID
  Future<Note?> getNoteById(String id);

  /// Crea una nueva nota
  Future<Note> createNote(Note note);

  /// Actualiza una nota existente
  Future<Note> updateNote(Note note);

  /// Elimina una nota
  Future<void> deleteNote(String id);

  /// Elimina múltiples notas
  Future<void> deleteNotes(List<String> ids);

  // ===== BÚSQUEDA Y FILTROS =====

  /// Busca notas por texto
  Future<List<Note>> searchNotes(String query);

  /// Obtiene notas filtradas por múltiples criterios
  Future<List<Note>> getFilteredNotes({
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
  Future<List<Note>> getNotesByTag(String tag);

  /// Obtiene notas por categoría
  Future<List<Note>> getNotesByCategory(String category);

  /// Obtiene notas archivadas
  Future<List<Note>> getArchivedNotes();

  /// Obtiene notas favoritas
  Future<List<Note>> getFavoriteNotes();

  /// Obtiene notas fijadas
  Future<List<Note>> getPinnedNotes();

  // ===== OPERACIONES ESPECIALES =====

  /// Duplica una nota
  Future<Note> duplicateNote(String id);

  /// Archiva una nota
  Future<Note> archiveNote(String id);

  /// Desarchivar una nota
  Future<Note> unarchiveNote(String id);

  /// Marca/desmarca una nota como favorita
  Future<Note> toggleFavorite(String id);

  /// Fija/desfija una nota
  Future<Note> togglePin(String id);

  // ===== GESTIÓN DE TAREAS =====

  /// Añade una tarea a una nota
  Future<Note> addTaskToNote(String noteId, Task task);

  /// Actualiza una tarea en una nota
  Future<Note> updateTaskInNote(String noteId, Task task);

  /// Elimina una tarea de una nota
  Future<Note> removeTaskFromNote(String noteId, String taskId);

  /// Marca/desmarca una tarea como completada
  Future<Note> toggleTaskCompletion(String noteId, String taskId);

  // ===== GESTIÓN DE ETIQUETAS =====

  /// Obtiene todas las etiquetas disponibles
  Future<List<String>> getAllTags();

  /// Añade una etiqueta a una nota
  Future<Note> addTagToNote(String noteId, String tag);

  /// Elimina una etiqueta de una nota
  Future<Note> removeTagFromNote(String noteId, String tag);

  /// Elimina una etiqueta de todas las notas
  Future<void> deleteTag(String tag);

  /// Renombra una etiqueta en todas las notas
  Future<void> renameTag(String oldTag, String newTag);

  // ===== GESTIÓN DE CATEGORÍAS =====

  /// Obtiene todas las categorías disponibles
  Future<List<String>> getAllCategories();

  /// Cambia la categoría de una nota
  Future<Note> changeNoteCategory(String noteId, String? category);

  /// Elimina una categoría y desasigna de todas las notas
  Future<void> deleteCategory(String category);

  /// Renombra una categoría en todas las notas
  Future<void> renameCategory(String oldCategory, String newCategory);

  // ===== RECORDATORIOS =====

  /// Establece un recordatorio para una nota
  Future<Note> setReminder(String noteId, DateTime reminderDate);

  /// Elimina el recordatorio de una nota
  Future<Note> removeReminder(String noteId);

  /// Obtiene notas con recordatorios activos
  Future<List<Note>> getNotesWithActiveReminders();

  /// Obtiene notas con recordatorios vencidos
  Future<List<Note>> getNotesWithOverdueReminders();

  // ===== ESTADÍSTICAS =====

  /// Obtiene estadísticas generales de las notas
  Future<Map<String, dynamic>> getNotesStatistics();

  /// Obtiene el conteo de notas por categoría
  Future<Map<String, int>> getNoteCountByCategory();

  /// Obtiene el conteo de notas por etiqueta
  Future<Map<String, int>> getNoteCountByTag();

  // ===== IMPORTACIÓN/EXPORTACIÓN =====

  /// Exporta todas las notas a JSON
  Future<String> exportNotesToJson();

  /// Importa notas desde JSON
  Future<List<Note>> importNotesFromJson(String jsonData);

  /// Exporta una nota específica
  Future<Map<String, dynamic>> exportNote(String id);

  // ===== MANTENIMIENTO =====

  /// Limpia notas archivadas permanentemente
  Future<void> cleanupArchivedNotes();

  /// Hace copia de seguridad de todas las notas
  Future<void> backupNotes();

  /// Restaura notas desde copia de seguridad
  Future<void> restoreNotes(String backupData);
}
