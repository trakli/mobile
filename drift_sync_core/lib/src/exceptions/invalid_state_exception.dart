class InvalidStateException implements Exception {
  final String? message;
  final Object? innerException;

  const InvalidStateException({
    this.message,
    this.innerException,
  });
}
