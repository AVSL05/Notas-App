import 'package:flutter/material.dart';

/// Floating Action Button personalizado para crear nuevas notas
class NotesFloatingActionButton extends StatelessWidget {
  const NotesFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateNoteOptions(context),
      icon: const Icon(Icons.add),
      label: const Text('Nueva nota'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    );
  }

  void _showCreateNoteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crear nueva nota',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Nota de texto
            _OptionTile(
              icon: Icons.note_outlined,
              title: 'Nota de texto',
              subtitle: 'Crear una nota simple con texto',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                _createTextNote(context);
              },
            ),
            
            const SizedBox(height: 12),
            
            // Lista de tareas
            _OptionTile(
              icon: Icons.checklist,
              title: 'Lista de tareas',
              subtitle: 'Crear una lista con elementos verificables',
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                _createTaskNote(context);
              },
            ),
            
            const SizedBox(height: 12),
            
            // Nota con recordatorio
            _OptionTile(
              icon: Icons.alarm,
              title: 'Nota con recordatorio',
              subtitle: 'Crear una nota con fecha de recordatorio',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                _createReminderNote(context);
              },
            ),
            
            const SizedBox(height: 12),
            
            // Nota desde foto
            _OptionTile(
              icon: Icons.camera_alt,
              title: 'Nota desde foto',
              subtitle: 'Crear una nota tomando una foto',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                _createPhotoNote(context);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _createTextNote(BuildContext context) {
    // TODO: Navegar a la página de edición de nota
    print('Crear nota de texto');
  }

  void _createTaskNote(BuildContext context) {
    // TODO: Navegar a la página de edición de nota con modo de tareas
    print('Crear lista de tareas');
  }

  void _createReminderNote(BuildContext context) {
    // TODO: Navegar a la página de edición de nota con selector de fecha
    print('Crear nota con recordatorio');
  }

  void _createPhotoNote(BuildContext context) {
    // TODO: Abrir cámara y crear nota con imagen
    print('Crear nota desde foto');
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
