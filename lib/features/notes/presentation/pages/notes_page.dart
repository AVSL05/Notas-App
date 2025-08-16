import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_app_bar.dart';
import '../widgets/notes_floating_action_button.dart';
import '../widgets/notes_drawer.dart';
import '../widgets/empty_notes_widget.dart' as empty_widget;
import '../widgets/notes_loading_widget.dart' as loading_widget;
import '../widgets/notes_error_widget.dart' as error_widget;

/// Página principal que muestra la lista de notas
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Cargar notas al iniciar la página
    context.read<NotesBloc>().add(LoadNotesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
    });
    _searchController.clear();
    context.read<NotesBloc>().add(ClearSearchEvent());
  }

  void _onSearchChanged(String query) {
    if (query.trim().isNotEmpty) {
      context.read<NotesBloc>().add(SearchNotesEvent(query: query));
    } else {
      context.read<NotesBloc>().add(ClearSearchEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotesAppBar(
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchStart: _startSearch,
        onSearchStop: _stopSearch,
        onSearchChanged: _onSearchChanged,
      ),
      drawer: const NotesDrawer(),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotesOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is NotesMultiOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const loading_widget.NotesLoadingWidget();
          } else if (state is NotesError) {
            return error_widget.NotesErrorWidget(
              message: state.message,
              onRetry: () => context.read<NotesBloc>().add(LoadNotesEvent()),
            );
          } else if (state is NotesLoaded || state is NotesSearchResults) {
            final notes = state is NotesLoaded 
                ? state.notes 
                : (state as NotesSearchResults).results;

            if (notes.isEmpty) {
              return empty_widget.EmptyNotesWidget(
                isSearching: _isSearching,
                searchQuery: state is NotesSearchResults ? state.query : null,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotesBloc>().add(LoadNotesEvent());
              },
              child: CustomScrollView(
                slivers: [
                  // Información de resultados de búsqueda
                  if (state is NotesSearchResults)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Text(
                          '${notes.length} resultados para "${state.query}"',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  
                  // Lista de notas fijadas
                  if (state is NotesLoaded && !_isSearching)
                    _buildPinnedNotesSection(notes),
                  
                  // Lista de notas principales
                  _buildNotesGrid(notes, state is NotesLoaded ? state : null),
                ],
              ),
            );
          }

          return const empty_widget.EmptyNotesWidget(isSearching: false);
        },
      ),
      floatingActionButton: const NotesFloatingActionButton(),
    );
  }

  Widget _buildPinnedNotesSection(List<dynamic> allNotes) {
    final pinnedNotes = allNotes.where((note) => note.isPinned).toList();
    
    if (pinnedNotes.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.push_pin,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fijadas',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200, // Altura fija para las notas fijadas
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: pinnedNotes.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200, // Ancho fijo para cada nota fijada
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: NoteCard(
                      note: pinnedNotes[index],
                      isCompact: true,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildNotesGrid(List<dynamic> notes, NotesLoaded? loadedState) {
    // Filtrar notas no fijadas para la vista principal
    final regularNotes = _isSearching 
        ? notes 
        : notes.where((note) => !note.isPinned).toList();

    if (regularNotes.isEmpty && !_isSearching) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return NoteCard(note: regularNotes[index]);
          },
          childCount: regularNotes.length,
        ),
      ),
    );
  }
}
