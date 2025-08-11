import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/dashboard_metrics_cards.dart';
import '../widgets/recent_activities_list.dart';
import '../widgets/productivity_chart.dart';
import '../widgets/dashboard_fab.dart';
import '../../../../core/presentation/widgets/loading_widget.dart';
import '../../../../core/presentation/widgets/error_widget.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../../../core/presentation/widgets/error_widget.dart';

/// Página principal del dashboard/home
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ScrollController _scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    
    // Cargar datos iniciales
    context.read<DashboardBloc>().add(const LoadDashboard());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Reintentar',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<DashboardBloc>().add(const LoadDashboard());
                  },
                ),
              ),
            );
          }
          
          if (state is DashboardRecordingActivity) {
            HapticFeedback.lightImpact();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: _buildBody(context, state),
          );
        },
      ),
      floatingActionButton: BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (previous, current) => current is DashboardLoaded,
        builder: (context, state) {
          if (state is DashboardLoaded) {
            return DashboardFab(
              onCreateNote: () => _handleQuickAction(state.quickActions.firstWhere((a) => a.id == 'create_note')),
              onCreateTask: () => _handleQuickAction(state.quickActions.firstWhere((a) => a.id == 'create_task')),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Construye el cuerpo principal de la página
  Widget _buildBody(BuildContext context, DashboardState state) {
    if (state is DashboardLoading) {
      return const Center(child: LoadingWidget());
    }

    if (state is DashboardError) {
      return Center(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () {
            context.read<DashboardBloc>().add(const LoadDashboard());
          },
        ),
      );
    }

    if (state is DashboardLoaded) {
      return _buildDashboardContent(context, state);
    }

    return const SizedBox.shrink();
  }

  /// Construye el contenido principal del dashboard
  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: DashboardHeader(
                summary: state.summary,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  icon: Icon(Icons.dashboard),
                  text: 'Resumen',
                ),
                Tab(
                  icon: Icon(Icons.timeline),
                  text: 'Actividad',
                ),
                Tab(
                  icon: Icon(Icons.insights),
                  text: 'Estadísticas',
                ),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, state),
          _buildActivityTab(context, state),
          _buildStatsTab(context, state),
        ],
      ),
    );
  }

  /// Construye la pestaña de resumen
  Widget _buildOverviewTab(BuildContext context, DashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Métricas principales
          DashboardMetricsCards(summary: state.summary),
          
          const SizedBox(height: 24),
          
          // Acciones rápidas
          _buildSectionHeader(
            context,
            'Acciones Rápidas',
            Icons.flash_on,
            onAction: () => _showQuickActionsSettings(context, state),
          ),
          
          const SizedBox(height: 12),
          
          QuickActionsGrid(
            actions: state.quickActions,
            onActionTap: (type) {
              final action = state.quickActions.firstWhere((a) => a.type == type);
              _handleQuickAction(action);
            },
            onActionLongPress: _handleQuickActionLongPress,
          ),
          
          const SizedBox(height: 24),
          
          // Actividades recientes (resumen)
          _buildSectionHeader(
            context,
            'Actividad Reciente',
            Icons.history,
            onAction: () => _tabController.animateTo(1),
          ),
          
          const SizedBox(height: 12),
          
          RecentActivitiesList(
            activities: state.recentActivities.take(5).toList(),
            isCompact: true,
            onActivityTap: _handleActivityTap,
          ),
          
          if (state.recentActivities.length > 5) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => _tabController.animateTo(1),
                child: Text(
                  'Ver todas las actividades (${state.recentActivities.length})',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 100), // Espacio para el FAB
        ],
      ),
    );
  }

  /// Construye la pestaña de actividad
  Widget _buildActivityTab(BuildContext context, DashboardLoaded state) {
    return Column(
      children: [
        // Barra de herramientas de actividades
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${state.recentActivities.length} actividades',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showActivityFilters(context),
                tooltip: 'Filtros',
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showActivitySearch(context),
                tooltip: 'Buscar',
              ),
              IconButton(
                icon: const Icon(Icons.cleaning_services),
                onPressed: () => _showCleanupDialog(context),
                tooltip: 'Limpiar actividades antiguas',
              ),
            ],
          ),
        ),
        
        // Lista de actividades
        Expanded(
          child: state.recentActivities.isEmpty
              ? _buildEmptyActivities(context)
              : RecentActivitiesList(
                  activities: state.recentActivities,
                  isCompact: false,
                  onActivityTap: _handleActivityTap,
                ),
        ),
      ],
    );
  }

  /// Construye la pestaña de estadísticas
  Widget _buildStatsTab(BuildContext context, DashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gráfico de productividad
          ProductivityChart(
            summary: state.summary,
            onPeriodChanged: _handlePeriodChanged,
          ),
          
          const SizedBox(height: 24),
          
          // Métricas detalladas
          _buildDetailedMetrics(context, state),
          
          const SizedBox(height: 24),
          
          // Configuraciones de estadísticas
          _buildStatsSettings(context, state),
        ],
      ),
    );
  }

  /// Construye un encabezado de sección
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (onAction != null)
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: onAction,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
      ],
    );
  }

  /// Construye vista de actividades vacías
  Widget _buildEmptyActivities(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay actividades recientes',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza creando notas o tareas para ver tu actividad',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final createNoteAction = (context.read<DashboardBloc>().state as DashboardLoaded)
                  .quickActions
                  .firstWhere((a) => a.id == 'create_note');
              _handleQuickAction(createNoteAction);
            },
            icon: const Icon(Icons.note_add),
            label: const Text('Crear Primera Nota'),
          ),
        ],
      ),
    );
  }

  /// Construye métricas detalladas
  Widget _buildDetailedMetrics(BuildContext context, DashboardLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Métricas Detalladas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Implementar métricas detalladas
            Text(
              'Productividad: ${state.summary.productivityLevel.displayName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Completación: ${state.summary.completionPercentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye configuraciones de estadísticas
  Widget _buildStatsSettings(BuildContext context, DashboardLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuraciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Implementar configuraciones de estadísticas
            const Text('Próximamente: Configuraciones personalizables'),
          ],
        ),
      ),
    );
  }

  /// Maneja el refresco del dashboard
  Future<void> _handleRefresh() async {
    context.read<DashboardBloc>().add(const RefreshDashboard());
    
    // Simular tiempo de refresco
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Maneja la ejecución de una acción rápida
  void _handleQuickAction(QuickAction action) {
    context.read<DashboardBloc>().add(
      ExecuteQuickAction(action: action),
    );
    
    // TODO: Implementar navegación específica para cada acción
    switch (action.id) {
      case 'create_note':
        // Navigator.pushNamed(context, '/notes/create');
        _showNotImplemented(context, 'Crear nota');
        break;
      case 'create_task':
        // Navigator.pushNamed(context, '/tasks/create');
        _showNotImplemented(context, 'Crear lista de tareas');
        break;
      case 'view_calendar':
        // Navigator.pushNamed(context, '/calendar');
        _showNotImplemented(context, 'Ver calendario');
        break;
      case 'search_notes':
        // Navigator.pushNamed(context, '/search');
        _showNotImplemented(context, 'Buscar notas');
        break;
      case 'view_favorites':
        // Navigator.pushNamed(context, '/favorites');
        _showNotImplemented(context, 'Ver favoritas');
        break;
      case 'view_archived':
        // Navigator.pushNamed(context, '/archived');
        _showNotImplemented(context, 'Ver archivadas');
        break;
      case 'settings':
        // Navigator.pushNamed(context, '/settings');
        _showNotImplemented(context, 'Configuraciones');
        break;
      case 'backup':
        _showBackupDialog(context);
        break;
    }
  }

  /// Maneja la pulsación larga en una acción rápida
  void _handleQuickActionLongPress(QuickAction action) {
    _showQuickActionOptions(context, action);
  }

  /// Maneja el tap en una actividad
  void _handleActivityTap(RecentActivity activity) {
    if (activity.entityId.isNotEmpty) {
      // TODO: Navegar al elemento relacionado
      _showNotImplemented(context, 'Navegar a ${activity.title}');
    }
  }

  /// Maneja el cambio de período en estadísticas
  void _handlePeriodChanged(DateTime startDate, DateTime endDate) {
    context.read<DashboardBloc>().add(
      LoadProductivityStats(
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  /// Muestra configuraciones de acciones rápidas
  void _showQuickActionsSettings(BuildContext context, DashboardLoaded state) {
    _showNotImplemented(context, 'Configurar acciones rápidas');
  }

  /// Muestra opciones de una acción rápida
  void _showQuickActionOptions(BuildContext context, QuickAction action) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _showNotImplemented(context, 'Editar acción rápida');
              },
            ),
            ListTile(
              leading: Icon(
                action.isEnabled ? Icons.visibility_off : Icons.visibility,
              ),
              title: Text(action.isEnabled ? 'Ocultar' : 'Mostrar'),
              onTap: () {
                Navigator.pop(context);
                context.read<DashboardBloc>().add(
                  ToggleQuickAction(
                    actionId: action.id,
                    isEnabled: !action.isEnabled,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra filtros de actividades
  void _showActivityFilters(BuildContext context) {
    _showNotImplemented(context, 'Filtros de actividades');
  }

  /// Muestra búsqueda de actividades
  void _showActivitySearch(BuildContext context) {
    _showNotImplemented(context, 'Buscar actividades');
  }

  /// Muestra diálogo de limpieza de actividades
  void _showCleanupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Actividades'),
        content: const Text(
          '¿Deseas eliminar las actividades anteriores a 30 días? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DashboardBloc>().add(const CleanupOldActivitiesEvent());
            },
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  /// Muestra diálogo de backup
  void _showBackupDialog(BuildContext context) {
    _showNotImplemented(context, 'Función de backup');
  }

  /// Muestra mensaje de función no implementada
  void _showNotImplemented(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
