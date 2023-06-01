import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/main.dart';

/// The `NetworkCheckerInterceptor` class is a Dart class that intercepts network requests and displays
/// a snackbar message if there is no internet access.
@lazySingleton
class NetworkCheckerInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final offlineService = getIt<OfflineService>();

    if (offlineService.hasInternetAccess) {
      return super.onRequest(options, handler);
    }

    scaffolMessengerKey.currentState
        ?.showSnackBar(const SnackBar(content: Text('No internet access!')));

    return;
  }
}
