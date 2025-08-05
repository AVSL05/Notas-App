import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

/// Widget personalizado para edición de texto enriquecido
/// Integra flutter_quill con funcionalidades específicas para notas
class RichTextEditor extends StatefulWidget {
  /// Contenido inicial en formato Delta JSON
  final String? initialContent;
  
  /// Callback cuando el contenido cambia
  final Function(String deltaJson)? onContentChanged;
  
  /// Si el editor es de solo lectura
  final bool readOnly;
  
  /// Placeholder cuando está vacío
  final String placeholder;
  
  /// Altura mínima del editor
  final double minHeight;
  
  /// Si debe mostrar la toolbar
  final bool showToolbar;

  const RichTextEditor({
    super.key,
    this.initialContent,
    this.onContentChanged,
    this.readOnly = false,
    this.placeholder = 'Escribe tu nota aquí...',
    this.minHeight = 200,
    this.showToolbar = true,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.initialContent != null && widget.initialContent!.isNotEmpty) {
      try {
        // Intentar parsear el contenido existente
        final delta = Document.fromJson(jsonDecode(widget.initialContent!));
        _controller = QuillController(
          document: delta,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Si falla el parsing, crear un documento con texto plano
        _controller = QuillController.basic();
        _controller.document.insert(0, widget.initialContent!);
      }
    } else {
      // Crear documento vacío
      _controller = QuillController.basic();
    }

    // Listener para cambios en el contenido
    _controller.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    if (widget.onContentChanged != null) {
      final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
      widget.onContentChanged!(deltaJson);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar personalizada
        if (widget.showToolbar && !widget.readOnly) ...[
          _buildCustomToolbar(),
          const Divider(height: 1),
        ],
        
        // Editor principal
        Expanded(
          child: Container(
            constraints: BoxConstraints(minHeight: widget.minHeight),
            padding: const EdgeInsets.all(16),
            child: QuillEditor.basic(
              controller: _controller,
            ),
          ),
        ),
      ],
    );
  }

  /// Construye una toolbar personalizada con los controles más importantes
  Widget _buildCustomToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: const SizedBox(
        height: 40,
        child: Center(
          child: Text(
            'Toolbar (flutter_quill 11.x)',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}

/// Extensión para obtener el contenido como texto plano
extension RichTextEditorExtension on RichTextEditor {
  static String getPlainText(String deltaJson) {
    try {
      final document = Document.fromJson(jsonDecode(deltaJson));
      return document.toPlainText();
    } catch (e) {
      return deltaJson; // Fallback al contenido original
    }
  }

  static bool isEmpty(String? deltaJson) {
    if (deltaJson == null || deltaJson.isEmpty) return true;
    
    try {
      final document = Document.fromJson(jsonDecode(deltaJson));
      return document.toPlainText().trim().isEmpty;
    } catch (e) {
      return deltaJson.trim().isEmpty;
    }
  }
}
