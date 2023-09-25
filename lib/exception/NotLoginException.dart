class NotLoginException implements Exception {
  String message;

  NotLoginException(this.message);

  @override
  String toString() {
    return 'MyException: $message';
  }
}
