import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

/// Caso de uso para obtener las acciones rápidas del dashboard
class GetQuickActions {
  final DashboardRepository repository;

  const GetQuickActions(this.repository);

  Future<Either<Failure, List<QuickAction>>> call() async {
    try {
      final actions = await repository.getQuickActions();
      return Right(actions);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}

/// Caso de uso para actualizar las acciones rápidas
class UpdateQuickActions {
  final DashboardRepository repository;

  const UpdateQuickActions(this.repository);

  Future<Either<Failure, void>> call(List<QuickAction> actions) async {
    try {
      await repository.updateQuickActions(actions);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error al actualizar acciones rápidas: $e'));
    }
  }
}
