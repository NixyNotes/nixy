import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

import 'core/router/router.dart';

final scaffolMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  configureDependencies();

  WidgetsFlutterBinding.ensureInitialized();
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
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orangeAccent, primary: Colors.orangeAccent),
        useMaterial3: true,
      ),
      routerConfig: appRouter.config(),
      scaffoldMessengerKey: scaffolMessengerKey,
    );
  }
}
