import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_app/features/tasks/domain/usecases/manage_tasks.dart'
    as usecases;
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/tasks/presentation/pages/placeholder_pages.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../../injection_container.dart' as di;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/tasks',
    routes: [
      // Ruta principal de Tasks
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) {
          return BlocProvider<TasksBloc>(
            create: (context) => TasksBloc(
              createTask: di.sl<usecases.CreateTask>(),
              deleteTask: di.sl<usecases.DeleteTask>(),
              getAllTasks: di.sl<usecases.GetAllTasks>(),
              updateTask: di.sl<usecases.UpdateTask>(),
            )..add(const LoadTasks()),
            child: const TasksPage(),
          );
        },
      ),
      
      // Rutas de categorías
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesPlaceholderPage(),
        routes: [
          GoRoute(
            path: '/create',
            builder: (context, state) => const CategoryFormPlaceholderPage(),
          ),
          GoRoute(
            path: '/:categoryId/edit',
            builder: (context, state) {
              final categoryId = state.pathParameters['categoryId']!;
              return CategoryFormPlaceholderPage(categoryId: categoryId);
            },
          ),
        ],
      ),
      
      // Estadísticas
      GoRoute(
        path: '/stats',
        builder: (context, state) => const TaskStatsPlaceholderPage(),
      ),
      
      // Exportar
      GoRoute(
        path: '/export',
        builder: (context, state) => const TaskExportPlaceholderPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}

// Extension para navegación fácil
extension TasksRoutes on BuildContext {
  void goToTasks() => go('/tasks');
  void goToCreateTask() => go('/tasks/create');
  void goToTaskDetails(String taskId) => go('/tasks/$taskId');
  void goToEditTask(String taskId) => go('/tasks/$taskId/edit');
  void goToCategories() => go('/categories');
  void goToCreateCategory() => go('/categories/create');
  void goToEditCategory(String categoryId) => go('/categories/$categoryId/edit');
  void goToStats() => go('/stats');
  void goToExport() => go('/export');
}
