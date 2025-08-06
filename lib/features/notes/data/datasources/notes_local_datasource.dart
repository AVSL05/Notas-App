import 'package:hive/hive.dart';
import '../models/note_model.dart';
import '../../domain/entities/note.dart';

/// Interfaz para el datasource local de notas
abstract class NotesLocalDataSource {
  /// Obtiene todas las notas
  Future<List<NoteModel>> getAllNotes();

  /// Obtiene una nota por ID
  Future<NoteModel?> getNoteById(String id);

  /// Crea una nueva nota
  Future<void> createNote(NoteModel note);

  /// Actualiza una nota existente
  Future<void> updateNote(NoteModel note);

  /// Elimina una nota por ID
  Future<void> deleteNote(String id);

  /// Elimina múltiples notas
  Future<void> deleteMultipleNotes(List<String> ids);

  /// Busca notas por consulta
  Future<List<NoteModel>> searchNotes(String query);

  /// Obtiene notas filtradas
  Future<List<NoteModel>> getFilteredNotes({
    bool? isPinned,
    bool? isArchived,
    bool? isFavorite,
    String? category,
    String? colorTag,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasReminder,
    bool? hasTasks,
    List<String>? tags,
  });

  /// Obtiene notas archivadas
  Future<List<NoteModel>> getArchivedNotes();

  /// Obtiene notas favoritas
  Future<List<NoteModel>> getFavoriteNotes();

  /// Obtiene notas fijadas
  Future<List<NoteModel>> getPinnedNotes();

  /// Obtiene notas por categoría
  Future<List<NoteModel>> getNotesByCategory(String category);

  /// Obtiene notas con recordatorios
  Future<List<NoteModel>> getNotesWithReminders();

  /// Obtiene notas con tareas pendientes
  Future<List<NoteModel>> getNotesWithPendingTasks();

  /// Obtiene todas las categorías únicas
  Future<List<String>> getAllCategories();

  /// Obtiene todos los tags únicos
  Future<List<String>> getAllTags();

  /// Obtiene estadísticas de las notas
  Future<Map<String, int>> getNotesStatistics();

  /// Limpia todas las notas (usar con precaución)
  Future<void> clearAllNotes();

  /// Exporta notas a JSON
  Future<List<Map<String, dynamic>>> exportNotesToJson();

  /// Importa notas desde JSON
  Future<void> importNotesFromJson(List<Map<String, dynamic>> notesJson);

  /// Crea backup de las notas
  Future<Map<String, dynamic>> createBackup();

  /// Restaura backup de las notas
  Future<void> restoreBackup(Map<String, dynamic> backup);
}

