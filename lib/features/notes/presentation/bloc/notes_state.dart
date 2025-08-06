import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

/// Estados del BLoC de notas
abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class NotesInitial extends NotesState {}

/// Estado de carga
class NotesLoading extends NotesState {}

/// Estado de notas cargadas exitosamente
class NotesLoaded extends NotesState {
  final List<Note> notes;
  final bool isPinned;
  final bool isArchived;
  final bool isFavorite;
  final String? category;
  final String? searchQuery;

  const NotesLoaded({
    required this.notes,
    this.isPinned = false,
    this.isArchived = false,
    this.isFavorite = false,
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        notes,
        isPinned,
        isArchived,
        isFavorite,
        category,
        searchQuery,
      ];

  NotesLoaded copyWith({
    List<Note>? notes,
    bool? isPinned,
    bool? isArchived,
    bool? isFavorite,
    String? category,
    String? searchQuery,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Estado de error
class NotesError extends NotesState {
  final String message;

  const NotesError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Estado de búsqueda
class NotesSearching extends NotesState {
  final String query;

  const NotesSearching({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Estado de búsqueda completada
class NotesSearchResults extends NotesState {
  final List<Note> results;
  final String query;

  const NotesSearchResults({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

/// Estado de operación exitosa (crear, actualizar, eliminar)
class NotesOperationSuccess extends NotesState {
  final String message;
  final Note? note;

  const NotesOperationSuccess({
    required this.message,
    this.note,
  });

  @override
  List<Object?> get props => [message, note];
}

/// Estado de múltiples operaciones
class NotesMultiOperationSuccess extends NotesState {
  final String message;
  final List<String> affectedNoteIds;

  const NotesMultiOperationSuccess({
    required this.message,
    required this.affectedNoteIds,
  });

  @override
  List<Object?> get props => [message, affectedNoteIds];
}

/// Estado de estadísticas cargadas
class NotesStatisticsLoaded extends NotesState {
  final Map<String, int> statistics;

  const NotesStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

/// Estado de categorías y tags cargados
class NotesMetadataLoaded extends NotesState {
  final List<String> categories;
  final List<String> tags;

  const NotesMetadataLoaded({
    required this.categories,
    required this.tags,
  });

  @override
  List<Object?> get props => [categories, tags];
}

/// Estado de backup/export
class NotesBackupState extends NotesState {
  final String data;
  final String type; // 'backup' o 'export'

  const NotesBackupState({
    required this.data,
    required this.type,
  });

  @override
  List<Object?> get props => [data, type];
}
