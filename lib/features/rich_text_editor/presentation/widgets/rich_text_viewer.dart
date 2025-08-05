import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

/// Widget para mostrar contenido de texto enriquecido en modo solo lectura
/// Optimizado para mostrar notas en listas y previsualizaciones
class RichTextViewer extends StatefulWidget {
  /// Contenido en formato Delta JSON
  final String content;
  
  /// Número máximo de líneas a mostrar (null = sin límite)
  final int? maxLines;
  
  /// Si debe mostrar un botón "Ver más" cuando hay overflow
  final bool showExpandButton;
  
  /// Callback cuando se toca "Ver más"
  final VoidCallback? onExpand;
  
  /// Padding interno
  final EdgeInsets padding;

  const RichTextViewer({
    super.key,
    required this.content,
    this.maxLines,
    this.showExpandButton = false,
    this.onExpand,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  State<RichTextViewer> createState() => _RichTextViewerState();
}

class _RichTextViewerState extends State<RichTextViewer> {
  late QuillController _controller;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(RichTextViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _initializeController();
    }
  }

  void _initializeController() {
    try {
      if (widget.content.isNotEmpty) {
        final document = Document.fromJson(jsonDecode(widget.content));
        _controller = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        _controller = QuillController.basic();
      }
    } catch (e) {
      // Si hay error parseando, mostrar como texto plano
      _controller = QuillController.basic();
      if (widget.content.isNotEmpty) {
        _controller.document.insert(0, widget.content);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = widget.content.isNotEmpty;
    
    if (!hasContent) {
      return Container(
        padding: widget.padding,
        child: Text(
          'Sin contenido',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: widget.padding,
          child: QuillEditor.basic(
            controller: _controller,
          ),
        ),
        
        // Botón "Ver más" si hay overflow
        if (widget.showExpandButton && widget.maxLines != null && !_isExpanded)
          _buildExpandButton(),
      ],
    );
  }

  Widget _buildExpandButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.padding.left,
        right: widget.padding.right,
        bottom: widget.padding.bottom,
      ),
      child: GestureDetector(
        onTap: () {
          if (widget.onExpand != null) {
            widget.onExpand!();
          } else {
            setState(() {
              _isExpanded = true;
            });
          }
        },
        child: Text(
          'Ver más...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Utilidades para trabajar con contenido rich text
class RichTextUtils {
  /// Extrae texto plano del contenido Delta
  static String getPlainText(String deltaJson) {
    try {
      if (deltaJson.isEmpty) return '';
      final document = Document.fromJson(jsonDecode(deltaJson));
      return document.toPlainText();
    } catch (e) {
      return deltaJson; // Fallback al contenido original
    }
  }

  /// Obtiene una preview del contenido (primeras N palabras)
  static String getPreview(String deltaJson, {int maxWords = 20}) {
    final plainText = getPlainText(deltaJson);
    final words = plainText.split(' ');
    
    if (words.length <= maxWords) {
      return plainText.trim();
    }
    
    return '${words.take(maxWords).join(' ')}...';
  }

  /// Verifica si el contenido está vacío
  static bool isEmpty(String? deltaJson) {
    if (deltaJson == null || deltaJson.isEmpty) return true;
    return getPlainText(deltaJson).trim().isEmpty;
  }

  /// Convierte texto plano a formato Delta
  static String plainTextToDelta(String plainText) {
    final doc = Document()..insert(0, plainText);
    return jsonEncode(doc.toDelta().toJson());
  }

  /// Cuenta palabras en el contenido
  static int wordCount(String deltaJson) {
    final plainText = getPlainText(deltaJson);
    if (plainText.trim().isEmpty) return 0;
    return plainText.trim().split(RegExp(r'\s+')).length;
  }

  /// Cuenta caracteres en el contenido
  static int characterCount(String deltaJson) {
    return getPlainText(deltaJson).length;
  }
}
