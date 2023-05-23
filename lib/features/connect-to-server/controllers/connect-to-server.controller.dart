import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/services/log.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/models/login.model.dart';
import 'package:nextcloudnotes/models/login_poll.model.dart';
import 'package:nextcloudnotes/repositories/login.repository.dart';

part 'connect-to-server.controller.g.dart';

@injectable
class ConnectToServerController = _ConnectToServerControllerBase
    with _$ConnectToServerController;

abstract class _ConnectToServerControllerBase with Store {
  _ConnectToServerControllerBase(this._authController, this._loginRepository,
      this._toastService, this._logService);
  final AuthController _authController;
  final LoginRepository _loginRepository;
  final ToastService _toastService;
  final LogService _logService;

  late InAppWebViewController webViewController;

  Future<void> init(String serverUrl, BuildContext context) async {
    try {
      final loginPoll = await _fetchLoginPoll(serverUrl);

      final loginUrl = loginPoll.login;
      final token = loginPoll.poll.token;
      webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(loginUrl)));

      Timer.periodic(const Duration(seconds: 1), (timer) async {
        _fetchAppPassword(serverUrl, token).then((appPasswords) {
          _postLogin(
              username: appPasswords.loginName,
              password: appPasswords.appPassword,
              serverAddress: serverUrl,
              context: context);

          timer.cancel();
        }).onError((error, stackTrace) {
          if (error is! DioError) {
            _logService.logger.e(error);
            timer.cancel();
          }
        });
      });
    } catch (e) {
      context.router.back();

      _toastService.showTextToast(
        "Cannot reach Nextcloud instance.",
        type: ToastType.error,
      );
    }
  }

  void _postLogin(
      {required String username,
      required String password,
      required String serverAddress,
      required BuildContext context}) async {
    final stringToBase64 = utf8.fuse(base64);

    final userModel = User()
      ..password = password
      ..username = username
      ..server = serverAddress
      ..token = stringToBase64.encode("$username:$password");

    _authController.login(userModel);
  }

  Future<LoginPoll> _fetchLoginPoll(String serverUrl) async {
    final loginPoll = await _loginRepository.fetchLoginPoll(serverUrl);

    return loginPoll;
  }

  Future<Login> _fetchAppPassword(String serverUrl, String token) async {
    final login = await _loginRepository.fetchAppPassword(serverUrl, token);

    return login;
  }
}
