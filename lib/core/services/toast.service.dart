import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/components/custom_loading_toast.component.dart';
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
    final icon = _toastIcon(type);

    switch (type) {
      case ToastType.error:
        scaffolMessengerKey.currentContext
            ?.showErrorBar<bool>(content: Text(content), icon: Icon(icon));
      case ToastType.success:
        scaffolMessengerKey.currentContext
            ?.showSuccessBar<bool>(content: Text(content), icon: Icon(icon));
      case ToastType.info:
        scaffolMessengerKey.currentContext
            ?.showInfoBar<bool>(content: Text(content), icon: Icon(icon));
    }
  }

  /// This function shows a loading toast and returns a completer that completes when the toast is
  /// dismissed.
  ///
  /// Args:
  ///   content (String): The `content` parameter is an optional `String` that represents the message or
  /// content to be displayed in the loading toast. If provided, it will be displayed along with the
  /// loading indicator. If not provided, only the loading indicator will be displayed.
  ///
  /// Returns:
  ///   A `Completer<void>` object is being returned.
  Completer<void> showLoadingToast([String? content]) {
    final completer = Completer<void>();

    scaffolMessengerKey.currentContext?.showFlash(
      dismissCompleter: completer,
      persistent: true,
      builder: (context, controller) {
        return CustomLoadingToast(
          content: content,
          flashController: controller,
        );
      },
    );

    return completer;
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
