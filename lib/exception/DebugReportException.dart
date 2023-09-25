class DebugReportException implements Exception {
  String message;

  DebugReportException(this.message);

  @override
  String toString() {
    return 'MyException: $message';
  }
}
