import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/di/di.dart';
import 'package:nextcloudnotes/features/connect-to-server/controllers/connect-to-server.controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class ConnectToServerView extends StatelessWidget {
  const ConnectToServerView({super.key, required this.url});

  final String url;
  String get modifiedUrl => "$url/index.php/login/flow";

  @override
  Widget build(BuildContext context) {
    final controller = getIt<ConnectToServerController>();
    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith('nc://')) {
              controller.onLoadCustomScheme(request, context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(modifiedUrl),
        headers: {"OCS-APIREQUEST": "true"},
      );

    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: webViewController,
      ),
    );
  }
}
