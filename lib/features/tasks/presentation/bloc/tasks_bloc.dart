import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/manage_tasks.dart';
import '../../../core/usecases/usecase.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

@injectable
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final CreateTask createTask;
  final DeleteTask deleteTask;
  final GetAllTasks getAllTasks;
  final UpdateTask updateTask;

  TasksBloc({
    required this.createTask,
    required this.deleteTask,
    required this.getAllTasks,
    required this.updateTask,
  }) : super(TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    final result = await getAllTasks(NoParams());
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final result = await createTask(event.task);
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
    final result = await deleteTask(event.taskId);
    result.fold(
      (failure) => emit(TasksError(failure.toString())),
      (_) => add(const LoadTasks()),
    );
  }
}
