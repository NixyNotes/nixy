import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/di/di.config.dart';

/// Getit instance
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)

/// Getit init
void configureDependencies() => getIt.init();
