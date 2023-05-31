import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nextcloudnotes/main.dart';

/// `enum ToastType { success, error, info }` is defining an enumeration type called `ToastType` with
/// three possible values: `success`, `error`, and `info`. This enum is used to specify the type of
/// toast message to be displayed by the `ToastService` class.
enum ToastType { success, error, info }

/// The ToastService class provides methods for displaying different types of toast messages with
/// customizable icons and background colors.
@lazySingleton
class ToastService {
  /// The function shows a motion toast with a given content and type.
  ///
  /// Args:
  ///   content (String): The message or content that will be displayed in the toast.
  ///   type (ToastType): The type parameter is an optional parameter of type ToastType, which is used to
  /// specify the type of toast to be displayed. The default value is ToastType.info. The ToastType enum
  /// contains four values: info, success, warning, and error, which correspond to different types of
  /// toasts with different. Defaults to ToastType
  void showTextToast(String content, {ToastType type = ToastType.info}) {
    final backgroundColor = _backgroundColor(type);
    final icon = _toastIcon(type);

    MotionToast(
      primaryColor: backgroundColor,
      displaySideBar: false,
      icon: icon,
      position: MotionToastPosition.top,
      description: Text(content),
    ).show(scaffolMessengerKey.currentContext!);
  }

  /// The function creates and displays a loading toast with an optional content message.
  ///
  /// Args:
  ///   content (String): An optional string parameter that represents the text to be displayed alongside
  /// the loading indicator in the toast. If this parameter is not provided, only the loading indicator
  /// will be displayed.
  ///
  /// Returns:
  ///   a `MotionToast` widget.
  MotionToast showLoadingToast([String? content]) {
    final toast = MotionToast(
      primaryColor:
          Theme.of(scaffolMessengerKey.currentContext!).colorScheme.primary,
      displaySideBar: false,
      dismissable: false,
      description: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator.adaptive(),
          ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(content),
            )
        ],
      ),
      toastDuration: const Duration(days: 365),
    )..show(scaffolMessengerKey.currentContext!);

    return toast;
  }

  Color _backgroundColor(ToastType type) {
    switch (type) {
      case ToastType.error:
        return Colors.red.shade500;

      case ToastType.info:
        return Colors.blueAccent;

      case ToastType.success:
        return Colors.greenAccent;
    }
  }

  IconData _toastIcon(ToastType type) {
    switch (type) {
      case ToastType.error:
        return EvaIcons.closeCircle;

      case ToastType.info:
        return EvaIcons.info;

      case ToastType.success:
        return EvaIcons.checkmarkCircle2;
    }
  }
}
