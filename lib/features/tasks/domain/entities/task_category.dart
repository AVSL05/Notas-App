import 'package:equatable/equatable.dart';

/// Entidad para representar categorías de tareas
class TaskCategory extends Equatable {
  
  final String id;
  
  
  final String name;
  
  
  final String description;
  
  
  final int colorValue;
  
  
  final String icon;
  
  
  final DateTime createdAt;
  
  
  final DateTime? updatedAt;
  
  
  final bool isDefault;
  
  
  final int order;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.colorValue,
    required this.icon,
    required this.createdAt,
    this.updatedAt,
    required this.isDefault,
    required this.order,
  });

  factory TaskCategory.create({
    required String id,
    required String name,
    String description = '',
    int colorValue = 0xFF2196F3, // Azul por defecto
    String icon = 'category',
    bool isDefault = false,
    required int order,
  }) {
    return TaskCategory(
      id: id,
      name: name,
      description: description,
      colorValue: colorValue,
      icon: icon,
      createdAt: DateTime.now(),
      updatedAt: null,
      isDefault: isDefault,
      order: order,
    );
  }

  TaskCategory copyWith({
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
    return TaskCategory(
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

  /// Categorías por defecto del sistema
  static List<TaskCategory> get defaultCategories => [
    TaskCategory.create(
      id: 'default_personal',
      name: 'Personal',
      description: 'Tareas personales y actividades cotidianas',
      colorValue: 0xFF4CAF50, // Verde
      icon: 'person',
      isDefault: true,
      order: 0,
    ),
    TaskCategory.create(
      id: 'default_work',
      name: 'Trabajo',
      description: 'Tareas relacionadas con el trabajo y proyectos profesionales',
      colorValue: 0xFF2196F3, // Azul
      icon: 'work',
      isDefault: true,
      order: 1,
    ),
    TaskCategory.create(
      id: 'default_study',
      name: 'Estudio',
      description: 'Tareas académicas y de aprendizaje',
      colorValue: 0xFF9C27B0, // Púrpura
      icon: 'school',
      isDefault: true,
      order: 2,
    ),
    TaskCategory.create(
      id: 'default_health',
      name: 'Salud',
      description: 'Tareas relacionadas con salud y bienestar',
      colorValue: 0xFFE91E63, // Rosa
      icon: 'favorite',
      isDefault: true,
      order: 3,
    ),
    TaskCategory.create(
      id: 'default_shopping',
      name: 'Compras',
      description: 'Lista de compras y adquisiciones',
      colorValue: 0xFFFF9800, // Naranja
      icon: 'shopping_cart',
      isDefault: true,
      order: 4,
    ),
    TaskCategory.create(
      id: 'default_home',
      name: 'Hogar',
      description: 'Tareas domésticas y del hogar',
      colorValue: 0xFF795548, // Marrón
      icon: 'home',
      isDefault: true,
      order: 5,
    ),
  ];

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        colorValue,
        icon,
        createdAt,
        updatedAt,
        isDefault,
        order,
      ];
}
