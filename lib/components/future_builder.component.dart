import 'package:flutter/material.dart';

/// The `AppFutureBuilder` class is a customizable widget that helps to handle
/// asynchronous data loading and rendering in Flutter.
class AppFutureBuilder<T> extends StatelessWidget {
  /// The `AppFutureBuilder` class is a customizable widget that helps to handle
  /// asynchronous data loading and rendering in Flutter.
  const AppFutureBuilder({
    required this.child,
    required this.future,
    super.key,
    this.loadingWidget,
  });

  /// `final Widget? loadingWidget;` is declaring a nullable `loadingWidget` property of type `Widget`.
  /// This property is optional and can be used to provide a custom widget to display while the future
  /// is loading. If no custom widget is provided, a default loading widget will be displayed.
  final Widget? loadingWidget;

  /// `final Widget Function(T? data) child;` is declaring a required property `child` of type `Widget
  /// Function(T? data)`. This property is a function that takes an optional generic type `T` data as
  /// input and returns a widget. It is used to build and render the UI based on the data received from
  /// the future. The `data` parameter is nullable because the future may not return any data or may
  /// return null.
  final Widget Function(T? data) child;

  /// `final Future<T> future;` is declaring a required property `future` of type `Future<T>`. This
  /// property is used to provide the future that the `AppFutureBuilder` widget will handle for
  /// asynchronous data loading and rendering. The type parameter `T` specifies the type of data that
  /// the future will return.
  final Future<T> future;

  @override
  Widget build(BuildContext context) {
    Widget renderLoading() {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return loadingWidget ?? renderLoading();

          case ConnectionState.none:
            return const Text('NOT CONNECTED TO THE FUTURE');

          case ConnectionState.done:
            return child.call(snapshot.data as T);

          case ConnectionState.active:
            return child.call(snapshot.data as T);
        }
      },
    );
  }
}
