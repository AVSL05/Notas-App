import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/manage_tasks.dart';
import '../../../../core/usecases/usecase.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final CreateTask createTaskUseCase;
  final DeleteTask deleteTaskUseCase;
  final GetAllTasks getAllTasks;
  final UpdateTask updateTask;

  TasksBloc({
    required this.createTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getAllTasks,
    required this.updateTask,
  }) : super(TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<FilterTasks>(_onFilterTasks);
    on<SearchTasksEvent>(_onSearchTasks);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    final result = await getAllTasks();
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (tasks) => emit(TasksLoaded(tasks: tasks)),
    );
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final result = await createTaskUseCase(event.task);
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (_) => add(const LoadTasks()),
    );
  }

  void _onCreateTask(CreateTaskEvent event, Emitter<TasksState> emit) async {
    final result = await createTaskUseCase(event.task);
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (_) => add(const LoadTasks()),
    );
  }

  void _onUpdateTask(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    final result = await updateTask(event.task);
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (_) => add(const LoadTasks()),
    );
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TasksState> emit) async {
    final result = await deleteTaskUseCase(event.taskId);
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (_) => add(const LoadTasks()),
    );
  }

  void _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TasksState> emit) async {
    // TODO: Implement toggle completion logic
    emit(TasksError('Toggle completion not yet implemented'));
  }

  void _onFilterTasks(FilterTasks event, Emitter<TasksState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      final filteredTasks = currentState.tasks.where((task) => event.filter.matches(task)).toList();
      emit(currentState.copyWith(
        filteredTasks: filteredTasks,
        isSearching: false,
      ));
    }
  }

  void _onSearchTasks(SearchTasksEvent event, Emitter<TasksState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      final searchResults = currentState.tasks
          .where((task) => 
              task.title.toLowerCase().contains(event.query.toLowerCase()) ||
              task.description.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(currentState.copyWith(
        filteredTasks: searchResults,
        isSearching: event.query.isNotEmpty,
      ));
    }
  }
}
