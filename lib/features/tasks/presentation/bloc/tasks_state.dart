import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final bool isSearching;

  const TasksLoaded({
    required this.tasks,
    this.filteredTasks = const [],
    this.isSearching = false,
  });

  TasksLoaded copyWith({
    List<Task>? tasks,
    List<Task>? filteredTasks,
    bool? isSearching,
  }) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [tasks, filteredTasks, isSearching];
}

class TaskOperationInProgress extends TasksState {
  final String operation;

  const TaskOperationInProgress(this.operation);

  @override
  List<Object> get props => [operation];
}

class TaskOperationSuccess extends TasksState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object> get props => [message];
}
