import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 14)
@JsonSerializable()
class TaskModel extends Task {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final bool isCompleted;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime? dueDate;
  
  @HiveField(6)
  final DateTime? completedAt;
  
  @HiveField(7)
  @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
  final TaskPriority priority;
  
  @HiveField(8)
  final String? categoryId;
  
  @HiveField(9)
  final List<String> tags;
  
  @HiveField(10)
  final List<TaskStepModel> steps;
  
  @HiveField(11)
  final bool hasReminder;
  
  @HiveField(12)
  final DateTime? reminderTime;
  
  @HiveField(13)
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final TaskStatus status;
  
  @HiveField(14)
  final String? noteId;
  
  @HiveField(15)
  final int? estimatedMinutes;
  
  @HiveField(16)
  final int? actualMinutes;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
    required this.priority,
    this.categoryId,
    required this.tags,
    required this.steps,
    required this.hasReminder,
    this.reminderTime,
    required this.status,
    this.noteId,
    this.estimatedMinutes,
    this.actualMinutes,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
          createdAt: createdAt,
          dueDate: dueDate,
          completedAt: completedAt,
          priority: priority,
          categoryId: categoryId,
          tags: tags,
          steps: steps,
          hasReminder: hasReminder,
          reminderTime: reminderTime,
          status: status,
          noteId: noteId,
          estimatedMinutes: estimatedMinutes,
          actualMinutes: actualMinutes,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      priority: entity.priority,
      categoryId: entity.categoryId,
      tags: entity.tags,
      steps: entity.steps.map((step) => TaskStepModel.fromEntity(step)).toList(),
      hasReminder: entity.hasReminder,
      reminderTime: entity.reminderTime,
      status: entity.status,
      noteId: entity.noteId,
      estimatedMinutes: entity.estimatedMinutes,
      actualMinutes: entity.actualMinutes,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      dueDate: dueDate,
      completedAt: completedAt,
      priority: priority,
      categoryId: categoryId,
      tags: tags,
      steps: steps.map((step) => step.toEntity()).toList(),
      hasReminder: hasReminder,
      reminderTime: reminderTime,
      status: status,
      noteId: noteId,
      estimatedMinutes: estimatedMinutes,
      actualMinutes: actualMinutes,
    );
  }

  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    TaskPriority? priority,
    String? categoryId,
    List<String>? tags,
    List<TaskStep>? steps,
    bool? hasReminder,
    DateTime? reminderTime,
    TaskStatus? status,
    String? noteId,
    int? estimatedMinutes,
    int? actualMinutes,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      steps: steps?.map((step) => TaskStepModel.fromEntity(step)).toList() ?? this.steps,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
      status: status ?? this.status,
      noteId: noteId ?? this.noteId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
    );
  }

  // JSON Converters para enums
  static TaskPriority _priorityFromJson(String value) {
    switch (value) {
      case 'low':
        return TaskPriority.low;
      case 'medium':
        return TaskPriority.medium;
      case 'high':
        return TaskPriority.high;
      case 'critical':
        return TaskPriority.critical;
      default:
        return TaskPriority.medium;
    }
  }

  static String _priorityToJson(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.medium:
        return 'medium';
      case TaskPriority.high:
        return 'high';
      case TaskPriority.critical:
        return 'critical';
    }
  }

  static TaskStatus _statusFromJson(String value) {
    switch (value) {
      case 'pending':
        return TaskStatus.pending;
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      case 'onHold':
        return TaskStatus.onHold;
      default:
        return TaskStatus.pending;
    }
  }

  static String _statusToJson(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
      case TaskStatus.onHold:
        return 'onHold';
    }
  }
}

@HiveType(typeId: 17)
@JsonSerializable()
class TaskStepModel extends TaskStep {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final bool isCompleted;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime? completedAt;
  
  @HiveField(6)
  final int order;

  const TaskStepModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    required this.order,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
          createdAt: createdAt,
          completedAt: completedAt,
          order: order,
        );

  factory TaskStepModel.fromJson(Map<String, dynamic> json) =>
      _$TaskStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskStepModelToJson(this);

  factory TaskStepModel.fromEntity(TaskStep entity) {
    return TaskStepModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      order: entity.order,
    );
  }

  TaskStep toEntity() {
    return TaskStep(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      completedAt: completedAt,
      order: order,
    );
  }

  @override
  TaskStepModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    int? order,
  }) {
    return TaskStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      order: order ?? this.order,
    );
  }
}
