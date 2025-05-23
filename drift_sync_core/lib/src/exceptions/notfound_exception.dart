class NotFoundException implements Exception {
  final String? message;
  final Object? innerException;

  const NotFoundException({
    this.message,
    this.innerException,
  });
}
