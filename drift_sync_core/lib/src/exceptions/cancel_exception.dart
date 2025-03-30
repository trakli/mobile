class CancelException {
  final String? message;
  final Object? innerException;

  const CancelException({
    this.message,
    this.innerException,
  });
}
