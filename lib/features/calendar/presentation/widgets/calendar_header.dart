import 'package:flutter/material.dart';

/// Header del calendario con navegación de mes y año
class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<int> onYearChanged;

  const CalendarHeader({
    super.key,
    required this.currentMonth,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Navegación de mes anterior
          IconButton(
            onPressed: () {
              final previousMonth = DateTime(
                currentMonth.year,
                currentMonth.month - 1,
              );
              onMonthChanged(previousMonth);
            },
            icon: const Icon(Icons.chevron_left),
          ),
          
          // Título del mes y año (clickeable para selector)
          Expanded(
            child: GestureDetector(
              onTap: () => _showMonthYearPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _formatMonthYear(currentMonth),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Navegación de mes siguiente
          IconButton(
            onPressed: () {
              final nextMonth = DateTime(
                currentMonth.year,
                currentMonth.month + 1,
              );
              onMonthChanged(nextMonth);
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  /// Formatea el mes y año para mostrar
  String _formatMonthYear(DateTime date) {
    const monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  /// Muestra el selector de mes y año
  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _MonthYearPickerDialog(
        initialDate: currentMonth,
        onDateSelected: (date) {
          onMonthChanged(date);
          if (date.year != currentMonth.year) {
            onYearChanged(date.year);
          }
        },
      ),
    );
  }
}

/// Diálogo para seleccionar mes y año
class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthYearPickerDialog({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    const monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];

    return AlertDialog(
      title: const Text('Seleccionar mes y año'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector de año
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedYear--;
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  _selectedYear.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedYear++;
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Grid de meses
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final isSelected = month == _selectedMonth;
                
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMonth = month;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        monthNames[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final selectedDate = DateTime(_selectedYear, _selectedMonth);
            widget.onDateSelected(selectedDate);
            Navigator.of(context).pop();
          },
          child: const Text('Seleccionar'),
        ),
      ],
    );
  }
}
