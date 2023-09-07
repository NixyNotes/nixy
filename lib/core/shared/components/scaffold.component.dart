import 'package:flutter/material.dart';

/// The `AppScaffold` class is a customizable scaffold widget that can display an app bar, bottom
/// navigation bar, and body with optional inner padding.
class AppScaffold extends StatelessWidget {
  /// The `AppScaffold` class is a customizable scaffold widget that can display an app bar, bottom
  /// navigation bar, and body with optional inner padding.
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.showAppBar = true,
    this.bottomBar,
    this.innerPadding = true,
    this.appBarLeading,
  });

  /// The `final Widget body;` is declaring a required parameter named `body` of type `Widget` for the
  /// `AppScaffold` class. This parameter is used to specify the main content of the scaffold.
  final Widget body;

  /// `final String? title;` is declaring a nullable final variable named `title` of type `String`. It is
  /// an optional parameter for the `AppScaffold` class that can be used to specify the title of the app
  /// bar.
  final String? title;

  /// `final List<Widget>? actions;` is declaring a nullable final variable named `actions` of type
  /// `List<Widget>`. It is an optional parameter for the `AppScaffold` class that can be used to specify
  /// a list of widgets to display as actions in the app bar. If no actions are specified, the app bar
  /// will not display any actions.
  final List<Widget>? actions;

  /// `final bool? showAppBar;` is declaring a nullable final variable named `showAppBar` of type `bool`.
  /// It is an optional parameter for the `AppScaffold` class that can be used to specify whether or not
  /// to display the app bar. If `showAppBar` is `true`, the app bar will be displayed, otherwise it will
  /// not be displayed.
  final bool? showAppBar;

  /// The `final Widget? appBarLeading;` is declaring a nullable final variable named `appBarLeading` of
  /// type `Widget`. It is an optional parameter for the `AppScaffold` class that can be used to specify a
  /// widget to display as the leading widget in the app bar. The leading widget is typically used to
  /// display a back button or an icon on the left side of the app bar. If no widget is specified, the app
  /// bar will not display a leading widget.
  final Widget? appBarLeading;

  /// The `final Widget? bottomBar;` is declaring a nullable final variable named `bottomBar` of type
  /// `Widget`. It is an optional parameter for the `AppScaffold` class that can be used to specify a
  /// widget to display as the bottom navigation bar. If no widget is specified, the bottom navigation bar
  /// will not be displayed.
  final Widget? bottomBar;

  /// `final bool? innerPadding;` is declaring a nullable final variable named `innerPadding` of type
  /// `bool`. It is an optional parameter for the `AppScaffold` class that can be used to specify
  /// whether or not to add inner padding to the `body` widget. If `innerPadding` is `true` or not
  /// specified, the `body` widget will have inner padding of 10 pixels on all sides. If `innerPadding`
  /// is `false`, the `body` widget will not have any inner padding.
  final bool? innerPadding;

  @override
  Widget build(BuildContext context) {
    final bodyWithPadding = innerPadding != null && innerPadding == false
        ? body
        : Padding(padding: const EdgeInsets.all(10), child: body);
    return Scaffold(
      appBar: showAppBar!
          ? AppBar(
              title: Text(title ?? ''),
              leading: appBarLeading,
              actions: actions,
            )
          : null,
      bottomNavigationBar: bottomBar,
      body: bodyWithPadding,
    );
  }
}
