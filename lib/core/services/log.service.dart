import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// The LogService class is a lazy singleton that provides a logger instance.
@lazySingleton
class LogService {
  /// Creating an instance of the `Logger` class from the `logger` package and assigning it to the
  /// `logger` variable. This allows the `LogService` class to use the `Logger` instance to log messages.
  late final Logger logger;

  /// If class is initilazed
  bool isInitialized = false;

  /// Init logger
  Future<void> init() async {
    final folder = await getApplicationDocumentsDirectory();
    final filePath = p.join(folder.path, 'nixy.txt');
    final file = File(filePath);
    final fileOutPut = FileOutput(file: file);
    final consoleOutput = ConsoleOutput();
    final multiOutput = <LogOutput>[fileOutPut, consoleOutput];

    logger = Logger(
      output: MultiOutput(multiOutput),
      printer: PrettyPrinter(
        printEmojis: false,
        printTime: true,
        colors: false,
      ),
    );

    isInitialized = true;
  }
}
