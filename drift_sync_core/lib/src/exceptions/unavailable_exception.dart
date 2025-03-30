class UnavailableException {
  final String? message;
  final Object? innerException;

  const UnavailableException({
    this.message,
    this.innerException,
  });
}
