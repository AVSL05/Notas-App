import 'package:hive/hive.dart';
import '../../domain/entities/calendar_event.dart';

part 'calendar_event_model.g.dart';

/// Modelo de datos para CalendarEvent compatible con Hive
@HiveType(typeId: 2)
class CalendarEventModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  late DateTime date;

  @HiveField(4)
  DateTime? startTime;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  late String colorTag;

  @HiveField(7)
  String? noteId;

  @HiveField(8)
  late bool isAllDay;

  @HiveField(9)
  late int typeIndex; // Guardamos el índice del enum

  @HiveField(10)
  late DateTime createdAt;

  @HiveField(11)
  DateTime? updatedAt;

  CalendarEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    this.startTime,
    this.endTime,
    required this.colorTag,
    this.noteId,
    required this.isAllDay,
    required this.typeIndex,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convierte un CalendarEvent a CalendarEventModel
  factory CalendarEventModel.fromEntity(CalendarEvent entity) {
    return CalendarEventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      colorTag: entity.colorTag,
      noteId: entity.noteId,
      isAllDay: entity.isAllDay,
      typeIndex: entity.type.index,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte el modelo a una entidad CalendarEvent
  CalendarEvent toEntity() {
    return CalendarEvent(
      id: id,
      title: title,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      colorTag: colorTag,
      noteId: noteId,
      isAllDay: isAllDay,
      type: CalendarEventType.values[typeIndex],
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convierte desde JSON
  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime'] as String) 
          : null,
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      colorTag: json['colorTag'] as String,
      noteId: json['noteId'] as String?,
      isAllDay: json['isAllDay'] as bool,
      typeIndex: json['typeIndex'] as int,
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
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'colorTag': colorTag,
      'noteId': noteId,
      'isAllDay': isAllDay,
      'typeIndex': typeIndex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crea una copia del modelo con campos modificados
  CalendarEventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? colorTag,
    String? noteId,
    bool? isAllDay,
    int? typeIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      colorTag: colorTag ?? this.colorTag,
      noteId: noteId ?? this.noteId,
      isAllDay: isAllDay ?? this.isAllDay,
      typeIndex: typeIndex ?? this.typeIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CalendarEventModel{id: $id, title: $title, date: $date, isAllDay: $isAllDay}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarEventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
