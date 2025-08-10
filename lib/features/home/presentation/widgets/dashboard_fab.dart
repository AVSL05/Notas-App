import 'package:flutter/material.dart';


/// Floating Action Button personalizado para el dashboard
class DashboardFab extends StatefulWidget {
  final VoidCallback onCreateNote;
  final VoidCallback onCreateTask;

  const DashboardFab({
    super.key,
    required this.onCreateNote,
    required this.onCreateTask,
  });

  @override
  State<DashboardFab> createState() => _DashboardFabState();
}

class _DashboardFabState extends State<DashboardFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón para crear tarea
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: _animation.value > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSecondaryFab(
                          icon: Icons.add_task,
                          label: 'Nueva Tarea',
                          backgroundColor: Colors.orange,
                          onPressed: widget.onCreateTask,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        
        // Botón para crear nota
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: _animation.value > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSecondaryFab(
                          icon: Icons.note_add,
                          label: 'Nueva Nota',
                          backgroundColor: Colors.blue,
                          onPressed: widget.onCreateNote,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        
        // Botón principal
        FloatingActionButton(
          onPressed: _toggleExpanded,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0, // 45 grados cuando está expandido
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isExpanded ? Icons.close : Icons.add,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryFab({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Etiqueta
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Botón
        FloatingActionButton(
          heroTag: label, // Etiqueta única para evitar conflictos
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
