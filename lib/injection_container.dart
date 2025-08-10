import 'package:get_it/get_it.dart';

// Data Sources
import 'features/tasks/data/datasources/task_local_data_source.dart';

// Repositories 
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print('🔧 Initializing dependency injection...');
  
  try {
    // Data Sources
    sl.registerLazySingleton<TaskLocalDataSource>(
      () => TaskLocalDataSource(),
    );

    // Repositories
    sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(localDataSource: sl()),
    );

    // Use Cases se registrarán cuando estén implementados
    // TODO: Registrar use cases cuando estén creados
    
    print('✅ Dependency injection initialized successfully');
  } catch (e) {
    print('❌ Error initializing dependency injection: $e');
    rethrow;
  }
}

Future<void> reset() async {
  try {
    await sl.reset();
    print('🔄 Dependency injection reset successfully');
  } catch (e) {
    print('❌ Error resetting dependency injection: $e');
    rethrow;
  }
}
