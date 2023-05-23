import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class LogService {
  final Logger logger = Logger();
}
