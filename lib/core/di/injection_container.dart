import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../notifications/notification_service.dart';
import '../../features/notes/domain/entities/note.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Register Hive adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox('settings');
  
  // Register services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  
  // Configure additional dependencies here
}
