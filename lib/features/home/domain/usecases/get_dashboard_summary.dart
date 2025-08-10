import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso para obtener el resumen del dashboard
class GetDashboardSummary {
  final DashboardRepository repository;

  const GetDashboardSummary(this.repository);

  Future<Either<Failure, DashboardSummary>> call() async {
    try {
      final summary = await repository.getDashboardSummary();
      return Right(summary);
    } catch (e) {
      return Left(CacheFailure('Error al obtener resumen del dashboard: $e'));
    }
  }
}
