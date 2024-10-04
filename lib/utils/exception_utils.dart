import 'package:book/core/constants.dart';

class ServerConnectionException implements Exception {
  const ServerConnectionException();

  String? get message => timeoutErrorMessage;

  @override
  String toString() => timeoutErrorMessage;
}
