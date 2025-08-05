import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String content; // Contenido en formato Delta JSON de Quill
  
  @HiveField(3)
  final List<Task> tasks;
  
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
  final String colorTag;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.tasks = const [],
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.reminderDate,
    this.isPinned = false,
    this.colorTag = 'default',
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    List<Task>? tasks,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reminderDate,
    bool? isPinned,
    String? colorTag,
  }) {
    return Note(
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        tasks,
        tags,
        createdAt,
        updatedAt,
        reminderDate,
        isPinned,
        colorTag,
      ];
}

@HiveType(typeId: 1)
class Task extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final bool isCompleted;
  
  @HiveField(3)
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, createdAt];
}
