// ignore_for_file: public_member_api_docs

import 'package:flash/flash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';
import 'package:nextcloudnotes/core/controllers/app.controller.dart';
import 'package:nextcloudnotes/core/router/router.dart';
import 'package:nextcloudnotes/core/scheme/note.scheme.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';
import 'package:nextcloudnotes/core/services/log.service.dart';
import 'package:nextcloudnotes/core/services/provider.service.dart';
import 'package:nextcloudnotes/core/services/sync.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await getIt<LogService>().init();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  await initDb([UserSchema, LocalNoteSchema]);

  runApp(const NixyApp());
}

class NixyApp extends StatefulWidget {
  const NixyApp({super.key});

  @override
  State<NixyApp> createState() => _NixyAppState();
}

class _NixyAppState extends State<NixyApp> {
  final appRouter = getIt<AppRouter>();
  final AppController _appController = getIt<AppController>();
  final Adapter _adapter = getIt<Adapter>();
  final ProviderService _providerService = getIt<ProviderService>();
  final SyncService _syncService = getIt<SyncService>();

  @override
  void initState() {
    super.initState();
    _appController.init();
    _adapter.init();
    _adapter.currentAuthAdapter.value?.tokenRenewBackgroundService();
    _providerService.init();
    _syncService.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nixy',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.orangeAccent,
        ),
        useMaterial3: true,
        dividerTheme: DividerThemeData(color: Colors.grey.shade100),
        scaffoldBackgroundColor: Colors.grey.shade800,
      ).copyWith(extensions: [const FlashToastTheme(), const FlashBarTheme()]),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
          primary: Colors.orangeAccent,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        dividerTheme: DividerThemeData(color: Colors.grey.shade100),
      ).copyWith(extensions: [const FlashToastTheme(), const FlashBarTheme()]),
      routerConfig: appRouter.router,
    );
  }
}
