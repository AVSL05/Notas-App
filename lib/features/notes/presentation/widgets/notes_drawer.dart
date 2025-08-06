import 'package:flutter/material.dart';

/// Drawer lateral para navegación entre secciones de notas
class NotesDrawer extends StatelessWidget {
  const NotesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header del drawer
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mis Notas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Organiza tus ideas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de opciones
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.note,
                  title: 'Todas las notas',
                  onTap: () => _navigateToSection(context, 'all'),
                  isSelected: true,
                ),
                _DrawerItem(
                  icon: Icons.push_pin,
                  title: 'Fijadas',
                  onTap: () => _navigateToSection(context, 'pinned'),
                ),
                _DrawerItem(
                  icon: Icons.favorite,
                  title: 'Favoritas',
                  onTap: () => _navigateToSection(context, 'favorites'),
                ),
                _DrawerItem(
                  icon: Icons.alarm,
                  title: 'Recordatorios',
                  onTap: () => _navigateToSection(context, 'reminders'),
                ),
                _DrawerItem(
                  icon: Icons.checklist,
                  title: 'Listas de tareas',
                  onTap: () => _navigateToSection(context, 'tasks'),
                ),
                
                const Divider(height: 20),
                
                // Sección de categorías
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categorías',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () => _showAddCategoryDialog(context),
                      ),
                    ],
                  ),
                ),
                
                _DrawerItem(
                  icon: Icons.work,
                  title: 'Trabajo',
                  onTap: () => _navigateToCategory(context, 'Trabajo'),
                ),
                _DrawerItem(
                  icon: Icons.home,
                  title: 'Personal',
                  onTap: () => _navigateToCategory(context, 'Personal'),
                ),
                _DrawerItem(
                  icon: Icons.school,
                  title: 'Estudios',
                  onTap: () => _navigateToCategory(context, 'Estudios'),
                ),
                
                const Divider(height: 20),
                
                _DrawerItem(
                  icon: Icons.archive,
                  title: 'Archivo',
                  onTap: () => _navigateToSection(context, 'archived'),
                ),
                _DrawerItem(
                  icon: Icons.delete,
                  title: 'Papelera',
                  onTap: () => _navigateToSection(context, 'trash'),
                ),
                
                const Divider(height: 20),
                
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Configuración',
                  onTap: () => _navigateToSection(context, 'settings'),
                ),
                _DrawerItem(
                  icon: Icons.help,
                  title: 'Ayuda',
                  onTap: () => _navigateToSection(context, 'help'),
                ),
              ],
            ),
          ),
          
          // Footer con información de la app
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.cloud_done,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sincronizado',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Notas App v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSection(BuildContext context, String section) {
    Navigator.pop(context);
    // TODO: Implementar navegación a diferentes secciones
    print('Navegar a sección: $section');
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.pop(context);
    // TODO: Implementar filtro por categoría
    print('Filtrar por categoría: $category');
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Nombre de la categoría',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar creación de categoría
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected 
            ? Theme.of(context).colorScheme.primaryContainer 
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected 
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
