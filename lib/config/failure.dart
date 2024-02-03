abstract class Failure implements Exception {
  final String? message;

  Failure({required this.message});
}

class FetchFailure extends Failure {
  FetchFailure({required super.message});
}

class BadRequestFailure extends Failure {
  BadRequestFailure({required super.message});
}

class UnauthorisedFailure extends Failure {
  UnauthorisedFailure({required super.message});
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure({required super.message});
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure({required super.message});
}

class NotFoundFailure extends Failure {
  NotFoundFailure({required super.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}