/// Implementación del datasource local usando Hive
class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  static const String _boxName = 'notes_box';
  late Box<NoteModel> _notesBox;

  /// Inicializa el datasource
  Future<void> init() async {
    _notesBox = await Hive.openBox<NoteModel>(_boxName);
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final notes = _notesBox.values.toList();
      // Ordenar por fecha de actualización (más recientes primero)
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      throw Exception('Error al obtener todas las notas: $e');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    try {
      return _notesBox.get(id);
    } catch (e) {
      throw Exception('Error al obtener la nota con ID $id: $e');
    }
  }

  @override
  Future<void> createNote(NoteModel note) async {
    try {
      await _notesBox.put(note.id, note);
    } catch (e) {
      throw Exception('Error al crear la nota: $e');
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      if (!_notesBox.containsKey(note.id)) {
        throw Exception('La nota con ID ${note.id} no existe');
      }
      await _notesBox.put(note.id, note);
    } catch (e) {
      throw Exception('Error al actualizar la nota: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      if (!_notesBox.containsKey(id)) {
        throw Exception('La nota con ID $id no existe');
      }
      await _notesBox.delete(id);
    } catch (e) {
      throw Exception('Error al eliminar la nota: $e');
    }
  }

  @override
  Future<void> deleteMultipleNotes(List<String> ids) async {
    try {
      await _notesBox.deleteAll(ids);
    } catch (e) {
      throw Exception('Error al eliminar múltiples notas: $e');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllNotes();
      }

      final notes = _notesBox.values.where((note) {
        final lowerQuery = query.toLowerCase();
        return note.title.toLowerCase().contains(lowerQuery) ||
               note.content.toLowerCase().contains(lowerQuery) ||
               note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
               note.tasks.any((task) => 
                 task.title.toLowerCase().contains(lowerQuery) ||
                 (task.description?.toLowerCase().contains(lowerQuery) ?? false)
               );
      }).toList();

      // Ordenar por relevancia (coincidencias en título primero)
      notes.sort((a, b) {
        final aTitle = a.title.toLowerCase().contains(query.toLowerCase());
        final bTitle = b.title.toLowerCase().contains(query.toLowerCase());
        
        if (aTitle && !bTitle) return -1;
        if (!aTitle && bTitle) return 1;
        
        return b.updatedAt.compareTo(a.updatedAt);
      });

      return notes;
    } catch (e) {
      throw Exception('Error al buscar notas: $e');
    }
  }

  @override
  Future<List<NoteModel>> getFilteredNotes({
    bool? isPinned,
    bool? isArchived,
    bool? isFavorite,
    String? category,
    String? colorTag,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasReminder,
    bool? hasTasks,
    List<String>? tags,
  }) async {
    try {
      var notes = _notesBox.values.where((note) {
        // Filtro por fijado
        if (isPinned != null && note.isPinned != isPinned) return false;
        
        // Filtro por archivado
        if (isArchived != null && note.isArchived != isArchived) return false;
        
        // Filtro por favorito
        if (isFavorite != null && note.isFavorite != isFavorite) return false;
        
        // Filtro por categoría
        if (category != null && note.category != category) return false;
        
        // Filtro por color
        if (colorTag != null && note.colorTag != colorTag) return false;
        
        // Filtro por fecha de inicio
        if (startDate != null && note.createdAt.isBefore(startDate)) return false;
        
        // Filtro por fecha de fin
        if (endDate != null && note.createdAt.isAfter(endDate)) return false;
        
        // Filtro por recordatorio
        if (hasReminder != null) {
          if (hasReminder && note.reminderDate == null) return false;
          if (!hasReminder && note.reminderDate != null) return false;
        }
        
        // Filtro por tareas
        if (hasTasks != null) {
          if (hasTasks && note.tasks.isEmpty) return false;
          if (!hasTasks && note.tasks.isNotEmpty) return false;
        }
        
        // Filtro por tags
        if (tags != null && tags.isNotEmpty) {
          if (!tags.any((tag) => note.tags.contains(tag))) return false;
        }
        
        return true;
      }).toList();

      // Ordenar por fecha de actualización
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return notes;
    } catch (e) {
      throw Exception('Error al filtrar notas: $e');
    }
  }

  @override
  Future<List<NoteModel>> getArchivedNotes() async {
    return await getFilteredNotes(isArchived: true);
  }

  @override
  Future<List<NoteModel>> getFavoriteNotes() async {
    return await getFilteredNotes(isFavorite: true);
  }

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    return await getFilteredNotes(isPinned: true);
  }

  @override
  Future<List<NoteModel>> getNotesByCategory(String category) async {
    return await getFilteredNotes(category: category);
  }

  @override
  Future<List<NoteModel>> getNotesWithReminders() async {
    return await getFilteredNotes(hasReminder: true);
  }

  @override
  Future<List<NoteModel>> getNotesWithPendingTasks() async {
    try {
      final notes = _notesBox.values.where((note) {
        return note.tasks.any((task) => !task.isCompleted);
      }).toList();
      
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      throw Exception('Error al obtener notas con tareas pendientes: $e');
    }
  }

  @override
  Future<List<String>> getAllCategories() async {
    try {
      final categories = _notesBox.values
          .where((note) => note.category != null)
          .map((note) => note.category!)
          .toSet()
          .toList();
      
      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  @override
  Future<List<String>> getAllTags() async {
    try {
      final allTags = <String>{};
      
      for (final note in _notesBox.values) {
        allTags.addAll(note.tags);
      }
      
      final tagsList = allTags.toList();
      tagsList.sort();
      return tagsList;
    } catch (e) {
      throw Exception('Error al obtener tags: $e');
    }
  }

  @override
  Future<Map<String, int>> getNotesStatistics() async {
    try {
      final notes = _notesBox.values.toList();
      
      return {
        'total': notes.length,
        'pinned': notes.where((note) => note.isPinned).length,
        'archived': notes.where((note) => note.isArchived).length,
        'favorites': notes.where((note) => note.isFavorite).length,
        'withReminders': notes.where((note) => note.reminderDate != null).length,
        'withTasks': notes.where((note) => note.tasks.isNotEmpty).length,
        'completedTasks': notes
            .expand((note) => note.tasks)
            .where((task) => task.isCompleted)
            .length,
        'pendingTasks': notes
            .expand((note) => note.tasks)
            .where((task) => !task.isCompleted)
            .length,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  @override
  Future<void> clearAllNotes() async {
    try {
      await _notesBox.clear();
    } catch (e) {
      throw Exception('Error al limpiar todas las notas: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> exportNotesToJson() async {
    try {
      final notes = await getAllNotes();
      return notes.map((note) => note.toJson()).toList();
    } catch (e) {
      throw Exception('Error al exportar notas: $e');
    }
  }

  @override
  Future<void> importNotesFromJson(List<Map<String, dynamic>> notesJson) async {
    try {
      for (final noteJson in notesJson) {
        final note = NoteModel.fromJson(noteJson);
        await _notesBox.put(note.id, note);
      }
    } catch (e) {
      throw Exception('Error al importar notas: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createBackup() async {
    try {
      final notes = await exportNotesToJson();
      return {
        'version': '1.0',
        'createdAt': DateTime.now().toIso8601String(),
        'notes': notes,
      };
    } catch (e) {
      throw Exception('Error al crear backup: $e');
    }
  }

  @override
  Future<void> restoreBackup(Map<String, dynamic> backup) async {
    try {
      final notes = (backup['notes'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      
      // Limpiar datos existentes
      await clearAllNotes();
      
      // Importar datos del backup
      await importNotesFromJson(notes);
    } catch (e) {
      throw Exception('Error al restaurar backup: $e');
    }
  }
}
