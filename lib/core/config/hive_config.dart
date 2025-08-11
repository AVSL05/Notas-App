import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Los modelos Task y TaskCategory se importarán cuando existan
// import '../../features/tasks/data/models/task_model.dart';
// import '../../features/tasks/data/models/task_category_model.dart';
// import '../../features/tasks/domain/entities/task.dart';

class HiveConfig {
  static const String tasksBoxName = 'tasks';
  static const String categoriesBoxName = 'categories';
  static const String settingsBoxName = 'settings';

  static Future<void> initialize() async {
    try {
      print('🔧 Initializing Hive database...');
      
      await Hive.initFlutter();
      print('✅ Hive initialized successfully');

      // Por ahora solo registramos los adaptadores básicos
      // Los adaptadores de Task y TaskCategory se registrarán cuando existan
      await _registerAdapters();
      
      // Abrir las cajas necesarias
      await _openBoxes();
      
      print('✅ Hive configuration completed');
    } catch (e) {
      print('❌ Error initializing Hive: $e');
      rethrow;
    }
  }

  static Future<void> _registerAdapters() async {
    try {
      print('📦 Registering Hive adapters...');
      
      // Registrar adaptadores de enums de Priority y Status
      if (!Hive.isAdapterRegistered(50)) {
        Hive.registerAdapter(TaskPriorityAdapter());
      }
      
      if (!Hive.isAdapterRegistered(51)) {
        Hive.registerAdapter(TaskStatusAdapter());
      }

      // Los adaptadores de modelos se registrarán cuando existan
      // if (!Hive.isAdapterRegistered(0)) {
      //   Hive.registerAdapter(TaskModelAdapter());
      // }
      // 
      // if (!Hive.isAdapterRegistered(1)) {
      //   Hive.registerAdapter(TaskCategoryModelAdapter());
      // }
      
      print('✅ Adapters registered successfully');
    } catch (e) {
      print('❌ Error registering adapters: $e');
      rethrow;
    }
  }

  static Future<void> _openBoxes() async {
    try {
      print('📂 Opening Hive boxes...');
      
      await Hive.openBox(tasksBoxName);
      await Hive.openBox(categoriesBoxName);
      await Hive.openBox(settingsBoxName);
      
      print('✅ All boxes opened successfully');
    } catch (e) {
      print('❌ Error opening boxes: $e');
      rethrow;
    }
  }

  // Adapters temporales para los enums hasta que estén los modelos completos
  static Box<Map<String, dynamic>> get tasksBox => 
      Hive.box<Map<String, dynamic>>(tasksBoxName);

  static Box<Map<String, dynamic>> get categoriesBox => 
      Hive.box<Map<String, dynamic>>(categoriesBoxName);

  static Box<dynamic> get settingsBox => 
      Hive.box(settingsBoxName);
}

// Adaptador temporal para TaskPriority enum
class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final int typeId = 50;

  @override
  TaskPriority read(BinaryReader reader) {
    final value = reader.readByte();
    switch (value) {
      case 0: return TaskPriority.low;
      case 1: return TaskPriority.medium;
      case 2: return TaskPriority.high;
      case 3: return TaskPriority.urgent;
      default: return TaskPriority.medium;
    }
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    switch (obj) {
      case TaskPriority.low: writer.writeByte(0); break;
      case TaskPriority.medium: writer.writeByte(1); break;
      case TaskPriority.high: writer.writeByte(2); break;
      case TaskPriority.urgent: writer.writeByte(3); break;
    }
  }
}

// Adaptador temporal para TaskStatus enum
class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 51;

  @override
  TaskStatus read(BinaryReader reader) {
    final value = reader.readByte();
    switch (value) {
      case 0: return TaskStatus.pending;
      case 1: return TaskStatus.inProgress;
      case 2: return TaskStatus.completed;
      case 3: return TaskStatus.cancelled;
      default: return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending: writer.writeByte(0); break;
      case TaskStatus.inProgress: writer.writeByte(1); break;
      case TaskStatus.completed: writer.writeByte(2); break;
      case TaskStatus.cancelled: writer.writeByte(3); break;
    }
  }
}

// Definiciones temporales de los enums hasta que estén los modelos
enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { pending, inProgress, completed, cancelled }
