import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {super.key,
      required this.body,
      this.title,
      this.actions,
      this.showAppBar = true,
      this.bottomBar,
      this.innerPadding = true});

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool? showAppBar;
  final Widget? bottomBar;
  final bool? innerPadding;

  @override
  Widget build(BuildContext context) {
    final bodyWithPadding = innerPadding != null && innerPadding == false
        ? body
        : Padding(padding: const EdgeInsets.all(10), child: body);
    return Scaffold(
      appBar: showAppBar!
          ? AppBar(
              title: Text(title ?? context.routeData.title(context)),
              actions: actions,
            )
          : null,
      bottomNavigationBar: bottomBar,
      body: bodyWithPadding,
    );
  }
}
