import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nextcloudnotes/main.dart';

enum ToastType { success, error, info }

@lazySingleton
class ToastService {
  showTextToast(String content, {ToastType type = ToastType.info}) {
    final backgroundColor = _backgroundColor(type);
    final icon = _toastIcon(type);

    final toast = MotionToast(
      primaryColor: backgroundColor,
      displaySideBar: false,
      icon: icon,
      dismissable: true,
      position: MotionToastPosition.top,
      backgroundType: BackgroundType.lighter,
      description: Text(content),
    );

    toast.show(scaffolMessengerKey.currentContext!);
  }

  MotionToast showLoadingToast() {
    final toast = MotionToast(
      primaryColor:
          Theme.of(scaffolMessengerKey.currentContext!).colorScheme.primary,
      displaySideBar: false,
      dismissable: false,
      description: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      toastDuration: const Duration(days: 365),
    );

    toast.show(scaffolMessengerKey.currentContext!);

    return toast;
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

  IconData _toastIcon(ToastType type) {
    switch (type) {
      case ToastType.error:
        return EvaIcons.closeCircle;

      case ToastType.info:
        return EvaIcons.info;

      case ToastType.success:
        return EvaIcons.checkmarkCircle2;

      default:
        return EvaIcons.info;
    }
  }
}
