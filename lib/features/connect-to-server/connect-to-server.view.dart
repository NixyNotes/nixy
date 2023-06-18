import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/utils/platform.dart';
import 'package:nextcloudnotes/features/connect-to-server/controllers/connect-to-server.controller.dart';

// ignore: public_member_api_docs
class ConnectToServerView extends StatefulWidget {
// ignore: public_member_api_docs
  const ConnectToServerView({required this.url, super.key});

  /// `final String url;` is declaring a final variable `url` of type `String` in the
  /// `ConnectToServerView` class. It is used to store the URL that the user wants to connect to. The
  /// `final` keyword indicates that the value of `url` cannot be changed once it is set.
  final String url;
  @override
  State<ConnectToServerView> createState() => _ConnectToServerViewState();
}

class _ConnectToServerViewState extends State<ConnectToServerView> {
  final controller = getIt<ConnectToServerController>();
  InAppWebViewSettings settings =
      InAppWebViewSettings(userAgent: 'Nixy/1.0', cacheEnabled: false);

  @override
  void initState() {
    super.initState();
    controller.init(widget.url, context);
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<ConnectToServerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDesktopPlatform();
    return Scaffold(
      appBar: AppBar(),
      body: isDesktop
          ? const Center(
              child: Text('Please contiune from browser..'),
            )
          : InAppWebView(
              initialSettings: settings,
              onWebViewCreated: (webController) {
                controller.webViewController = webController;
              },
            ),
    );
  }
}
