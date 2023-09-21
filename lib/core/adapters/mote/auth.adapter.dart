import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/auth.adapter.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';
import 'package:nextcloudnotes/core/adapters/mote/models/login_response.model.dart';
import 'package:nextcloudnotes/core/adapters/mote/views/auth.view.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';

void disposeMoteAuthAdapter(MoteAuthAdapter instance) {
  instance.dispose();
}

@LazySingleton(
  dispose: disposeMoteAuthAdapter,
)
class MoteAuthAdapter extends AuthAdapter {
  MoteAuthAdapter(this._dioService, this._authController, this._toastService);

  final DioService _dioService;
  final AuthController _authController;
  final ToastService _toastService;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Timer _timer;

  @override
  String serverUri = 'http://localhost:8000';

  @override
  Future<bool> onLogin() async {
    try {
      final loadingToast = _toastService.showLoadingToast('Logging in...');
      final response = await _dioService.post('$serverUri/auth/log-in', {
        'email': usernameController.text,
        'password': passwordController.text,
      });

      final serializedData =
          MoteLoginResponse.fromJson(response.data as Map<String, dynamic>);

      final model = User()
        ..adapter = AdapterType.Mote
        ..id = serializedData.user.id
        ..isCurrent = true
        ..server = serverUri
        ..token = 'Bearer ${serializedData.accessToken}'
        ..username = serializedData.user.username;

      await _authController.login(model);
      loadingToast.complete();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  AuthAdapterType get type => AuthAdapterType.JWT;

  @override
  Widget view() => const MoteAuthView();

  @override
  String get title => 'Mote';

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _timer.cancel();
  }

  @override
  Future<void>? tokenRenewBackgroundService() {
    _timer = Timer.periodic(const Duration(minutes: 15), (_) => onLogin());
    return null;
  }
}
