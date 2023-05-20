import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.body, this.title, this.actions});

  final Widget body;
  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? context.routeData.title(context)),
        actions: actions,
      ),
      body: Padding(padding: const EdgeInsets.all(10), child: body),
    );
  }
}
