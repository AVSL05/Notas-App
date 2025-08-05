import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/rich_text_editor/presentation/pages/rich_text_editor_demo.dart';

// Placeholder screens - will be implemented later
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notas App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen - Notes List'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/rich-text-demo'),
              child: const Text('Probar Rich Text Editor'),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(
        child: Text('Calendar Screen'),
      ),
    );
  }
}

class NoteEditorScreen extends StatelessWidget {
  const NoteEditorScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note Editor')),
      body: const Center(
        child: Text('Note Editor Screen'),
      ),
    );
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/note-editor',
        builder: (context, state) => const NoteEditorScreen(),
      ),
      GoRoute(
        path: '/rich-text-demo',
        builder: (context, state) => const RichTextEditorDemo(),
      ),
    ],
  );
}
