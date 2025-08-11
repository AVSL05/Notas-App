import 'package:dartz/dartz.dart';
import '../../domain/entities/note.dart' as entities;
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../models/note_model.dart';
import '../../../../core/error/failures.dart';

/// Implementación del repositorio de notas
class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<entities.Note>>> getAllNotes() async {
    try {
      final notes = await localDataSource.getAllNotes();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note?>> getNoteById(String id) async {
    try {
      final note = await localDataSource.getNoteById(id);
      return Right(note?.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> createNote(entities.Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.createNote(noteModel);
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> updateNote(entities.Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.updateNote(noteModel);
      return Right(noteModel.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMultipleNotes(List<String> ids) async {
    try {
      await localDataSource.deleteMultipleNotes(ids);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final notes = await localDataSource.searchNotes(query);
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final notes = await localDataSource.getFilteredNotes(
        isPinned: isPinned,
        isArchived: isArchived,
        isFavorite: isFavorite,
        category: category,
        colorTag: null, // Eliminamos colorTag ya que no está en la interfaz
        startDate: createdAfter, // Mapear createdAfter a startDate
        endDate: createdBefore, // Mapear createdBefore a endDate
        hasReminder: hasReminder,
        hasTasks: hasTasks,
        tags: tags,
      );
      
      // Aplicar filtro de búsqueda si se proporciona
      var filteredNotes = notes.map((note) => note.toEntity()).toList();
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredNotes = filteredNotes.where((note) =>
            note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }
      
      return Right(filteredNotes);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getArchivedNotes() async {
    try {
      final notes = await localDataSource.getArchivedNotes();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getFavoriteNotes() async {
    try {
      final notes = await localDataSource.getFavoriteNotes();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getPinnedNotes() async {
    try {
      final notes = await localDataSource.getPinnedNotes();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByCategory(String category) async {
    try {
      final notes = await localDataSource.getNotesByCategory(category);
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesWithReminders() async {
    try {
      final notes = await localDataSource.getNotesWithReminders();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesWithPendingTasks() async {
    try {
      final notes = await localDataSource.getNotesWithPendingTasks();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> pinNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isPinned: true,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> unpinNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isPinned: false,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> archiveNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isArchived: true,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> unarchiveNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isArchived: false,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> favoriteNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isFavorite: true,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> unfavoriteNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        isFavorite: false,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> setNoteColorTag(String id, String? colorTag) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        colorTag: colorTag,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> setNoteCategory(String id, String? category) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        category: category,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> setNoteReminder(String id, DateTime? reminderDate) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedNote = noteModel.copyWith(
        reminderDate: reminderDate,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> addTaskToNote(String noteId, Task task) async {
    try {
      final noteModel = await localDataSource.getNoteById(noteId);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final taskModel = TaskModel.fromEntity(task);
      final updatedTasks = List<TaskModel>.from(noteModel.tasks)..add(taskModel);
      
      final updatedNote = noteModel.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateTaskInNote(String noteId, Task task) async {
    try {
      final noteModel = await localDataSource.getNoteById(noteId);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final taskIndex = noteModel.tasks.indexWhere((t) => t.id == task.id);
      if (taskIndex == -1) {
        return Left(LocalFailure(message: 'Tarea no encontrada'));
      }
      
      final updatedTasks = List<TaskModel>.from(noteModel.tasks);
      updatedTasks[taskIndex] = TaskModel.fromEntity(task);
      
      final updatedNote = noteModel.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> removeTaskFromNote(String noteId, String taskId) async {
    try {
      final noteModel = await localDataSource.getNoteById(noteId);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedTasks = noteModel.tasks.where((task) => task.id != taskId).toList();
      
      final updatedNote = noteModel.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> addTagToNote(String noteId, String tag) async {
    try {
      final noteModel = await localDataSource.getNoteById(noteId);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      if (noteModel.tags.contains(tag)) {
        return Right(noteModel.toEntity()); // Tag ya existe
      }
      
      final updatedTags = List<String>.from(noteModel.tags)..add(tag);
      
      final updatedNote = noteModel.copyWith(
        tags: updatedTags,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> removeTagFromNote(String noteId, String tag) async {
    try {
      final noteModel = await localDataSource.getNoteById(noteId);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final updatedTags = noteModel.tags.where((t) => t != tag).toList();
      
      final updatedNote = noteModel.copyWith(
        tags: updatedTags,
        updatedAt: DateTime.now(),
      );
      
      await localDataSource.updateNote(updatedNote);
      return Right(updatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> duplicateNote(String id) async {
    try {
      final noteModel = await localDataSource.getNoteById(id);
      if (noteModel == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      
      final now = DateTime.now();
      final duplicatedNote = noteModel.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${noteModel.title} (Copia)',
        createdAt: now,
        updatedAt: now,
        isPinned: false, // Las copias no se fijan automáticamente
        reminderDate: null, // Las copias no heredan recordatorios
      );
      
      await localDataSource.createNote(duplicatedNote);
      return Right(duplicatedNote.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(categories);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllTags() async {
    try {
      final tags = await localDataSource.getAllTags();
      return Right(tags);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getNotesStatistics() async {
    try {
      final statistics = await localDataSource.getNotesStatistics();
      return Right(statistics);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllNotes() async {
    try {
      await localDataSource.clearAllNotes();
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportNotesToJson() async {
    try {
      final notesJson = await localDataSource.exportNotesToJson();
      // En una implementación real, esto podría convertirse a un string JSON
      // y guardarse en un archivo o enviarse por compartir
      return Right(notesJson.toString());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> importNotesFromJson(String jsonData) async {
    try {
      // En una implementación real, esto parsearía el JSON string
      // Por ahora, asumimos que ya tenemos la lista de mapas
      final List<Map<String, dynamic>> notesJson = [];
      await localDataSource.importNotesFromJson(notesJson);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createBackup() async {
    try {
      final backup = await localDataSource.createBackup();
      return Right(backup.toString());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreNotes(String backupData) async {
    try {
      // En una implementación real, esto parsearía el backup data
      final Map<String, dynamic> backup = {};
      await localDataSource.restoreBackup(backup);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  // ===== MÉTODOS FALTANTES - IMPLEMENTACIONES BÁSICAS =====

  @override
  Future<Either<Failure, entities.Note>> addTaskToNote(String noteId, entities.Task task) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Aquí iría la lógica para agregar la tarea
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportNotesToJson() async {
    try {
      // Implementación básica - devolver JSON vacío por ahora
      return const Right('{}');
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entities.Note>>> importNotesFromJson(String jsonData) async {
    try {
      // Implementación básica - devolver lista vacía por ahora
      return const Right([]);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> exportNote(String id) async {
    try {
      final note = await localDataSource.getNoteById(id);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      return Right(note.toJson());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> updateTaskInNote(String noteId, entities.Task task) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> removeTaskFromNote(String noteId, String taskId) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> toggleTaskCompletion(String noteId, String taskId) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllTags() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final allTags = <String>{};
      for (final note in notes) {
        allTags.addAll(note.tags);
      }
      return Right(allTags.toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> addTagToNote(String noteId, String tag) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> removeTagFromNote(String noteId, String tag) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTag(String tag) async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> renameTag(String oldTag, String newTag) async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllCategories() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final allCategories = <String>{};
      for (final note in notes) {
        if (note.category != null) {
          allCategories.add(note.category!);
        }
      }
      return Right(allCategories.toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> changeNoteCategory(String noteId, String? category) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String category) async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> renameCategory(String oldCategory, String newCategory) async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> setReminder(String noteId, DateTime reminderDate) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Note>> removeReminder(String noteId) async {
    try {
      final note = await localDataSource.getNoteById(noteId);
      if (note == null) {
        return Left(LocalFailure(message: 'Nota no encontrada'));
      }
      // Implementación básica
      return Right(note.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entities.Note>>> getNotesWithActiveReminders() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final now = DateTime.now();
      final notesWithReminders = notes
          .where((note) => note.reminderDate != null && note.reminderDate!.isAfter(now))
          .map((note) => note.toEntity())
          .toList();
      return Right(notesWithReminders);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entities.Note>>> getNotesWithOverdueReminders() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final now = DateTime.now();
      final overdueNotes = notes
          .where((note) => note.reminderDate != null && note.reminderDate!.isBefore(now))
          .map((note) => note.toEntity())
          .toList();
      return Right(overdueNotes);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getNotesStatistics() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final stats = {
        'totalNotes': notes.length,
        'pinnedNotes': notes.where((n) => n.isPinned).length,
        'favoriteNotes': notes.where((n) => n.isFavorite).length,
        'archivedNotes': notes.where((n) => n.isArchived).length,
      };
      return Right(stats);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getNoteCountByCategory() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final Map<String, int> categoryCounts = {};
      for (final note in notes) {
        final category = note.category ?? 'Sin categoría';
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }
      return Right(categoryCounts);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getNoteCountByTag() async {
    try {
      final notes = await localDataSource.getAllNotes();
      final Map<String, int> tagCounts = {};
      for (final note in notes) {
        for (final tag in note.tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }
      return Right(tagCounts);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cleanupArchivedNotes() async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> backupNotes() async {
    try {
      // Implementación básica
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}
