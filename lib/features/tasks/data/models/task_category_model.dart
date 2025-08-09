import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task_category.dart';

part 'task_category_model.g.dart';

@HiveType(typeId: 18)
@JsonSerializable()
class TaskCategoryModel extends TaskCategory {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final int colorValue;
  
  @HiveField(4)
  final String icon;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final DateTime? updatedAt;
  
  @HiveField(7)
  final bool isDefault;
  
  @HiveField(8)
  final int order;

  const TaskCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colorValue,
    required this.icon,
    required this.createdAt,
    this.updatedAt,
    required this.isDefault,
    required this.order,
  }) : super(
          id: id,
          name: name,
          description: description,
          colorValue: colorValue,
          icon: icon,
          createdAt: createdAt,
          updatedAt: updatedAt,
          isDefault: isDefault,
          order: order,
        );

  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCategoryModelToJson(this);

  factory TaskCategoryModel.fromEntity(TaskCategory entity) {
    return TaskCategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      colorValue: entity.colorValue,
      icon: entity.icon,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isDefault: entity.isDefault,
      order: entity.order,
    );
  }

  TaskCategory toEntity() {
    return TaskCategory(
      id: id,
      name: name,
      description: description,
      colorValue: colorValue,
      icon: icon,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDefault: isDefault,
      order: order,
    );
  }

  @override
  TaskCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    int? colorValue,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDefault,
    int? order,
  }) {
    return TaskCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isDefault: isDefault ?? this.isDefault,
      order: order ?? this.order,
    );
  }

  /// Convierte una lista de modelos a entidades
  static List<TaskCategory> toEntityList(List<TaskCategoryModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Convierte una lista de entidades a modelos
  static List<TaskCategoryModel> fromEntityList(List<TaskCategory> entities) {
    return entities.map((entity) => TaskCategoryModel.fromEntity(entity)).toList();
  }
}
