import 'package:flutter/material.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  const AppFutureBuilder({
    super.key,
    this.loadingWidget,
    required this.child,
    required this.future,
  });

  final Widget? loadingWidget;
  final Function(T? data) child;
  final Future<T> future;

  @override
  Widget build(BuildContext context) {
    Widget renderLoading() {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return loadingWidget ?? renderLoading();

          case ConnectionState.none:
            return const Text("NOT CONNECTED TO THE FUTURE");

          case ConnectionState.done:
            return child.call(snapshot.data as T);

          case ConnectionState.active:
            return child.call(snapshot.data as T);

          default:
            return loadingWidget ?? renderLoading();
        }
      },
    );
  }
}
