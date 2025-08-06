import 'package:dartz/dartz.dart';
import '../../domain/entities/note.dart';
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
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final notes = await localDataSource.getAllNotes();
      return Right(notes.map((note) => note.toEntity()).toList());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note?>> getNoteById(String id) async {
    try {
      final note = await localDataSource.getNoteById(id);
      return Right(note?.toEntity());
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.createNote(noteModel);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      await localDataSource.updateNote(noteModel);
      return const Right(null);
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
      final notes = await localDataSource.getFilteredNotes(
        isPinned: isPinned,
        isArchived: isArchived,
        isFavorite: isFavorite,
        category: category,
        colorTag: colorTag,
        startDate: startDate,
        endDate: endDate,
        hasReminder: hasReminder,
        hasTasks: hasTasks,
        tags: tags,
      );
      return Right(notes.map((note) => note.toEntity()).toList());
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
  Future<Either<Failure, void>> restoreBackup(String backupData) async {
    try {
      // En una implementación real, esto parsearía el backup data
      final Map<String, dynamic> backup = {};
      await localDataSource.restoreBackup(backup);
      return const Right(null);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}
