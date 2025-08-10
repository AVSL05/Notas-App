import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso para actualizar las métricas del dashboard
class UpdateDashboardMetrics {
  final DashboardRepository repository;

  const UpdateDashboardMetrics(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.updateDashboardMetrics();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al actualizar métricas del dashboard: $e'));
    }
  }
}

/// Caso de uso para obtener configuraciones del dashboard
class GetDashboardSettings {
  final DashboardRepository repository;

  const GetDashboardSettings(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    try {
      final settings = await repository.getDashboardSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Error al obtener configuraciones del dashboard: $e'));
    }
  }
}

/// Caso de uso para actualizar configuraciones del dashboard
class UpdateDashboardSettings {
  final DashboardRepository repository;

  const UpdateDashboardSettings(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> settings) async {
    try {
      await repository.updateDashboardSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al actualizar configuraciones del dashboard: $e'));
    }
  }
}

/// Caso de uso para obtener estadísticas de productividad
class GetProductivityStats {
  final DashboardRepository repository;

  const GetProductivityStats(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final stats = await repository.getProductivityStats(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(stats);
    } catch (e) {
      return Left(CacheFailure('Error al obtener estadísticas de productividad: $e'));
    }
  }
}
