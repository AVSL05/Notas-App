import 'package:dartz/dartz.dart';
import 'package:notas_app/core/error/failures.dart';
import 'package:notas_app/core/usecases/usecase.dart';
import 'package:notas_app/features/home/domain/entities/dashboard_summary.dart';
import 'package:notas_app/features/home/domain/repositories/dashboard_repository.dart';

/// Caso de uso para obtener el resumen del dashboard
class GetDashboardSummary implements UseCase<DashboardSummary, NoParams> {
  final DashboardRepository repository;

  GetDashboardSummary(this.repository);

  @override
  Future<Either<Failure, DashboardSummary>> call(NoParams params) async {
    try {
      final summary = await repository.getDashboardSummary();
      return Right(summary);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener el resumen: $e'));
    }
  }
}
