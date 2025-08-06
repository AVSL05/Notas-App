import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/update_delete_notes.dart';
import '../../domain/usecases/search_notes.dart';
import '../../domain/usecases/manage_note_features.dart';
import 'notes_event.dart';
import 'notes_state.dart';

/// BLoC principal para manejar el estado de las notas
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final CreateNote createNote;
  final GetAllNotes getAllNotes;
  final GetFilteredNotes getFilteredNotes;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final DeleteMultipleNotes deleteMultipleNotes;
  final SearchNotes searchNotes;
  final GetNoteById getNoteById;
  final DuplicateNote duplicateNote;
  final ManageNoteTasks manageNoteTasks;
  final ManageNoteTags manageNoteTags;
  final ManageNoteReminders manageNoteReminders;
  
  final Uuid _uuid = const Uuid();

  NotesBloc({
    required this.createNote,
    required this.getAllNotes,
    required this.getFilteredNotes,
    required this.updateNote,
    required this.deleteNote,
    required this.deleteMultipleNotes,
    required this.searchNotes,
    required this.getNoteById,
    required this.duplicateNote,
    required this.manageNoteTasks,
    required this.manageNoteTags,
    required this.manageNoteReminders,
  }) : super(NotesInitial()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<LoadNoteByIdEvent>(_onLoadNoteById);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<DeleteMultipleNotesEvent>(_onDeleteMultipleNotes);
    on<SearchNotesEvent>(_onSearchNotes);
    on<ClearSearchEvent>(_onClearSearch);
    on<FilterNotesEvent>(_onFilterNotes);
    on<LoadArchivedNotesEvent>(_onLoadArchivedNotes);
    on<LoadFavoriteNotesEvent>(_onLoadFavoriteNotes);
    on<LoadPinnedNotesEvent>(_onLoadPinnedNotes);
    on<LoadNotesByCategoryEvent>(_onLoadNotesByCategory);
    on<TogglePinNoteEvent>(_onTogglePinNote);
    on<ToggleArchiveNoteEvent>(_onToggleArchiveNote);
    on<ToggleFavoriteNoteEvent>(_onToggleFavoriteNote);
    on<SetNoteColorEvent>(_onSetNoteColor);
    on<SetNoteCategoryEvent>(_onSetNoteCategory);
    on<SetNoteReminderEvent>(_onSetNoteReminder);
    on<DuplicateNoteEvent>(_onDuplicateNote);
    on<AddTaskToNoteEvent>(_onAddTaskToNote);
    on<UpdateTaskInNoteEvent>(_onUpdateTaskInNote);
    on<RemoveTaskFromNoteEvent>(_onRemoveTaskFromNote);
    on<AddTagToNoteEvent>(_onAddTagToNote);
    on<RemoveTagFromNoteEvent>(_onRemoveTagFromNote);
    // Los eventos de estadísticas, backup, etc. se pueden agregar más tarde
  }

  Future<void> _onLoadNotes(LoadNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await getAllNotes();
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) => emit(NotesLoaded(notes: notes)),
    );
  }

  Future<void> _onLoadNoteById(LoadNoteByIdEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await getNoteById(event.id);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (note) {
        if (note != null) {
          emit(NotesLoaded(notes: [note]));
        } else {
          emit(const NotesError(message: 'Nota no encontrada'));
        }
      },
    );
  }

  Future<void> _onCreateNote(CreateNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    emit(NotesLoading());
    
    final now = DateTime.now();
    final noteParams = CreateNoteParams(
      id: _uuid.v4(),
      title: event.title.trim().isEmpty ? 'Nota sin título' : event.title,
      content: event.content,
      tasks: event.tasks ?? [],
      tags: event.tags ?? [],
      createdAt: now,
      updatedAt: now,
      reminderDate: event.reminderDate,
      colorTag: event.colorTag,
      category: event.category,
    );
    
    final result = await createNote(noteParams);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) {
        emit(const NotesOperationSuccess(message: 'Nota creada exitosamente'));
        // Recargar notas después de crear
        add(LoadNotesEvent());
      },
    );
  }

  Future<void> _onUpdateNote(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final updatedNote = event.note.copyWith(updatedAt: DateTime.now());
    final result = await updateNote(updatedNote);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) {
        emit(NotesOperationSuccess(
          message: 'Nota actualizada exitosamente',
          note: updatedNote,
        ));
        // Recargar notas después de actualizar
        add(LoadNotesEvent());
      },
    );
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await deleteNote(event.id);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) {
        emit(const NotesOperationSuccess(message: 'Nota eliminada exitosamente'));
        // Recargar notas después de eliminar
        add(LoadNotesEvent());
      },
    );
  }

  Future<void> _onDeleteMultipleNotes(DeleteMultipleNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await deleteMultipleNotes(event.ids);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (_) {
        emit(NotesMultiOperationSuccess(
          message: '${event.ids.length} notas eliminadas exitosamente',
          affectedNoteIds: event.ids,
        ));
        // Recargar notas después de eliminar
        add(LoadNotesEvent());
      },
    );
  }

  Future<void> _onSearchNotes(SearchNotesEvent event, Emitter<NotesState> emit) async {
    if (event.query.trim().isEmpty) {
      add(ClearSearchEvent());
      return;
    }
    
    emit(NotesSearching(query: event.query));
    
    final result = await searchNotes(event.query);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) => emit(NotesSearchResults(
        results: notes,
        query: event.query,
      )),
    );
  }

  Future<void> _onClearSearch(ClearSearchEvent event, Emitter<NotesState> emit) async {
    add(LoadNotesEvent());
  }

  Future<void> _onFilterNotes(FilterNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await getFilteredNotes(GetFilteredNotesParams(
      isPinned: event.isPinned,
      isArchived: event.isArchived,
      isFavorite: event.isFavorite,
      category: event.category,
      colorTag: event.colorTag,
      startDate: event.startDate,
      endDate: event.endDate,
      hasReminder: event.hasReminder,
      hasTasks: event.hasTasks,
      tags: event.tags,
    ));
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (notes) => emit(NotesLoaded(
        notes: notes,
        isPinned: event.isPinned ?? false,
        isArchived: event.isArchived ?? false,
        isFavorite: event.isFavorite ?? false,
        category: event.category,
      )),
    );
  }

  Future<void> _onLoadArchivedNotes(LoadArchivedNotesEvent event, Emitter<NotesState> emit) async {
    add(const FilterNotesEvent(isArchived: true));
  }

  Future<void> _onLoadFavoriteNotes(LoadFavoriteNotesEvent event, Emitter<NotesState> emit) async {
    add(const FilterNotesEvent(isFavorite: true));
  }

  Future<void> _onLoadPinnedNotes(LoadPinnedNotesEvent event, Emitter<NotesState> emit) async {
    add(const FilterNotesEvent(isPinned: true));
  }

  Future<void> _onLoadNotesByCategory(LoadNotesByCategoryEvent event, Emitter<NotesState> emit) async {
    add(FilterNotesEvent(category: event.category));
  }

  Future<void> _onTogglePinNote(TogglePinNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        isPinned: !note.isPinned,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onToggleArchiveNote(ToggleArchiveNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        isArchived: !note.isArchived,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onToggleFavoriteNote(ToggleFavoriteNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        isFavorite: !note.isFavorite,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onSetNoteColor(SetNoteColorEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        colorTag: event.colorTag,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onSetNoteCategory(SetNoteCategoryEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        category: event.category,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onSetNoteReminder(SetNoteReminderEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.id);
      final updatedNote = note.copyWith(
        reminderDate: event.reminderDate,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onDuplicateNote(DuplicateNoteEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    
    final result = await duplicateNote(event.id);
    
    result.fold(
      (failure) => emit(NotesError(message: failure.message)),
      (duplicatedNote) {
        emit(NotesOperationSuccess(
          message: 'Nota duplicada exitosamente',
          note: duplicatedNote,
        ));
        // Recargar notas después de duplicar
        add(LoadNotesEvent());
      },
    );
  }

  Future<void> _onAddTaskToNote(AddTaskToNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.noteId);
      final updatedTasks = List<Task>.from(note.tasks)..add(event.task);
      final updatedNote = note.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onUpdateTaskInNote(UpdateTaskInNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.noteId);
      final updatedTasks = note.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      final updatedNote = note.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onRemoveTaskFromNote(RemoveTaskFromNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.noteId);
      final updatedTasks = note.tasks.where((task) => task.id != event.taskId).toList();
      final updatedNote = note.copyWith(
        tasks: updatedTasks,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }

  Future<void> _onAddTagToNote(AddTagToNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.noteId);
      if (!note.tags.contains(event.tag)) {
        final updatedTags = List<String>.from(note.tags)..add(event.tag);
        final updatedNote = note.copyWith(
          tags: updatedTags,
          updatedAt: DateTime.now(),
        );
        add(UpdateNoteEvent(note: updatedNote));
      }
    }
  }

  Future<void> _onRemoveTagFromNote(RemoveTagFromNoteEvent event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is NotesLoaded) {
      final note = currentState.notes.firstWhere((n) => n.id == event.noteId);
      final updatedTags = note.tags.where((tag) => tag != event.tag).toList();
      final updatedNote = note.copyWith(
        tags: updatedTags,
        updatedAt: DateTime.now(),
      );
      add(UpdateNoteEvent(note: updatedNote));
    }
  }
}
