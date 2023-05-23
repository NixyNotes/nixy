import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';

part 'login_view.controller.g.dart';

@injectable
class LoginViewController = _LoginViewControllerBase with _$LoginViewController;

abstract class _LoginViewControllerBase with Store {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController serverFormController = TextEditingController();

  onPressLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.router
          .navigate(ConnectToServerRoute(url: serverFormController.text));
    }
  }

  String? urlFormValidator(String? value) {
    if (value != null) {
      if (!value.startsWith("http")) {
        return "Url please";
      }

      return null;
    }
    return null;
  }
}
