import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/utils/network_checker.dart';
import 'package:nextcloudnotes/main.dart';

@LazySingleton()
class NetworkCheckerInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final networkChecker = await checkForInternetAccess();

    if (networkChecker) {
      return super.onRequest(options, handler);
    }

    scaffolMessengerKey.currentState
        ?.showSnackBar(const SnackBar(content: Text("No internet access!")));

    return;
  }
}
