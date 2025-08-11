import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notas_app/core/error/failures.dart';
import 'package:notas_app/core/usecases/usecase.dart';
import 'package:notas_app/features/home/domain/repositories/dashboard_repository.dart';

/// Caso de uso para obtener las configuraciones del dashboard
class GetDashboardSettings implements UseCase<Map<String, dynamic>, NoParams> {
  final DashboardRepository repository;

  GetDashboardSettings(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    try {
      final settings = await repository.getDashboardSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener configuraciones: $e'));
    }
  }
}

/// Caso de uso para actualizar las configuraciones del dashboard
class UpdateDashboardSettings
    implements UseCase<void, Map<String, dynamic>> {
  final DashboardRepository repository;

  const UpdateDashboardSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(Map<String, dynamic> params) async {
    try {
      await repository.updateDashboardSettings(params);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al actualizar configuraciones: $e'));
    }
  }
}

/// Caso de uso para obtener estadísticas de productividad
class GetProductivityStats
    implements UseCase<Map<String, dynamic>, GetProductivityStatsParams> {
  final DashboardRepository repository;

  const GetProductivityStats(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      GetProductivityStatsParams params) async {
    try {
      final stats = await repository.getProductivityStats(
        startDate: params.startDate,
        endDate: params.endDate,
      );
      return Right(stats);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener estadísticas: $e'));
    }
  }
}

class GetProductivityStatsParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetProductivityStatsParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
