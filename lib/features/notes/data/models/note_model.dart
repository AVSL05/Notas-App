import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final List<TaskModel> tasks;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final DateTime? reminderDate;

  @HiveField(8)
  final bool isPinned;

  @HiveField(9)
  final String? colorTag;

  @HiveField(10)
  final bool isArchived;

  @HiveField(11)
  final bool isFavorite;

  @HiveField(12)
  final String? category;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.tasks = const [],
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.reminderDate,
    this.isPinned = false,
    this.colorTag,
    this.isArchived = false,
    this.isFavorite = false,
    this.category,
  });

  /// Convierte el modelo a entidad
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      tasks: tasks.map((task) => task.toEntity()).toList(),
      tags: List.from(tags),
      createdAt: createdAt,
      updatedAt: updatedAt,
      reminderDate: reminderDate,
      isPinned: isPinned,
      colorTag: colorTag,
      isArchived: isArchived,
      isFavorite: isFavorite,
      category: category,
    );
  }

  /// Crea un modelo desde una entidad
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      tasks: note.tasks.map((task) => TaskModel.fromEntity(task)).toList(),
      tags: List.from(note.tags),
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      reminderDate: note.reminderDate,
      isPinned: note.isPinned,
      colorTag: note.colorTag,
      isArchived: note.isArchived,
      isFavorite: note.isFavorite,
      category: note.category,
    );
  }

  /// Crea un modelo desde JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((task) => TaskModel.fromJson(task as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'] as String)
          : null,
      isPinned: json['isPinned'] as bool? ?? false,
      colorTag: json['colorTag'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'isPinned': isPinned,
      'colorTag': colorTag,
      'isArchived': isArchived,
      'isFavorite': isFavorite,
      'category': category,
    };
  }

  /// Crea una copia con valores modificados
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    List<TaskModel>? tasks,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderDate,
    bool? isPinned,
    String? colorTag,
    bool? isArchived,
    bool? isFavorite,
    String? category,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tasks: tasks ?? this.tasks,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderDate: reminderDate ?? this.reminderDate,
      isPinned: isPinned ?? this.isPinned,
      colorTag: colorTag ?? this.colorTag,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }
}

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? description;

  @HiveField(5)
  final DateTime? completedAt;

  @HiveField(6)
  final DateTime? dueDate;

  @HiveField(7)
  final TaskPriority priority;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.description,
    this.completedAt,
    this.dueDate,
    this.priority = TaskPriority.medium,
  });

  /// Convierte el modelo a entidad
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted,
      createdAt: createdAt,
      description: description,
      completedAt: completedAt,
      dueDate: dueDate,
      priority: priority,
    );
  }

  /// Crea un modelo desde una entidad
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      description: task.description,
      completedAt: task.completedAt,
      dueDate: task.dueDate,
      priority: task.priority,
    );
  }

  /// Crea un modelo desde JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${json['priority']}',
        orElse: () => TaskPriority.medium,
      ),
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'completedAt': completedAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.toString().split('.').last,
    };
  }

  /// Crea una copia con valores modificados
  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    String? description,
    DateTime? completedAt,
    DateTime? dueDate,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
