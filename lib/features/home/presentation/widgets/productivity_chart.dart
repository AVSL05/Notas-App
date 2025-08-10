import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../domain/entities/dashboard_summary.dart';

/// Widget de gráfico de productividad
class ProductivityChart extends StatefulWidget {
  final DashboardSummary summary;
  final Function(DateTime startDate, DateTime endDate)? onPeriodChanged;

  const ProductivityChart({
    super.key,
    required this.summary,
    this.onPeriodChanged,
  });

  @override
  State<ProductivityChart> createState() => _ProductivityChartState();
}

class _ProductivityChartState extends State<ProductivityChart> {
  ProductivityPeriod _selectedPeriod = ProductivityPeriod.week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con selector de período
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Productividad',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _PeriodSelector(
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: _handlePeriodChanged,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Gráfico principal
            SizedBox(
              height: 200,
              child: _buildChart(context),
            ),
            
            const SizedBox(height: 16),
            
            // Leyenda y métricas
            _buildLegendAndMetrics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final level = widget.summary.productivityLevel;
    final color = Color(int.parse('0xFF${level.colorHex.substring(1)}'));
    
    // Datos de ejemplo - en implementación real se obtendrían de las estadísticas
    final chartData = _generateSampleData();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  _getBottomTitle(value.toInt()),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              reservedSize: 32,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
            left: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
        minX: 0,
        maxX: _getMaxX(),
        minY: 0,
        maxY: 100,
      ),
    );
  }

  Widget _buildLegendAndMetrics(BuildContext context) {
    final theme = Theme.of(context);
    final level = widget.summary.productivityLevel;
    final color = Color(int.parse('0xFF${level.colorHex.substring(1)}'));
    
    return Row(
      children: [
        // Leyenda
        Expanded(
          child: Row(
            children: [
              Container(
                width: 12,
                height: 3,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Nivel de productividad',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        
        // Métricas rápidas
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${widget.summary.completionPercentage.toStringAsFixed(1)}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              'Promedio actual',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handlePeriodChanged(ProductivityPeriod period) {
    setState(() {
      _selectedPeriod = period;
    });
    
    if (widget.onPeriodChanged != null) {
      final dates = _getPeriodDates(period);
      widget.onPeriodChanged!(dates.start, dates.end);
    }
  }

  List<FlSpot> _generateSampleData() {
    // Datos de ejemplo - en implementación real se calcularían de las actividades
    switch (_selectedPeriod) {
      case ProductivityPeriod.week:
        return [
          const FlSpot(0, 45),
          const FlSpot(1, 65),
          const FlSpot(2, 55),
          const FlSpot(3, 75),
          const FlSpot(4, 85),
          const FlSpot(5, 70),
          const FlSpot(6, 80),
        ];
      case ProductivityPeriod.month:
        return [
          const FlSpot(0, 60),
          const FlSpot(1, 70),
          const FlSpot(2, 65),
          const FlSpot(3, 80),
        ];
      case ProductivityPeriod.year:
        return [
          const FlSpot(0, 55),
          const FlSpot(1, 60),
          const FlSpot(2, 65),
          const FlSpot(3, 70),
          const FlSpot(4, 75),
          const FlSpot(5, 80),
          const FlSpot(6, 78),
          const FlSpot(7, 82),
          const FlSpot(8, 85),
          const FlSpot(9, 88),
          const FlSpot(10, 85),
          const FlSpot(11, 90),
        ];
    }
  }

  String _getBottomTitle(int value) {
    switch (_selectedPeriod) {
      case ProductivityPeriod.week:
        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
        return value < days.length ? days[value] : '';
      case ProductivityPeriod.month:
        const weeks = ['S1', 'S2', 'S3', 'S4'];
        return value < weeks.length ? weeks[value] : '';
      case ProductivityPeriod.year:
        const months = ['E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
        return value < months.length ? months[value] : '';
    }
  }

  double _getMaxX() {
    switch (_selectedPeriod) {
      case ProductivityPeriod.week:
        return 6;
      case ProductivityPeriod.month:
        return 3;
      case ProductivityPeriod.year:
        return 11;
    }
  }

  ({DateTime start, DateTime end}) _getPeriodDates(ProductivityPeriod period) {
    final now = DateTime.now();
    
    switch (period) {
      case ProductivityPeriod.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return (
          start: startOfWeek,
          end: startOfWeek.add(const Duration(days: 6)),
        );
      case ProductivityPeriod.month:
        return (
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );
      case ProductivityPeriod.year:
        return (
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, 12, 31),
        );
    }
  }
}

/// Selector de período para el gráfico
class _PeriodSelector extends StatelessWidget {
  final ProductivityPeriod selectedPeriod;
  final Function(ProductivityPeriod) onPeriodChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ProductivityPeriod>(
      segments: const [
        ButtonSegment(
          value: ProductivityPeriod.week,
          label: Text('Semana'),
        ),
        ButtonSegment(
          value: ProductivityPeriod.month,
          label: Text('Mes'),
        ),
        ButtonSegment(
          value: ProductivityPeriod.year,
          label: Text('Año'),
        ),
      ],
      selected: {selectedPeriod},
      onSelectionChanged: (Set<ProductivityPeriod> selection) {
        if (selection.isNotEmpty) {
          onPeriodChanged(selection.first);
        }
      },
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// Períodos disponibles para las estadísticas
enum ProductivityPeriod {
  week,
  month,
  year,
}
