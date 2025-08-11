import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notas_app/core/error/failures.dart';
import 'package:notas_app/core/usecases/usecase.dart';
import 'package:notas_app/features/home/domain/entities/dashboard_summary.dart';
import 'package:notas_app/features/home/domain/repositories/dashboard_repository.dart';

/// Caso de uso para obtener actividades recientes
class GetRecentActivities
    implements UseCase<List<RecentActivity>, GetRecentActivitiesParams> {
  final DashboardRepository repository;

  GetRecentActivities(this.repository);

  @override
  Future<Either<Failure, List<RecentActivity>>> call(
      GetRecentActivitiesParams params) async {
    try {
      final activities = await repository.getRecentActivities(limit: params.limit);
      return Right(activities);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener actividades: $e'));
    }
  }
}

class GetRecentActivitiesParams extends Equatable {
  final int limit;

  const GetRecentActivitiesParams({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Caso de uso para registrar una actividad
class RecordActivity implements UseCase<void, RecentActivity> {
  final DashboardRepository repository;

  RecordActivity(this.repository);

  @override
  Future<Either<Failure, void>> call(RecentActivity params) async {
    try {
      await repository.recordActivity(params);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al registrar actividad: $e'));
    }
  }
}

/// Caso de uso para limpiar actividades antiguas
class CleanupOldActivities implements UseCase<void, NoParams> {
  final DashboardRepository repository;

  CleanupOldActivities(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.cleanupOldActivities();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al limpiar actividades: $e'));
    }
  }
}
