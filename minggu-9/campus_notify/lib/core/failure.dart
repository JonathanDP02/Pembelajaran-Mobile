abstract class Failure implements Exception {
  const Failure({required this.message});

  final String message;
}

class LocalFailure extends Failure {
  const LocalFailure(String message) : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message: message);
}
