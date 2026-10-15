class ApiException implements Exception {
  ApiException(this.message, {this.errorCode = 'UNKNOWN', this.statusCode, this.isNetwork = false});
  final String message;
  final String errorCode;
  final int? statusCode;
  final bool isNetwork;
  @override
  String toString() => 'ApiException($errorCode, $statusCode): $message';
}
