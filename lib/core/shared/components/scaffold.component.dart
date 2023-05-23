import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {super.key,
      required this.body,
      this.title,
      this.actions,
      this.showAppBar = true,
      this.bottomBar});

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool? showAppBar;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar!
          ? AppBar(
              title: Text(title ?? context.routeData.title(context)),
              actions: actions,
            )
          : null,
      bottomNavigationBar: bottomBar,
      body: Padding(padding: const EdgeInsets.all(10), child: body),
    );
  }
}
