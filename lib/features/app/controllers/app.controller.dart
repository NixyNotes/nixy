import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';

part 'app.controller.g.dart';

disposeAppViewController(AppViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeAppViewController)
class AppViewController = _AppViewControllerBase with _$AppViewController;

abstract class _AppViewControllerBase with Store {
  _AppViewControllerBase(this._authController, this._offlineService);

  final AuthController _authController;
  final OfflineService _offlineService;

  @action
  Future<void> initState(BuildContext context) async {
    await _authController.initState(context);
    _offlineService.checkForNetworkConditions();
  }

  dispose() {
    getIt.resetLazySingleton<OfflineService>();
  }
}
