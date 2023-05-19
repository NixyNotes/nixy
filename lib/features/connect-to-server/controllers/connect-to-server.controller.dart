import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'connect-to-server.controller.g.dart';

@injectable
class ConnectToServerController = _ConnectToServerControllerBase
    with _$ConnectToServerController;

abstract class _ConnectToServerControllerBase with Store {
  final _authStorage = getIt<AuthStorage>();

  void onLoadCustomScheme(NavigationRequest request, String serverAddress,
      BuildContext context) async {
    final splittedUrl = request.url.split("&");

    final username =
        splittedUrl[1].substring(splittedUrl[1].lastIndexOf("user:") + 5);
    final password =
        splittedUrl[2].substring(splittedUrl[2].lastIndexOf("password:") + 9);

    final stringToBase64 = utf8.fuse(base64);

    final userModel = User()
      ..password = password
      ..username = username
      ..server = serverAddress
      ..token = stringToBase64.encode("$username:$password");

    _authStorage.saveUser(userModel);

    AutoRouter.of(context).back();

    return null;
  }
}
