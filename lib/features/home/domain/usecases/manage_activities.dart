import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso para obtener actividades recientes
class GetRecentActivities {
  final DashboardRepository repository;

  const GetRecentActivities(this.repository);

  Future<Either<Failure, List<RecentActivity>>> call({int limit = 10}) async {
    try {
      final activities = await repository.getRecentActivities(limit: limit);
      return Right(activities);
    } catch (e) {
      return Left(CacheFailure('Error al obtener actividades recientes: $e'));
    }
  }
}

/// Caso de uso para registrar una nueva actividad
class RecordActivity {
  final DashboardRepository repository;

  const RecordActivity(this.repository);

  Future<Either<Failure, void>> call(RecentActivity activity) async {
    try {
      await repository.recordActivity(activity);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al registrar actividad: $e'));
    }
  }
}

/// Caso de uso para limpiar actividades antiguas
class CleanupOldActivities {
  final DashboardRepository repository;

  const CleanupOldActivities(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.cleanupOldActivities();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al limpiar actividades antiguas: $e'));
    }
  }
}
