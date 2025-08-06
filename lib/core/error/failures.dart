import 'package:equatable/equatable.dart';

/// Clase abstracta para representar fallos en la aplicación
abstract class Failure extends Equatable {
  final String message;
  
  const Failure({required this.message});
  
  @override
  List<Object?> get props => [message];
}

/// Fallo del servidor (red, API, etc.)
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Fallo local (base de datos, caché, etc.)
class LocalFailure extends Failure {
  const LocalFailure({required super.message});
}

/// Fallo de conexión
class ConnectionFailure extends Failure {
  const ConnectionFailure({required super.message});
}

/// Fallo de validación
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Fallo de permisos
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Fallo de formato/parsing
class FormatFailure extends Failure {
  const FormatFailure({required super.message});
}

/// Fallo genérico/inesperado
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
