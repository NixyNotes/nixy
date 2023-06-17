import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';

part 'login_view.controller.g.dart';

/// Login view controller'
@lazySingleton
class LoginViewController = _LoginViewControllerBase with _$LoginViewController;

abstract class _LoginViewControllerBase with Store {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController serverFormController = TextEditingController();

  void onPressLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.pushNamed(
        RouterMeta.ConnectToServer.name,
        pathParameters: {'url': serverFormController.text},
      );
    }
  }

  String? urlFormValidator(String? value) {
    if (value != null) {
      if (!value.startsWith('http')) {
        return 'Url please';
      }

      return null;
    }
    return null;
  }
}
