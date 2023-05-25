import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';

part 'app.controller.g.dart';

@lazySingleton
class AppViewController = _AppViewControllerBase with _$AppViewController;

abstract class _AppViewControllerBase with Store {
  _AppViewControllerBase(this._authController);

  final AuthController _authController;

  @action
  Future<void> initState(BuildContext context) async {
    await _authController.initState(context);
  }
}
