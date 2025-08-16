import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_filter.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TasksEvent {
  const LoadTasks();
}

class SearchTasksEvent extends TasksEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterTasks extends TasksEvent {
  final TaskFilter filter;

  const FilterTasks(this.filter);

  @override
  List<Object> get props => [filter];
}

class AddTask extends TasksEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class CreateTaskEvent extends TasksEvent {
  final Task task;

  const CreateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TasksEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class ToggleTaskCompletion extends TasksEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class DeleteTaskEvent extends TasksEvent {
  final String taskId;

  const DeleteTaskEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}
