import 'package:flutter/material.dart';

import '../../domain/entities/calendar_event.dart';

/// Diálogo para crear o editar un evento del calendario
class EventCreationDialog extends StatefulWidget {
  final DateTime initialDate;
  final CalendarEvent? initialEvent;
  final ValueChanged<CalendarEvent> onEventCreated;

  const EventCreationDialog({
    super.key,
    required this.initialDate,
    this.initialEvent,
    required this.onEventCreated,
  });

  @override
  State<EventCreationDialog> createState() => _EventCreationDialogState();
}

class _EventCreationDialogState extends State<EventCreationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isAllDay = false;
  CalendarEventType _selectedType = CalendarEventType.personal;
  String _selectedColor = 'blue';

  final List<String> _availableColors = [
    'red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'teal', 'indigo', 'cyan'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    
    if (widget.initialEvent != null) {
      final event = widget.initialEvent!;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _selectedDate = event.date;
      _isAllDay = event.isAllDay;
      _selectedType = event.type;
      _selectedColor = event.colorTag;
      
      if (!_isAllDay && event.startTime != null) {
        _startTime = TimeOfDay.fromDateTime(event.startTime!);
        if (event.endTime != null) {
          _endTime = TimeOfDay.fromDateTime(event.endTime!);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialEvent != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Editar evento' : 'Nuevo evento'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El título es requerido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 16),
                
                // Fecha
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_formatDate(_selectedDate)),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Toggle todo el día
                SwitchListTile(
                  title: const Text('Todo el día'),
                  value: _isAllDay,
                  onChanged: (value) {
                    setState(() {
                      _isAllDay = value;
                      if (value) {
                        _startTime = null;
                        _endTime = null;
                      }
                    });
                  },
                ),
                
                // Horarios (si no es todo el día)
                if (!_isAllDay) ...[
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      // Hora de inicio
                      Expanded(
                        child: InkWell(
                          onTap: _selectStartTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora inicio',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _startTime?.format(context) ?? 'Seleccionar',
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Hora de fin
                      Expanded(
                        child: InkWell(
                          onTap: _selectEndTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora fin (opcional)',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _endTime?.format(context) ?? 'Seleccionar',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Tipo de evento
                DropdownButtonFormField<CalendarEventType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de evento',
                    border: OutlineInputBorder(),
                  ),
                  items: CalendarEventType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.iconData, size: 20),
                          const SizedBox(width: 8),
                          Text(type.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Selector de color
                const Text('Color:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getColorFromTag(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 3)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveEvent,
          child: Text(isEditing ? 'Actualizar' : 'Crear'),
        ),
      ],
    );
  }

  /// Selecciona la fecha del evento
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  /// Selecciona la hora de inicio
  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _startTime = time;
      });
    }
  }

  /// Selecciona la hora de fin
  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? _startTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _endTime = time;
      });
    }
  }

  /// Guarda el evento
  void _saveEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar horarios si no es todo el día
    if (!_isAllDay && _startTime != null && _endTime != null) {
      final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
      final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
      
      if (endMinutes <= startMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La hora de fin debe ser posterior a la hora de inicio'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final now = DateTime.now();
    
    // Crear las fechas con tiempo si es necesario
    DateTime? startDateTime;
    DateTime? endDateTime;
    
    if (!_isAllDay && _startTime != null) {
      startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      
      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }
    }

    final event = CalendarEvent(
      id: widget.initialEvent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      date: _selectedDate,
      startTime: startDateTime,
      endTime: endDateTime,
      colorTag: _selectedColor,
      noteId: widget.initialEvent?.noteId,
      isAllDay: _isAllDay,
      type: _selectedType,
      createdAt: widget.initialEvent?.createdAt ?? now,
      updatedAt: now,
    );

    widget.onEventCreated(event);
    Navigator.of(context).pop();
  }

  /// Formatea una fecha
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Obtiene el color basado en la etiqueta
  Color _getColorFromTag(String colorTag) {
    switch (colorTag.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
