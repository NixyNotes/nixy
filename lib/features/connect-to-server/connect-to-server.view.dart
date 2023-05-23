import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/features/connect-to-server/controllers/connect-to-server.controller.dart';

@RoutePage()
class ConnectToServerView extends StatefulWidget {
  const ConnectToServerView({super.key, required this.url, this.onResult});
  final Function(bool success)? onResult;
  final String url;
  @override
  State<ConnectToServerView> createState() => _ConnectToServerViewState();
}

class _ConnectToServerViewState extends State<ConnectToServerView> {
  final controller = getIt<ConnectToServerController>();
  InAppWebViewSettings settings = InAppWebViewSettings();

  @override
  void initState() {
    super.initState();
    controller.init(widget.url, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialSettings: settings,
        onWebViewCreated: (webController) {
          controller.webViewController = webController;
        },
      ),
    );
  }
}

// @RoutePage()
// class ConnectToServerView extends StatelessWidget {
//   const ConnectToServerView({super.key, required this.url, this.onResult});

//   final Function(bool success)? onResult;

//   final String url;
//   String get modifiedUrl => "$url/index.php/login/flow";




//   @override
//   Widget build(BuildContext context) {
 

//     return Scaffold(
//       appBar: AppBar(),
//       body: WebViewWidget(
//         controller: webViewController,

//       ),
//     );
//   }
// }
