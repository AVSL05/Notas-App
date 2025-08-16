import 'package:equatable/equatable.dart';
import 'task.dart';

class TaskFilter extends Equatable {
  final bool? isCompleted;
  final String? category;
  final DateTime? dueDate;
  final int? priority;

  const TaskFilter({
    this.isCompleted,
    this.category,
    this.dueDate,
    this.priority,
  });

  // Getters estáticos predefinidos
  static const TaskFilter all = TaskFilter();
  static const TaskFilter pending = TaskFilter(isCompleted: false);
  static const TaskFilter completed = TaskFilter(isCompleted: true);
  static const TaskFilter highPriority = TaskFilter(priority: 3);
  
  static TaskFilter get dueToday => TaskFilter(
    dueDate: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ),
  );
  
  static TaskFilter get overdue => TaskFilter(
    dueDate: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day - 1,
    ),
  );

  // Lista de todos los valores predefinidos
  static List<TaskFilter> get values => [
    all,
    pending,
    completed,
    highPriority,
    dueToday,
    overdue,
  ];

  TaskFilter copyWith({
    bool? isCompleted,
    String? category,
    DateTime? dueDate,
    int? priority,
  }) {
    return TaskFilter(
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }

  bool matches(Task task) {
    if (isCompleted != null && task.isCompleted != isCompleted) {
      return false;
    }
    
    if (category != null && task.categoryId != category) {
      return false;
    }
    
    if (dueDate != null && task.dueDate != dueDate) {
      return false;
    }
    
    if (priority != null && task.priority.index != priority) {
      return false;
    }
    
    return true;
  }

  @override
  List<Object?> get props => [isCompleted, category, dueDate, priority];
}
