class CancelException implements Exception {
  final String? message;
  final Object? innerException;

  const CancelException({
    this.message,
    this.innerException,
  });
}
