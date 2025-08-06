import 'package:hive/hive.dart';
import '../../domain/entities/date_note_association.dart';

part 'date_note_association_model.g.dart';

/// Modelo de datos para DateNoteAssociation compatible con Hive
@HiveType(typeId: 3)
class DateNoteAssociationModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String noteId;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String colorTag;

  @HiveField(4)
  late int priority;

  @HiveField(5)
  late bool isCompleted;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  DateNoteAssociationModel({
    required this.id,
    required this.noteId,
    required this.date,
    required this.colorTag,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convierte un DateNoteAssociation a DateNoteAssociationModel
  factory DateNoteAssociationModel.fromEntity(DateNoteAssociation entity) {
    return DateNoteAssociationModel(
      id: entity.id,
      noteId: entity.noteId,
      date: entity.date,
      colorTag: entity.colorTag,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte el modelo a una entidad DateNoteAssociation
  DateNoteAssociation toEntity() {
    return DateNoteAssociation(
      id: id,
      noteId: noteId,
      date: date,
      colorTag: colorTag,
      priority: priority,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convierte desde JSON
  factory DateNoteAssociationModel.fromJson(Map<String, dynamic> json) {
    return DateNoteAssociationModel(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      date: DateTime.parse(json['date'] as String),
      colorTag: json['colorTag'] as String,
      priority: json['priority'] as int,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noteId': noteId,
      'date': date.toIso8601String(),
      'colorTag': colorTag,
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crea una copia del modelo con campos modificados
  DateNoteAssociationModel copyWith({
    String? id,
    String? noteId,
    DateTime? date,
    String? colorTag,
    int? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DateNoteAssociationModel(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      date: date ?? this.date,
      colorTag: colorTag ?? this.colorTag,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DateNoteAssociationModel{id: $id, noteId: $noteId, date: $date, priority: $priority, isCompleted: $isCompleted}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateNoteAssociationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
