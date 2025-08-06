import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

/// Eventos del BLoC de notas
abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todas las notas
class LoadNotesEvent extends NotesEvent {}

/// Evento para cargar una nota específica
class LoadNoteByIdEvent extends NotesEvent {
  final String id;

  const LoadNoteByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para crear una nueva nota
class CreateNoteEvent extends NotesEvent {
  final String title;
  final String content;
  final List<Task>? tasks;
  final List<String>? tags;
  final DateTime? reminderDate;
  final String? colorTag;
  final String? category;

  const CreateNoteEvent({
    required this.title,
    required this.content,
    this.tasks,
    this.tags,
    this.reminderDate,
    this.colorTag,
    this.category,
  });

  @override
  List<Object?> get props => [
        title,
        content,
        tasks,
        tags,
        reminderDate,
        colorTag,
        category,
      ];
}

/// Evento para actualizar una nota
class UpdateNoteEvent extends NotesEvent {
  final Note note;

  const UpdateNoteEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Evento para eliminar una nota
class DeleteNoteEvent extends NotesEvent {
  final String id;

  const DeleteNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para eliminar múltiples notas
class DeleteMultipleNotesEvent extends NotesEvent {
  final List<String> ids;

  const DeleteMultipleNotesEvent({required this.ids});

  @override
  List<Object?> get props => [ids];
}

/// Evento para buscar notas
class SearchNotesEvent extends NotesEvent {
  final String query;

  const SearchNotesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Evento para limpiar búsqueda
class ClearSearchEvent extends NotesEvent {}

/// Evento para filtrar notas
class FilterNotesEvent extends NotesEvent {
  final bool? isPinned;
  final bool? isArchived;
  final bool? isFavorite;
  final String? category;
  final String? colorTag;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? hasReminder;
  final bool? hasTasks;
  final List<String>? tags;

  const FilterNotesEvent({
    this.isPinned,
    this.isArchived,
    this.isFavorite,
    this.category,
    this.colorTag,
    this.startDate,
    this.endDate,
    this.hasReminder,
    this.hasTasks,
    this.tags,
  });

  @override
  List<Object?> get props => [
        isPinned,
        isArchived,
        isFavorite,
        category,
        colorTag,
        startDate,
        endDate,
        hasReminder,
        hasTasks,
        tags,
      ];
}

/// Evento para cargar notas archivadas
class LoadArchivedNotesEvent extends NotesEvent {}

/// Evento para cargar notas favoritas
class LoadFavoriteNotesEvent extends NotesEvent {}

/// Evento para cargar notas fijadas
class LoadPinnedNotesEvent extends NotesEvent {}

/// Evento para cargar notas por categoría
class LoadNotesByCategoryEvent extends NotesEvent {
  final String category;

  const LoadNotesByCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Evento para fijar/desfijar nota
class TogglePinNoteEvent extends NotesEvent {
  final String id;

  const TogglePinNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para archivar/desarchivar nota
class ToggleArchiveNoteEvent extends NotesEvent {
  final String id;

  const ToggleArchiveNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para marcar/desmarcar como favorito
class ToggleFavoriteNoteEvent extends NotesEvent {
  final String id;

  const ToggleFavoriteNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para establecer color de nota
class SetNoteColorEvent extends NotesEvent {
  final String id;
  final String? colorTag;

  const SetNoteColorEvent({
    required this.id,
    this.colorTag,
  });

  @override
  List<Object?> get props => [id, colorTag];
}

/// Evento para establecer categoría de nota
class SetNoteCategoryEvent extends NotesEvent {
  final String id;
  final String? category;

  const SetNoteCategoryEvent({
    required this.id,
    this.category,
  });

  @override
  List<Object?> get props => [id, category];
}

/// Evento para establecer recordatorio
class SetNoteReminderEvent extends NotesEvent {
  final String id;
  final DateTime? reminderDate;

  const SetNoteReminderEvent({
    required this.id,
    this.reminderDate,
  });

  @override
  List<Object?> get props => [id, reminderDate];
}

/// Evento para duplicar nota
class DuplicateNoteEvent extends NotesEvent {
  final String id;

  const DuplicateNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Evento para agregar tarea a nota
class AddTaskToNoteEvent extends NotesEvent {
  final String noteId;
  final Task task;

  const AddTaskToNoteEvent({
    required this.noteId,
    required this.task,
  });

  @override
  List<Object?> get props => [noteId, task];
}

/// Evento para actualizar tarea en nota
class UpdateTaskInNoteEvent extends NotesEvent {
  final String noteId;
  final Task task;

  const UpdateTaskInNoteEvent({
    required this.noteId,
    required this.task,
  });

  @override
  List<Object?> get props => [noteId, task];
}

/// Evento para eliminar tarea de nota
class RemoveTaskFromNoteEvent extends NotesEvent {
  final String noteId;
  final String taskId;

  const RemoveTaskFromNoteEvent({
    required this.noteId,
    required this.taskId,
  });

  @override
  List<Object?> get props => [noteId, taskId];
}

/// Evento para agregar tag a nota
class AddTagToNoteEvent extends NotesEvent {
  final String noteId;
  final String tag;

  const AddTagToNoteEvent({
    required this.noteId,
    required this.tag,
  });

  @override
  List<Object?> get props => [noteId, tag];
}

/// Evento para eliminar tag de nota
class RemoveTagFromNoteEvent extends NotesEvent {
  final String noteId;
  final String tag;

  const RemoveTagFromNoteEvent({
    required this.noteId,
    required this.tag,
  });

  @override
  List<Object?> get props => [noteId, tag];
}

/// Evento para cargar estadísticas
class LoadNotesStatisticsEvent extends NotesEvent {}

/// Evento para cargar metadatos (categorías y tags)
class LoadNotesMetadataEvent extends NotesEvent {}

/// Evento para crear backup
class CreateBackupEvent extends NotesEvent {}

/// Evento para restaurar backup
class RestoreBackupEvent extends NotesEvent {
  final String backupData;

  const RestoreBackupEvent({required this.backupData});

  @override
  List<Object?> get props => [backupData];
}

/// Evento para exportar notas
class ExportNotesEvent extends NotesEvent {}

/// Evento para importar notas
class ImportNotesEvent extends NotesEvent {
  final String jsonData;

  const ImportNotesEvent({required this.jsonData});

  @override
  List<Object?> get props => [jsonData];
}

/// Evento para limpiar todas las notas
class ClearAllNotesEvent extends NotesEvent {}
