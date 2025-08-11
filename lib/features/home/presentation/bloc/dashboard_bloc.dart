import 'package:dartz/dartz.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:notas_app/core/error/failures.dart';
import 'package:notas_app/core/usecases/usecase.dart';
import 'package:notas_app/features/home/domain/entities/dashboard_summary.dart';
import 'package:notas_app/features/home/domain/usecases/get_dashboard_summary.dart';
import 'package:notas_app/features/home/domain/usecases/manage_activities.dart';
import 'package:notas_app/features/home/domain/usecases/manage_quick_actions.dart';
import 'package:notas_app/features/home/domain/usecases/dashboard_settings.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;
  final GetQuickActions getQuickActions;
  final UpdateQuickActions updateQuickActions;
  final GetRecentActivities getRecentActivities;
  final RecordActivity recordActivity;
  final CleanupOldActivities cleanupOldActivities;
  final GetDashboardSettings getDashboardSettings;
  final UpdateDashboardSettings updateDashboardSettings;
  final GetProductivityStats getProductivityStats;

  DashboardBloc({
    required this.getDashboardSummary,
    required this.getQuickActions,
    required this.updateQuickActions,
    required this.getRecentActivities,
    required this.recordActivity,
    required this.cleanupOldActivities,
    required this.getDashboardSettings,
    required this.updateDashboardSettings,
    required this.getProductivityStats,
  }) : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<ExecuteQuickAction>(_onExecuteQuickAction);
    on<ToggleQuickAction>(_onToggleQuickAction);
    on<RecordActivityEvent>(_onRecordActivity);
    on<CleanupOldActivitiesEvent>(_onCleanupOldActivities);
    on<LoadProductivityStats>(_onLoadProductivityStats);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final results = await Future.wait([
      getDashboardSummary(NoParams()),
      getQuickActions(NoParams()),
      getRecentActivities(const GetRecentActivitiesParams()),
      getDashboardSettings(NoParams()),
    ]);

    final summaryResult = results[0] as Either<Failure, DashboardSummary>;
    final quickActionsResult = results[1] as Either<Failure, List<QuickAction>>;
    final recentActivitiesResult =
        results[2] as Either<Failure, List<RecentActivity>>;
    final settingsResult =
        results[3] as Either<Failure, Map<String, dynamic>>;

    final FailableResults failableResults = [
      summaryResult,
      quickActionsResult,
      recentActivitiesResult,
      settingsResult
    ];

    if (failableResults.any((r) => r.isLeft())) {
      final error = failableResults
          .firstWhere((r) => r.isLeft())
          .fold((l) => l, (r) => null);
      emit(DashboardError(message: 'Failed to load dashboard: $error'));
      return;
    }

    emit(DashboardLoaded(
      summary: summaryResult.getOrElse(() => DashboardSummary.empty),
      quickActions: quickActionsResult.getOrElse(() => []),
      recentActivities: recentActivitiesResult.getOrElse(() => []),
      settings: settingsResult.getOrElse(() => {}),
    ));
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    add(const LoadDashboard());
  }

  void _onExecuteQuickAction(
    ExecuteQuickAction event,
    Emitter<DashboardState> emit,
  ) {
    print('Executing action: ${event.action.route}');
  }

  Future<void> _onToggleQuickAction(
    ToggleQuickAction event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final updatedActions = currentState.quickActions.map((action) {
        if (action.id == event.actionId) {
          return action.copyWith(isEnabled: event.isEnabled);
        }
        return action;
      }).toList();

      await updateQuickActions(updatedActions);
      add(const RefreshDashboard());
    }
  }

  Future<void> _onRecordActivity(
    RecordActivityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final activity = RecentActivity(
      id: DateTime.now().toIso8601String(),
      type: event.type,
      title: event.title,
      description: event.description,
      timestamp: DateTime.now(),
      entityId: event.entityId ?? '',
      metadata: event.metadata ?? {},
    );
    await recordActivity(activity);
    add(const RefreshDashboard());
  }

  Future<void> _onCleanupOldActivities(
    CleanupOldActivitiesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    await cleanupOldActivities(NoParams());
    add(const RefreshDashboard());
  }

  Future<void> _onLoadProductivityStats(
    LoadProductivityStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingStats());
    final result = await getProductivityStats(
      GetProductivityStatsParams(
          startDate: event.startDate, endDate: event.endDate),
    );
    result.fold(
      (failure) => emit(DashboardError(message: failure.toString())),
      (stats) => emit(DashboardStatsLoaded(
        stats: stats,
        startDate: event.startDate,
        endDate: event.endDate,
      )),
    );
  }
}

typedef FailableResults = List<Either<Failure, dynamic>>;

