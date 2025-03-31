class ConflictException implements Exception {
  final String? message;
  final Object? innerException;

  const ConflictException({
    this.message,
    this.innerException,
  });
}
