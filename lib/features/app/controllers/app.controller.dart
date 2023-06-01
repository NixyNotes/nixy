import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';

part 'app.controller.g.dart';

/// The function disposes an instance of an AppViewController.
///
/// Args:
///   instance (AppViewController): The parameter "instance" is an object of the class
/// "AppViewController". The method "disposeAppViewController" takes this object as input and calls its
/// "dispose" method to release any resources or perform any necessary cleanup before the object is
/// destroyed.
void disposeAppViewController(AppViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeAppViewController)

/// App view controller
class AppViewController = _AppViewControllerBase with _$AppViewController;

abstract class _AppViewControllerBase with Store {
  _AppViewControllerBase(this._authController, this._offlineService);

  final AuthController _authController;
  final OfflineService _offlineService;

  @action
  Future<void> initState(BuildContext context) async {
    await _authController.initState(context);
    await _offlineService.checkForNetworkConditions();
  }

  void dispose() {
    getIt.resetLazySingleton<OfflineService>();
  }
}
