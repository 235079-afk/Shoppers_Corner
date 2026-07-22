abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class DataMappingFailure extends Failure {
  const DataMappingFailure(super.message);
}
