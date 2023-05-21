import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

part 'login_view.controller.g.dart';

@injectable
class LoginViewController = _LoginViewControllerBase with _$LoginViewController;

abstract class _LoginViewControllerBase with Store {
  TextEditingController serverFormController = TextEditingController();

  onPressLogin(BuildContext context) {
    context.router
        .navigate(ConnectToServerRoute(url: serverFormController.text));
  }
}
