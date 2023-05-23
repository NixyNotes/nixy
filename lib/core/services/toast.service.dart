import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/main.dart';

enum ToastType { success, error, info }

@lazySingleton
class ToastService {
  showTextToast(String content, {ToastType? type}) {
    final backgroundColor = type != null ? _backgroundColor(type) : null;

    scaffolMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: backgroundColor,
    ));
  }

  _backgroundColor(ToastType type) {
    switch (type) {
      case ToastType.error:
        return Colors.red.shade500;

      case ToastType.info:
        return Colors.blueAccent;

      case ToastType.success:
        return Colors.greenAccent;

      default:
        return Colors.blueAccent;
    }
  }
}
