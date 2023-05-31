import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// The LogService class is a lazy singleton that provides a logger instance.
@lazySingleton
class LogService {
  /// Creating an instance of the `Logger` class from the `logger` package and assigning it to the
  /// `logger` variable. This allows the `LogService` class to use the `Logger` instance to log messages.
  final Logger logger = Logger();
}
