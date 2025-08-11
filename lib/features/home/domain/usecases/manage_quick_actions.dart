import 'package:dartz/dartz.dart';
import 'package:notas_app/core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso para obtener las acciones rápidas del dashboard
class GetQuickActions implements UseCase<List<QuickAction>, NoParams> {
  final DashboardRepository repository;

  GetQuickActions(this.repository);

  @override
  Future<Either<Failure, List<QuickAction>>> call(NoParams params) async {
    try {
      final actions = await repository.getQuickActions();
      return Right(actions);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al obtener acciones rápidas: $e'));
    }
  }
}

/// Caso de uso para actualizar las acciones rápidas
class UpdateQuickActions implements UseCase<void, List<QuickAction>> {
  final DashboardRepository repository;

  UpdateQuickActions(this.repository);

  @override
  Future<Either<Failure, void>> call(List<QuickAction> params) async {
    try {
      await repository.updateQuickActions(params);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al actualizar acciones rápidas: $e'));
    }
  }
}
