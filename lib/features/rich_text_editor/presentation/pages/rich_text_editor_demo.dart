import 'package:flutter/material.dart';
import '../widgets/rich_text_editor.dart';
import '../widgets/rich_text_viewer.dart';

/// Pantalla de demostración del Rich Text Editor
/// Muestra tanto el editor como el viewer funcionando
class RichTextEditorDemo extends StatefulWidget {
  const RichTextEditorDemo({super.key});

  @override
  State<RichTextEditorDemo> createState() => _RichTextEditorDemoState();
}

class _RichTextEditorDemoState extends State<RichTextEditorDemo> {
  String _currentContent = '';
  bool _isEditMode = true;
  int _wordCount = 0;
  int _charCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rich Text Editor Demo'),
        actions: [
          // Toggle entre edición y vista previa
          IconButton(
            icon: Icon(_isEditMode ? Icons.visibility : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            tooltip: _isEditMode ? 'Vista previa' : 'Editar',
          ),
          
          // Estadísticas del contenido
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showContentStats,
            tooltip: 'Estadísticas',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de estado con estadísticas básicas
          if (_currentContent.isNotEmpty) _buildStatusBar(),
          
          // Editor o Viewer según el modo
          Expanded(
            child: _isEditMode ? _buildEditor() : _buildViewer(),
          ),
        ],
      ),
      
      // FAB para acciones rápidas
      floatingActionButton: _buildFloatingActions(),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isEditMode ? Icons.edit : Icons.visibility,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            _isEditMode ? 'Editando' : 'Vista previa',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            '$_wordCount palabras • $_charCount caracteres',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return RichTextEditor(
      initialContent: _currentContent,
      onContentChanged: (content) {
        setState(() {
          _currentContent = content;
          _updateStats();
        });
      },
      placeholder: 'Comienza a escribir tu nota...\n\nPuedes usar:\n• Negritas y cursivas\n• Listas con viñetas\n• Listas numeradas\n• Listas de tareas\n• Citas\n• Y mucho más!',
      minHeight: 300,
      showToolbar: true,
    );
  }

  Widget _buildViewer() {
    if (_currentContent.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay contenido para mostrar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cambia al modo de edición para escribir',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: RichTextViewer(
        content: _currentContent,
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón para limpiar contenido
        if (_currentContent.isNotEmpty) ...[
          FloatingActionButton.small(
            heroTag: 'clear',
            onPressed: _clearContent,
            tooltip: 'Limpiar',
            child: const Icon(Icons.clear),
          ),
          const SizedBox(height: 8),
        ],
        
        // Botón principal para alternar modo
        FloatingActionButton(
          heroTag: 'toggle',
          onPressed: () {
            setState(() {
              _isEditMode = !_isEditMode;
            });
          },
          tooltip: _isEditMode ? 'Vista previa' : 'Editar',
          child: Icon(_isEditMode ? Icons.visibility : Icons.edit),
        ),
      ],
    );
  }

  void _updateStats() {
    _wordCount = RichTextUtils.wordCount(_currentContent);
    _charCount = RichTextUtils.characterCount(_currentContent);
  }

  void _clearContent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar contenido'),
        content: const Text('¿Estás seguro de que quieres eliminar todo el contenido?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentContent = '';
                _wordCount = 0;
                _charCount = 0;
                _isEditMode = true;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _showContentStats() {
    final plainText = RichTextUtils.getPlainText(_currentContent);
    final preview = RichTextUtils.getPreview(_currentContent, maxWords: 10);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Estadísticas del contenido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Palabras:', _wordCount.toString()),
            _buildStatRow('Caracteres:', _charCount.toString()),
            _buildStatRow('Caracteres (sin espacios):', plainText.replaceAll(' ', '').length.toString()),
            const SizedBox(height: 16),
            const Text('Vista previa:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                preview.isEmpty ? 'Sin contenido' : preview,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
