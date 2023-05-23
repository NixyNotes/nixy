import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

import 'core/router/router.dart';

final scaffolMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  configureDependencies();

  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await initDb([UserSchema]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Colors.orangeAccent,
            primary: Colors.orangeAccent,
            primaryContainer: Colors.grey.shade800),
        useMaterial3: true,
        dividerTheme: DividerThemeData(color: Colors.grey.shade100),
        scaffoldBackgroundColor: Colors.grey.shade800,
      ),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orangeAccent,
            primary: Colors.orangeAccent,
            primaryContainer: Colors.grey.shade500),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        dividerTheme: DividerThemeData(color: Colors.grey.shade100),
      ),
      routerConfig: appRouter.config(),
      scaffoldMessengerKey: scaffolMessengerKey,
    );
  }
}
